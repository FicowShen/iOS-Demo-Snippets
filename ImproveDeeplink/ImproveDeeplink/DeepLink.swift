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

enum DeepLinkError: Error {
    case unknownRequest
    case unexpected(message: String)
}

enum DeepLinkRequest {

    case dashboard

    case vendorHome
    case vendorBrowse
    case vendorStorefront

    case registryOverview
    case registryCategory(id: String)
    case registryProduct(name: String)
}

final class DeepLinkNavigator: DeepLinkHandler {

    static let shared = DeepLinkNavigator()

    var rootDeepLinkHandler: DeepLinkHandler?
    private var cancelBags = Set<CancelBag>()

    @discardableResult
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        guard let rootDeepLinkHandler = rootDeepLinkHandler else {
            return Future { $0(.failure(.unexpected(message: "rootDeepLinkHandler is nil"))) }.eraseToAnyPublisher()
        }
        let rawPath = parsePath(request: request) + [request]
        let path = Array(rawPath.reversed())

        let cancelBag = CancelBag()
        cancelBags.insert(cancelBag)

        let subject = PassthroughSubject<DeepLinkHandler?, DeepLinkError>()
        Future { [unowned self] promise in
            self.handlePath(path,
                            handler: rootDeepLinkHandler,
                            cancelBag: cancelBag,
                            promise: promise)
        }.sink { [unowned self] completion in
            subject.send(completion: completion)
            self.cancelBags.remove(cancelBag)
        } receiveValue: { [unowned self] handler in
            subject.send(self)
        }.store(in: &cancelBag.cancellables)

        return subject.eraseToAnyPublisher()
    }

    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest] {
        switch request {
        // tab
        case .dashboard, .vendorHome, .registryOverview:
            return []
        // vendor
        case .vendorBrowse:
            return [.vendorHome]
        case .vendorStorefront:
            return [.vendorHome, .vendorBrowse]
        // registry
        case .registryCategory:
            return [.registryOverview]
        case .registryProduct:
            return [.registryOverview]
        }
    }

    func handlePath(_ path: [DeepLinkRequest], handler: DeepLinkHandler?, cancelBag: CancelBag, promise: @escaping (Result<DeepLinkHandler?, DeepLinkError>) -> Void) {
        guard let handler = handler,
              let request = path.last else {
            promise(.success(nil))
            return
        }
        handler
            .handle(request: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    promise(.failure(error))
                case .finished:
                    debugLog("finished request:", request,
                             "for path:", path.map { String(describing: $0) })
                }
            } receiveValue: { [unowned self] nextHandler in
                self.handlePath(path.dropLast(),
                                handler: nextHandler,
                                cancelBag: cancelBag,
                                promise: promise)
            }
            .store(in: &cancelBag.cancellables)
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
