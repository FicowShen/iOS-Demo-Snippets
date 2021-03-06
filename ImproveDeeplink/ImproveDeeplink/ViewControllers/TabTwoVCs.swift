//
//  VendorViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

final class TabTwoRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabTwoSecond, .tabTwoThird:
            let vc = TabTwoSecondVC()
            navigationController?.pushViewController(vc, animated: false)
            return .nextHandler(vc)
        default: return .notHandled(by: self)
        }
    }
}

final class TabTwoSecondVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabTwoThird:
            let vc = TabTwoThirdVC()
            navigationController?.pushViewController(vc, animated: false)
            return .nextHandler(vc)
        default: return .notHandled(by: self)
        }
    }
}

final class TabTwoThirdVC: BaseVC, DeepLinkHandler {}
