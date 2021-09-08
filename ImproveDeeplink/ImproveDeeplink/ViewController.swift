//
//  ViewController.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

class BaseVC: UIViewController {

    let cancelBag = CancelBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addDescriptionLabel()
        setupNavigationItem()
    }

    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActions))
    }

    @objc func showActions() {
        let sheet = UIAlertController(title: "DeepLink Actions", message: nil, preferredStyle: .actionSheet)
        let deeplinkRequests: [DeepLinkRequest] = [
            .dashboard, .vendorBrowse,
            .registryProduct(name: "PC"),
            .registryCategory(id: "123"),
        ]
        deeplinkRequests.forEach { request in
            let action = UIAlertAction(title: String(describing: request), style: .default, handler: { _ in
                DeepLinkNavigator
                    .shared
                    .handle(request: request)
                    .sink { completion in
                        debugLog(completion)
                    } receiveValue: { handler in
                        debugLog(handler)
                    }
                    .store(in: &self.cancelBag.cancellables)
            })
            sheet.addAction(action)
        }
        present(sheet, animated: true, completion: nil)
    }
}

class TabVC: UITabBarController, DeepLinkHandler {
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

class DashboardVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        fatalError()
    }
}

class VendorHomeVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .vendorBrowse:
            let vc = VendorBrowseVC()
            navigationController?.pushViewController(vc, animated: true)
            return Just(nil)
                .setFailureType(to: DeepLinkError.self)
                .eraseToAnyPublisher()
        default: break
        }
        return Fail(error: .unknownRequest).eraseToAnyPublisher()
    }
}

class VendorBrowseVC: BaseVC {}

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


