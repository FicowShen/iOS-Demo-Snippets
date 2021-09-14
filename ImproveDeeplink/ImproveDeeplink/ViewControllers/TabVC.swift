//
//  TabVC.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit
import Combine

final class TabVC: UITabBarController, DeepLinkHandler {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vcs = [DashboardVC(), VendorHomeVC()].map { UINavigationController(rootViewController: $0) }
        setViewControllers(vcs, animated: false)
        tabBar.items?.enumerated().forEach {
            let nav = viewControllers![$0] as! UINavigationController
            $1.title = String(describing: type(of: nav.topViewController!))
        }
    }

    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .dashboard:
            return Future { [weak self] promise in
                self?.selectedIndex = 0
                promise(.success(nil))
            }.eraseToAnyPublisher()
        case .vendorHome:
            (viewControllers?[1] as? UINavigationController)?.popToRootViewController(animated: false)
            return Future { [weak self] promise in
                self?.setupVendorHome(promise: promise)
            }.eraseToAnyPublisher()
        default: break
        }
        return Future { $0(.failure(.unknownRequest)) }.eraseToAnyPublisher()
    }

    private func setupVendorHome(promise: @escaping (Result<DeepLinkHandler?, DeepLinkError>) -> Void) {
        self.selectedIndex = 1
        // some async code
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let nav = self.selectedViewController as? UINavigationController,
                  let vendorHome = nav.topViewController as? VendorHomeVC else {
                promise(.failure(.unexpected(message: "fail to load VendorHomeVC")))
                return
            }
            promise(.success(vendorHome))
        }
    }
}
