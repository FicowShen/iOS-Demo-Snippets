//
//  VendorViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

final class TabTwoRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler, DeepLinkError> {
        switch request {
        case .tabTwoSecond:
            let vc = TabTwoSecondVC()
            navigationController?.pushViewController(vc, animated: false)
            return .next(vc)
        default: return .notHandled(by: self)
        }
    }
}

final class TabTwoSecondVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler, DeepLinkError> {
        switch request {
        case .tabTwoThird:
            let vc = TabTwoThirdVC()
            navigationController?.pushViewController(vc, animated: false)
            return .next(vc)
        default: return .notHandled(by: self)
        }
    }
}

final class TabTwoThirdVC: BaseVC, DeepLinkHandler {}
