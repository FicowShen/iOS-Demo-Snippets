//
//  ViewController.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

final class TabOneRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        let vc: BaseVC & DeepLinkHandler
        switch request {
        case .tabOneTestPageA, .tabOneLastPageA:
            vc = TabOneTestPageAVC()
        case .tabOneTestPageB, .tabOneLastPageB:
            vc = TabOneTestPageBVC()
        default: return .notHandled(by: self)
        }
        navigationController?.pushViewController(vc, animated: false)
        return .nextHandler(vc)
    }
}

final class TabOneTestPageAVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        let vc = TabOneLastPageAVC()
        navigationController?.pushViewController(vc, animated: false)
        return .nextHandler(vc)
    }
}

final class TabOneTestPageBVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabOneLastPageB:
            // mock an error
            // should navigate to TabOneLastPageBVC
            //        let vc = TabOneLastPageBVC()
            //        navigationController?.pushViewController(vc, animated: false)
            return .notHandled(by: self)
        default: return .notHandled(by: self)
        }
    }
}


final class TabOneLastPageAVC: BaseVC, DeepLinkHandler {}

final class TabOneLastPageBVC: BaseVC, DeepLinkHandler {}
