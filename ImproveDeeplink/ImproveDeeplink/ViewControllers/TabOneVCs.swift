//
//  ViewController.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

final class TabOneRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        let vc: BaseVC & DeepLinkHandler
        switch request {
        case .tabOneTestPageA:
            vc = TabOneTestPageAVC()
        case .tabOneTestPageB:
            vc = TabOneTestPageBVC()
        default:
            return Fail(error: .unknownRequest).eraseToAnyPublisher()
        }
        navigationController?.pushViewController(vc, animated: false)
        return Just(vc)
            .setFailureType(to: DeepLinkError.self)
            .eraseToAnyPublisher()
    }
}

final class TabOneTestPageAVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        let vc = TabOneLastPageAVC()
        navigationController?.pushViewController(vc, animated: false)
        return Just(nil)
            .setFailureType(to: DeepLinkError.self)
            .eraseToAnyPublisher()
    }
}

final class TabOneTestPageBVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        let vc = TabOneLastPageBVC()
        navigationController?.pushViewController(vc, animated: false)
        return Just(nil)
            .setFailureType(to: DeepLinkError.self)
            .eraseToAnyPublisher()
    }
}


final class TabOneLastPageAVC: BaseVC {}

final class TabOneLastPageBVC: BaseVC {}
