//
//  ViewController.swift
//  SwiftLintDemo
//
//  Created by Ficow on 2023/9/17.
//

import UIKit

class ViewController   :  UIViewController {

    // explicit_init
    private(set) var viewModel = ViewModel.init(title: String.init("Test"))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = viewModel.title
    }

    func convertValues(a: Int ,  b: Int,  c: Int) -> [String] { // comma, identifier_name
        return [a, b, c].compactMap { String.init($0) } // explicit_init
    }
} // trailing_newline


