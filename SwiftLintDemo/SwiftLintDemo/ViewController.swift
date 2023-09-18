//
//  ViewController.swift
//  SwiftLintDemo
//
//  Created by Ficow on 2023/9/17.
//

import UIKit

class ViewController   :  UIViewController {

    private(set) var models :  [Model] = [Model]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.setupModels()
    }

    func setupModels()   {
        models.append(Model.gz)
        models.append(Model.xa)

        // TODO: <FICOW> handle the display logic
    }
} // trailing_newline


