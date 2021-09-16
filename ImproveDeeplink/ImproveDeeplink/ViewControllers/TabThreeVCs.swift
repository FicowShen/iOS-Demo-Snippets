//
//  RegistryViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

class TabThreeRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .tabThreePathOne(let id):
            return Future { [weak self] promise in
                self?.loadProductListPage(id: id, promise: promise)
            }.eraseToAnyPublisher()
        case .tabThreePathTwo(let name):
            let vc = TabThreePathTwoVC()
            vc.productName = name
            navigationController?.pushViewController(vc, animated: true)
            return Just(nil)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }

    func loadProductListPage(id: String, promise: @escaping (Result<DeepLinkHandler?, DeepLinkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc = TabThreePathOneVC()
            vc.categoryId = id
            self.navigationController?.pushViewController(vc, animated: true)
            promise(.success(nil))
        }
    }
}

class TabThreePathOneVC: BaseVC {
    var categoryId: String?
}

class TabThreePathTwoVC: BaseVC {
    var productName: String?
}

