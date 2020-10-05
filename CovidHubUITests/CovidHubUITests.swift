//
//  CovidHubUITests.swift
//  CovidHubUITests
//
//  Created by Ahmed Sultan on 10/3/20.
//

import XCTest

class CovidHubUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testExample() throws {
        app.launch()
        let tableViewQuery = app.tables
        XCTAssertTrue(tableViewQuery.staticTexts["numberOfCasesID"].exists)
    }

}
