//
//  RegistryViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

final class TabThreeRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabThreePathOne(let id):
            return .future { [weak self] promise in
                self?.asyncLoadPage(id: id, promise: promise)
            }
        case .tabThreePathTwo(let name):
            let vc = TabThreePathTwoVC()
            vc.productName = name
            navigationController?.pushViewController(vc, animated: true)
            return .next(vc)
        default: return .notHandled(by: self)
        }
    }

    func asyncLoadPage(id: String, promise: @escaping DeepLinkCompletion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc = TabThreePathOneVC()
            vc.categoryId = id
            self.navigationController?.pushViewController(vc, animated: true)
            promise(.success(vc))
        }
    }
}

final class TabThreePathOneVC: BaseVC, DeepLinkHandler {
    var categoryId: String?
}

final class TabThreePathTwoVC: BaseVC, DeepLinkHandler {
    var productName: String?
}

