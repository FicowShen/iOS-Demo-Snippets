//
//  VendorViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

class TabTwoRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .tabTwoSecond:
            let vc = TabTwoSecondVC()
            navigationController?.pushViewController(vc, animated: false)
            return Just(vc)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }
}

class TabTwoSecondVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .tabTwoThird:
            let vc = TabTwoThirdVC()
            navigationController?.pushViewController(vc, animated: false)
            return Just(nil)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }
}

class TabTwoThirdVC: BaseVC {}
