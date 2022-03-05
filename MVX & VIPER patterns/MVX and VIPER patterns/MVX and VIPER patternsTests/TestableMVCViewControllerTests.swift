//
//  TestableMVCViewControllerTests.swift
//  MVX and VIPER patternsTests
//
//  Created by Ficow on 2022/3/5.
//

import XCTest
@testable import MVX_and_VIPER_patterns

class TestableMVCViewControllerTests: XCTestCase {
    var controller: TestableMVCViewController!
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    override func setUpWithError() throws {
        controller = TestableMVCViewController()
        controller.taskMaker = self
        controller.userProfile = TestableMVCUserProfile(id: UUID(), name: "name")
    }

    func testSaveNewNameFailed() throws {
        controller.saveNewName("test")
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "error"])
        completionHandler?(nil, nil, error)
        XCTAssertEqual(controller.userProfile?.name, "name")
        XCTAssertEqual(controller.resultLabel.text, error.localizedDescription)
    }

    func testSaveNewNameSucceed() throws {
        let newName = "new"
        controller.saveNewName(newName)
        completionHandler?(Data(), nil, nil)
        XCTAssertEqual(controller.userProfile?.name, newName)
        XCTAssertEqual(controller.resultLabel.text, "success")
    }
}

extension TestableMVCViewControllerTests: DataTaskMaker {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
}
