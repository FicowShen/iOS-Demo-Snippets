//
//  DeepLink.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

protocol DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError>
}

extension DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        Fail(error: .unexpected(message: "\(request) is not handled by \(self)")).eraseToAnyPublisher()
    }
}

enum DeepLinkError: Error {
    case unknownRequest
    case unexpected(message: String)
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
}

final class DeepLinkNavigator: DeepLinkHandler {

    static let shared = DeepLinkNavigator()

    var rootDeepLinkHandler: DeepLinkHandler?
    private var cancelBags = Set<CancelBag>()

    @discardableResult
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        guard let rootHandler = rootDeepLinkHandler else {
            return Future { $0(.failure(.unexpected(message: "rootDeepLinkHandler is nil"))) }.eraseToAnyPublisher()
        }
        let rawPath = parsePath(request: request) + [request]
        let path = Array(rawPath.reversed())

        let cancelBag = CancelBag()
        cancelBags.insert(cancelBag)

        let tracer = PassthroughSubject<DeepLinkHandler?, DeepLinkError>()
        handlePath(path,
                   handler: rootHandler,
                   cancelBag: cancelBag,
                   tracer: tracer)

        let output = PassthroughSubject<DeepLinkHandler?, DeepLinkError>()
        tracer.sink { [unowned self] completion in
            output.send(completion: completion)
            self.cancelBags.remove(cancelBag)
        } receiveValue: { handler in
            output.send(handler)
        }.store(in: cancelBag)

        return output.eraseToAnyPublisher()
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
        }
    }

    func handlePath(_ path: [DeepLinkRequest],
                    handler: DeepLinkHandler?,
                    cancelBag: CancelBag,
                    tracer: PassthroughSubject<DeepLinkHandler?, DeepLinkError>) {
        guard let handler = handler,
              let request = path.last else {
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnyCancellable {
    func store(in bag: CancelBag) {
        store(in: &bag.cancellables)
    }
}
