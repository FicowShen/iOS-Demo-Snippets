//
//  ImproveDeeplinkTests.swift
//  ImproveDeeplinkTests
//
//  Created by FicowShen on 2021/9/7.
//

import XCTest
@testable import ImproveDeeplink

class ImproveDeeplinkTests: XCTestCase {

    var cancelBag: CancelBag!
    var navigator: DeepLinkNavigator!
    var rootHandler: MockRootDeepLinkHandler!

    override func setUpWithError() throws {
        cancelBag = CancelBag()
        navigator = DeepLinkNavigator()
        rootHandler = MockRootDeepLinkHandler()
        navigator.rootDeepLinkHandler = rootHandler
    }

    func testTimeout() throws {
        let expect = expectation(description: #function)
        navigator.timeout = .seconds(1)
        navigator
            .handle(request: .testTimeout(seconds: 1))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    guard case .timeout = error else {
                        XCTFail("should get timeout error")
                        return
                    }
                    expect.fulfill()
                case .finished: XCTFail("should fail due to timeout")
                }
            } receiveValue: { handler in
                XCTAssertTrue(handler === self.rootHandler)
            }
            .store(in: cancelBag)
        wait(for: [expect], timeout: 1)
    }

    func testSyncNavigation() throws {
        var handlers = [DeepLinkHandler]()
        let handlerTypes: [DeepLinkHandler.Type] = [
            MockRootDeepLinkHandler.self,
            MockTabTwoRootDeepLinkHandler.self,
            MockTabTwoSecondDeepLinkHandler.self
        ]
        let expect = expectation(description: #function)
        navigator
            .handle(request: .tabTwoSecond)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("should not fail due to \(error)")
                case .finished:
                    XCTAssertEqual(handlers.count, handlerTypes.count)
                    for i in 0..<handlers.count {
                        XCTAssertTrue(type(of: handlers[i]) == handlerTypes[i])
                    }
                }
                expect.fulfill()
            } receiveValue: { handler in
                handlers.append(handler)
            }
            .store(in: cancelBag)
        wait(for: [expect], timeout: 1)
    }

    func testAsyncNavigation() throws {
        var handlers = [DeepLinkHandler]()
        let handlerTypes: [DeepLinkHandler.Type] = [
            MockRootDeepLinkHandler.self,
            MockTabTwoRootDeepLinkHandler.self,
            MockTabTwoSecondDeepLinkHandler.self,
            MockTabTwoThirdDeepLinkHandler.self
        ]
        let expect = expectation(description: #function)
        navigator
            .handle(request: .tabTwoThird)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("should not fail due to \(error)")
                case .finished:
                    XCTAssertEqual(handlers.count, handlerTypes.count)
                    for i in 0..<handlers.count {
                        XCTAssertTrue(type(of: handlers[i]) == handlerTypes[i])
                    }
                }
                expect.fulfill()
            } receiveValue: { handler in
                handlers.append(handler)
            }
            .store(in: cancelBag)
        wait(for: [expect], timeout: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

final class MockRootDeepLinkHandler: DeepLinkHandler {
    let tabTwoRoot = MockTabTwoRootDeepLinkHandler()

    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .testTimeout:
            return .future { promise in }
        case .tabTwoRoot:
            return .next(tabTwoRoot)
        default:
            return .notHandled(by: self)
        }
    }
}

final class MockTabTwoRootDeepLinkHandler: DeepLinkHandler {
    let tabTwoSecond = MockTabTwoSecondDeepLinkHandler()

    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabTwoSecond:
            return .next(tabTwoSecond)
        default:
            return .notHandled(by: self)
        }
    }
}

final class MockTabTwoSecondDeepLinkHandler: DeepLinkHandler {
    let tabTwoThird = MockTabTwoThirdDeepLinkHandler()

    func handle(request: DeepLinkRequest) -> DeepLinkResult {
        switch request {
        case .tabTwoThird:
            return .future { promise in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
                    promise(.success(self.tabTwoThird))
                }
            }
        default:
            return .notHandled(by: self)
        }
    }
}

final class MockTabTwoThirdDeepLinkHandler: DeepLinkHandler {}
