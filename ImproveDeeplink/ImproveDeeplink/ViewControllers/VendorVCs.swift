//
//  VendorViewControllers.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

class VendorHomeVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .vendorBrowse:
            let vc = VendorBrowseVC()
            navigationController?.pushViewController(vc, animated: false)
            return Just(vc)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }
}

class VendorBrowseVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .vendorStorefront:
            let vc = VendorStorefrontVC()
            navigationController?.pushViewController(vc, animated: false)
            return Just(nil)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }
}

class VendorStorefrontVC: BaseVC {}
