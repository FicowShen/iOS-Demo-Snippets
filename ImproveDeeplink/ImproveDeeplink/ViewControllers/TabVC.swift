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
        let vcs = [TabOneRootVC(), TabTwoRootVC(), TabThreeRootVC()].map { UINavigationController(rootViewController: $0) }
        setViewControllers(vcs, animated: false)
        tabBar.items?.enumerated().forEach {
            let nav = viewControllers![$0] as! UINavigationController
            $1.title = String(describing: type(of: nav.topViewController!))
        }
    }

    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        switch request {
        case .tabOneRoot:
            return Future { [weak self] promise in
                self?.showTabRoot(tabIndex: 0)
                guard let nav = self?.selectedViewController as? UINavigationController,
                      let root = nav.topViewController as? TabOneRootVC else {
                    promise(.failure(.unexpected(message: "fail to load \(TabOneRootVC.self)")))
                    return
                }
                promise(.success(root))
            }.eraseToAnyPublisher()
        case .tabTwoRoot:
            return Future { [weak self] promise in
                self?.asyncLoadPage(promise: promise)
            }.eraseToAnyPublisher()
        case .tabThreeRoot:
            return Future { [weak self] promise in
                self?.showTabRoot(tabIndex: 2)
                guard let nav = self?.selectedViewController as? UINavigationController,
                      let root = nav.topViewController as? TabThreeRootVC else {
                    promise(.failure(.unexpected(message: "fail to load \(TabThreeRootVC.self)")))
                    return
                }
                promise(.success(root))
            }.eraseToAnyPublisher()
        default: break
        }
        return Future { $0(.failure(.unknownRequest)) }.eraseToAnyPublisher()
    }

    private func showTabRoot(tabIndex: Int) {
        selectedIndex = tabIndex
        (self.viewControllers?[tabIndex] as? UINavigationController)?.popToRootViewController(animated: false)
    }
    private func asyncLoadPage(promise: @escaping (Result<DeepLinkHandler?, DeepLinkError>) -> Void) {
        self.showTabRoot(tabIndex: 1)
        // some async code
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let nav = self.selectedViewController as? UINavigationController,
                  let tabTwoRoot = nav.topViewController as? TabTwoRootVC else {
                promise(.failure(.unexpected(message: "fail to load \(TabTwoRootVC.self)")))
                return
            }
            promise(.success(tabTwoRoot))
        }
    }
}
