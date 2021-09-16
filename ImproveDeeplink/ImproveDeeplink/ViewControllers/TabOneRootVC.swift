//
//  ViewController.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/7.
//

import UIKit
import Combine

final class TabOneRootVC: BaseVC, DeepLinkHandler {
    func handle(request: DeepLinkRequest) -> AnyPublisher<DeepLinkHandler?, DeepLinkError> {
        fatalError()
    }
}

