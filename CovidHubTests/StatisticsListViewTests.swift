//
//  StatisticsListViewTests.swift
//  CovidHubTests
//
//  Created by Ahmed Sultan on 10/5/20.
//

import XCTest
@testable import CovidHub

class StatisticsListViewTests: XCTestCase {

    var viewController: StatisticsListViewController!
    var viewModel: MockViewModel!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Countries", bundle: Bundle.main)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "StatisticsListViewController") as! StatisticsListViewController
        viewModel = MockViewModel()
        viewController = storyboardVC
        viewController.viewModel = viewModel
        viewController.loadViewIfNeeded()
    }

    func testSetupNavButton() {
        viewController.viewModel.statisticsType = .allCountries
        viewController.setupNav()
        XCTAssertEqual(viewController.title, "AllCountries".localized())
    }

    func testInitVM() {
        let exp = expectation(description: #function)
        viewController.initVM {
            XCTAssert(true)
            exp.fulfill()
        }
         wait(for: [exp], timeout: 2.0)
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        super.tearDown()
    }
}


class MockViewModel: StatisticsListViewModel {
    override func fetchStatistics(completion: ((Bool) -> Void)?) {
        completion?(true)
    }
}
