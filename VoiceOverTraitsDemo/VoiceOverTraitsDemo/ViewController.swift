//
//  ViewController.swift
//  VoiceOverTraitsDemo
//
//  Created by FicowShen on 2021/8/5.
//

import UIKit

class MyTextField: UITextField {
    override class func accessibilityElementDidBecomeFocused() {
        super.accessibilityElementDidBecomeFocused()
    }
    override class func accessibilityElementDidLoseFocus() {
        super.accessibilityElementDidLoseFocus()
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var textField: MyTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.accessibilityTraits = [.staticText]
        textField.accessibilityHint = "picker item, Double tap to show the picker"
    }

    @IBAction func touchDown(_ sender: Any) {
        view.endEditing(true)
    }

}

