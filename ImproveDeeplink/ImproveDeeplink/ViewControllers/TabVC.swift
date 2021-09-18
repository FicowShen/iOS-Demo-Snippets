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

    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabOneRoot:
            return .future { [weak self] promise in
                self?.showTabRoot(tabIndex: 0)
                guard let nav = self?.selectedViewController as? UINavigationController,
                      let root = nav.topViewController as? TabOneRootVC else {
                    promise(.failure(.failToHandle(by: self)))
                    return
                }
                promise(.success(root))
            }
        case .tabTwoRoot:
            return .future {  [weak self] promise in
                self?.asyncLoadPage(promise: promise)
            }
        case .tabThreeRoot:
            return .future {  [weak self] promise in
                self?.showTabRoot(tabIndex: 2)
                guard let nav = self?.selectedViewController as? UINavigationController,
                      let root = nav.topViewController as? TabThreeRootVC else {
                    promise(.failure(.failToHandle(by: self)))
                    return
                }
                promise(.success(root))
            }
        default: return .notHandled(by: self)
        }
    }

    private func showTabRoot(tabIndex: Int) {
        selectedIndex = tabIndex
        (self.viewControllers?[tabIndex] as? UINavigationController)?.popToRootViewController(animated: false)
    }
    private func asyncLoadPage(promise: @escaping DeepLinkCompletion) {
        self.showTabRoot(tabIndex: 1)
        // some async code
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let nav = self.selectedViewController as? UINavigationController,
                  let tabTwoRoot = nav.topViewController as? TabTwoRootVC else {
                promise(.failure(.failToHandle(by: self)))
                return
            }
            promise(.success(tabTwoRoot))
        }
    }
}
