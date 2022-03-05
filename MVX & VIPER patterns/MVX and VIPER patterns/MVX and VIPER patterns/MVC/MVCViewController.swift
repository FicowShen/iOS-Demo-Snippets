//
//  MVCViewController.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import UIKit

class MVCViewController: UIViewController {

    var userProfile: MVCUserProfile?
    private let indicator = UIActivityIndicatorView()

    // ViewController 负责接收 UI 交互事件，然后调用 Model 的方法处理数据，最终将返回结果展示到 View 上
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

protocol DataTaskMaker: AnyObject {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class DefaultDataTaskMaker: DataTaskMaker {
    let session = URLSession(configuration: .default)

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session
            .dataTask(with: url, completionHandler: completionHandler)
            .resume()
    }
}

class TestableMVCViewController: UIViewController {
    // taskMaker 可以被替换为其他遵守 DataTaskMaker 协议的对象
    var taskMaker: DataTaskMaker = DefaultDataTaskMaker()

    var userProfile: TestableMVCUserProfile?
    let resultLabel = UILabel()
    private let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ...
    }

    func saveNewName(_ name: String) {
        indicator.startAnimating()
        userProfile?.updateName(name, taskMaker: taskMaker) { [weak self] error in
            defer { self?.indicator.stopAnimating() }
            if let error = error {
                self?.showError(error)
                return
            }
            self?.showSuccess()
        }
    }

    func showSuccess() {
        resultLabel.text = "success"
    }

    func showError(_ error: Error) {
        resultLabel.text = error.localizedDescription
    }
}
