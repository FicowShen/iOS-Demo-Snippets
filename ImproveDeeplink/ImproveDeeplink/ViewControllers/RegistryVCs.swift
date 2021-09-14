//
//  RegistryViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

class RegistryOverviewVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .registryProduct(let name):
            let vc = RegistryProductVC()
            vc.productName = name
            navigationController?.pushViewController(vc, animated: true)
            return Just(nil)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        case .registryCategory(let id):
            return Future { [weak self] promise in
                self?.loadProductListPage(id: id, promise: promise)
            }.eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }

    func loadProductListPage(id: String, promise: @escaping (Result<DeepLinkHandler?, DeepLinkError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc = RegistryProductListVC()
            vc.categoryId = id
            self.navigationController?.pushViewController(vc, animated: true)
            promise(.success(nil))
        }
    }
}

class RegistryProductListVC: BaseVC {
    var categoryId: String?
}

class RegistryProductVC: BaseVC {
    var productName: String?
}

