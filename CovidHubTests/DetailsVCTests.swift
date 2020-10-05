//
//  DetailsVCTests.swift
//  CovidHubTests
//
//  Created by Ahmed Sultan on 10/5/20.
//

import XCTest
@testable import CovidHub

class DetailsVCTests: XCTestCase {


    var viewController: DetailsViewController!
    var detailsVM: CovidStatisticsCellViewModel!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Countries", bundle: Bundle.main)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        viewController = storyboardVC
        detailsVM = CovidStatisticsCellViewModel(title: "turkey",
                                                                dailyTests: "11",
                                                                newCases: "",
                                                                newDeath: "",
                                                                totalCases: "",
                                                                totalDeath: "")
        viewController.viewModel = detailsVM
        viewController.loadViewIfNeeded()
    }

    func testSetup() {
        viewController.configure()
        XCTAssertEqual(detailsVM.dailyTests, "11")
    }
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
}
