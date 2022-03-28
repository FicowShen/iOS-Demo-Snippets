//
//  Controller.swift
//  MVX and VIPER patterns
//
//  Created by Ficow on 2022/3/27.
//

import UIKit

final class DIController: UIViewController {

    let userInfoView = DIUserInfoView()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    private let userInfoLoader: DIUserInfoLoaderConvertible

    init(userInfoLoader: DIUserInfoLoaderConvertible = DIUserInfoLoader()) {
        self.userInfoLoader = userInfoLoader
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    private func setupUI() {
        title = "Dependency Injection"
        view.backgroundColor = .white

        [userInfoView, activityIndicator].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        NSLayoutConstraint.activate([
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupData() {
        activityIndicator.startAnimating()
        userInfoLoader.loadUserInfo { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.userInfoView.user = user
                case .failure(let error):
                    print(error)
                    self.userInfoView.user = nil
                }
                self.activityIndicator.stopAnimating()
            }
        }
    }

}
