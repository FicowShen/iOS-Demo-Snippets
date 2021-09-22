//
//  DeepLink.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

typealias DeepLinkResult = AnyPublisher<DeepLinkHandler, DeepLinkError>
typealias DeepLinkCompletion = (Result<DeepLinkHandler, DeepLinkError>) -> Void

protocol DeepLinkHandler: AnyObject {
    func handle(request: DeepLinkRequest) -> DeepLinkResult
}

extension DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        return .next(self)
    }
}

enum DeepLinkError: Error {
    case notHandled(by: DeepLinkHandler)
    case failToHandle(by: DeepLinkHandler?)
    case timeout
}

enum DeepLinkRequest {
    // tab 1
    case tabOneRoot
    // A/B Test pages
    case tabOneTestPageA
    case tabOneTestPageB
    case tabOneLastPageA
    case tabOneLastPageB
    // tab 2
    case tabTwoRoot
    case tabTwoSecond
    case tabTwoThird
    // tab 3
    case tabThreeRoot
    case tabThreePathOne(id: String)
    case tabThreePathTwo(name: String)
    // timeout
    case testTimeout(seconds: Int)
}

final class DeepLinkNavigator: DeepLinkHandler {

    static let shared = DeepLinkNavigator()

    var rootDeepLinkHandler: DeepLinkHandler?
    var scheduler: RunLoop = RunLoop.main
    var timeout: RunLoop.SchedulerTimeType.Stride = .seconds(3)
    private var cancelBags = Set<CancelBag>()

    @discardableResult
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        guard let rootHandler = rootDeepLinkHandler else {
            return .failToHandle(by: self)
        }
        let rawPath = parsePath(request: request) + [request]
        let path = Array(rawPath.reversed())

        let cancelBag = CancelBag()
        cancelBags.insert(cancelBag)

        let tracer = PassthroughSubject<DeepLinkHandler, DeepLinkError>()
        let sharedTracer = tracer
            .timeout(timeout, scheduler: scheduler, options: .none) {
                return .timeout
            }
            .share()
        sharedTracer
            .subscribe(on: scheduler)
            .handleEvents(receiveRequest: { demand in
                tracer.send(rootHandler)
                self.handlePath(path,
                                handler: rootHandler,
                                cancelBag: cancelBag,
                                tracer: tracer)
            })
            .sink { [unowned self] completion in
                self.cancelBags.remove(cancelBag)
            } receiveValue: { handler in
//                print(handler)
            }
            .store(in: cancelBag)
        return sharedTracer.eraseToAnyPublisher()
    }

    private func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest] {
        switch request {
        // tab root
        case .tabOneRoot, .tabTwoRoot, .tabThreeRoot:
            return []
        // tab 1
        case .tabOneTestPageA, .tabOneTestPageB:
            return [.tabOneRoot]
        case .tabOneLastPageA:
            return [.tabOneRoot, .tabOneTestPageA]
        case .tabOneLastPageB:
            return [.tabOneRoot, .tabOneTestPageB]
        // tab 2
        case .tabTwoSecond:
            return [.tabTwoRoot]
        case .tabTwoThird:
            return [.tabTwoRoot, .tabTwoSecond]
        // tab 3
        case .tabThreePathOne:
            return [.tabThreeRoot]
        case .tabThreePathTwo:
            return [.tabThreeRoot]
        // timeout
        case .testTimeout:
            return []
        }
    }

    private func handlePath(_ path: [DeepLinkRequest],
                            handler: DeepLinkHandler,
                            cancelBag: CancelBag,
                            tracer: PassthroughSubject<DeepLinkHandler, DeepLinkError>) {
        guard let request = path.last else {
            tracer.send(completion: .finished)
            return
        }
        handler
            .handle(request: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    tracer.send(completion: .failure(error))
                case .finished:
//                    debugLog("finished request:", request, "for path:", path.map { String(describing: $0) })
                    break
                }
            } receiveValue: { [unowned self] nextHandler in
                tracer.send(nextHandler)
                self.handlePath(path.dropLast(),
                                handler: nextHandler,
                                cancelBag: cancelBag,
                                tracer: tracer)
            }
            .store(in: cancelBag)
    }

}

final class CancelBag: Hashable {
    static func == (lhs: CancelBag, rhs: CancelBag) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    var cancellables = Set<AnyCancellable>()

    func removeAll() {
        cancellables = []
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnyCancellable {
    func store(in bag: CancelBag) {
        store(in: &bag.cancellables)
    }
}

extension AnyPublisher where Output == DeepLinkHandler, Failure == DeepLinkError {
    static func next(_ handler: DeepLinkHandler) -> DeepLinkResult {
        return Just(handler)
            .setFailureType(to: DeepLinkError.self)
            .eraseToAnyPublisher()
    }

    static func future(_ attemptToFulfill: @escaping (@escaping Future<DeepLinkHandler, DeepLinkError>.Promise) -> Void) -> DeepLinkResult {
        return Future { attemptToFulfill($0) }.eraseToAnyPublisher()
    }

    static func notHandled(by handler: DeepLinkHandler) -> DeepLinkResult {
        return Fail(error: .notHandled(by: handler)).eraseToAnyPublisher()
    }

    static func failToHandle(by handler: DeepLinkHandler) -> DeepLinkResult {
        return Fail(error: .failToHandle(by: handler)).eraseToAnyPublisher()
    }
}
