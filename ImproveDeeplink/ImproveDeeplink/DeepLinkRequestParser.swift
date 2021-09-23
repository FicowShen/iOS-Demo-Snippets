//
//  DeepLinkRequestParser.swift
//  ImproveDeeplink
//
//  Created by FicowShen on 2021/9/23.
//

import Foundation

protocol DeepLinkRequestParser {
    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]?
}

struct DefaultDeepLinkRequestParser: DeepLinkRequestParser {
    var requestParser: [DeepLinkRequestParser] = [
        RootDeepLinkRequestParser(),
        TabOneDeepLinkRequestParser(),
        TabTwoDeepLinkRequestParser(),
        TabThreeDeepLinkRequestParser()
    ]

    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]? {
        var pathRequests: [DeepLinkRequest]?
        for parser in requestParser {
            if let path = parser.parsePath(request: request) {
                pathRequests = path
                break
            }
        }
        if let path = pathRequests {
            pathRequests = Array((path + [request]).reversed())
        }
        return pathRequests
    }
}

struct RootDeepLinkRequestParser: DeepLinkRequestParser {
    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]? {
        switch request {
        case .tabOneRoot, .tabTwoRoot, .tabThreeRoot:
            return []
        // direct present
        case .show:
            return []
        // timeout
        case .testTimeout:
            return []
        default:
            return nil
        }
    }
}

struct TabOneDeepLinkRequestParser: DeepLinkRequestParser {
    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]? {
        switch request {
        case .tabOneTestPageA, .tabOneTestPageB:
            return [.tabOneRoot]
        case .tabOneLastPageA:
            return [.tabOneRoot, .tabOneTestPageA]
        case .tabOneLastPageB: // mock error, should fail
            return [.tabOneRoot, .tabOneTestPageB]
        default:
            return nil
        }
    }
}

struct TabTwoDeepLinkRequestParser: DeepLinkRequestParser {
    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]? {
        switch request {
        case .tabTwoSecond:
            return [.tabTwoRoot]
        case .tabTwoThird:
            return [.tabTwoRoot, .tabTwoSecond]
        default:
            return nil
        }
    }
}


struct TabThreeDeepLinkRequestParser: DeepLinkRequestParser {
    func parsePath(request: DeepLinkRequest) -> [DeepLinkRequest]? {
        switch request {
        case .tabThreePathOne:
            return [.tabThreeRoot]
        case .tabThreePathTwo:
            return [.tabThreeRoot]
        default:
            return nil
        }
    }
}
