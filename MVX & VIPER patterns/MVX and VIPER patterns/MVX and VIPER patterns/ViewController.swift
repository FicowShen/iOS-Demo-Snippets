//
//  ViewController.swift
//  MVX and VIPER patterns
//
//  Created by FicowShen on 2021/10/27.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func launchDependencyInjectionDemo(_ sender: Any) {
        let controller = DIController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

