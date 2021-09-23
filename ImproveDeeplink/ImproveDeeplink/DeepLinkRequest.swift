//
//  DeepLinkRequest.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/23.
//

import UIKit

enum DeepLinkRequest {
    // tab 1
    case tabOneRoot
    // A/B Test pages
    case tabOneTestPageA
    case tabOneTestPageB
    case tabOneLastPageA
    case tabOneLastPageB
    // tab 2
    case tabTwoRoot
    case tabTwoSecond
    case tabTwoThird
    // tab 3
    case tabThreeRoot
    case tabThreePathOne(id: String)
    case tabThreePathTwo(name: String)
    // direct present
    case show(page: UIViewController, animated: Bool)
    // timeout
    case testTimeout(seconds: Int)
}
