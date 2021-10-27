//
//  MVCViewController.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import UIKit

class MVCViewController: UIViewController {

    var userProfile: MVCUserProfile?
    private let nameLabel = UILabel()
    private let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ...
    }

    func saveNewName(_ name: String) {
        indicator.startAnimating()
        userProfile?.updateName(name) { [weak self] error in
            defer { self?.indicator.stopAnimating() }
            if let error = error {
                self?.showError(error)
                return
            }
            self?.showSuccess()
        }
    }

    func showSuccess() {
        // ...
    }

    func showError(_ error: Error) {
        // ...
    }

}
