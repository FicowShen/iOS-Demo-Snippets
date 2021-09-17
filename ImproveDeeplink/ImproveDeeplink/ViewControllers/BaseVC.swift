//
//  BaseVC.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/14.
//

import UIKit

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
            .tabOneRoot, .tabOneLastPageA, .tabOneLastPageB,
            .tabTwoSecond, .tabTwoThird,
            .tabThreePathTwo(name: "PC"),
            .tabThreePathOne(id: "123"),
        ]
        deeplinkRequests.forEach { request in
            let action = UIAlertAction(title: String(describing: request), style: .default, handler: { _ in
                DeepLinkNavigator
                    .shared
                    .handle(request: request)
                    .sink { completion in
                        debugLog("finished deeplink request: \(request)")
                    } receiveValue: { handler in
                        debugLog("request: \(request), handler: \(handler)")
                    }
                    .store(in: self.cancelBag)
            })
            sheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
    }
}
