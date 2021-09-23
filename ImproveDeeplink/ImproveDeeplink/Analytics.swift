//
//  Analytics.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/23.
//

import Foundation

protocol ErrorTracker {
    func logDeepLinkFailure(request: DeepLinkRequest, error: Error)
}

final class Analytics: ErrorTracker {
    static let shared = Analytics()

    func logDeepLinkFailure(request: DeepLinkRequest, error: Error) {
        debugLog("fail to handle deep-link request: \(request), error: \(error)")
    }
}
