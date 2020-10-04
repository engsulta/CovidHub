//
//  CovidHubNetworkTests.swift
//  CovidHubTests
//
//  Created by Ahmed Sultan on 10/3/20.
//

import XCTest
@testable import CovidHub

class CovidHubNetworkTests: XCTestCase {
    var mockNetworkManager: CovidNetworkClient!
    var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        mockNetworkManager = CovidNetworkClient(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testRequestSucceed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: .statistics,
                                 model: TestModel.self){ [weak self] (response, error)  in

            guard let self = self else { XCTFail("unknow"); return }

            if error == nil {
                XCTAssertEqual((response as? TestModel)?.name , self.mockSession.model.name)
                XCTAssertEqual(self.mockSession.urlSessionDataTaskMock.isResumedCalled, true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }

    func testRequestFailed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: .statistics,
                                 model: String.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(error, NetworkError.faildToDecode)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }

    func testCancellingTask() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(endPoint: .statistics, model: String.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(self.mockSession.urlSessionDataTaskMock.isCancelledCalled, true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
            }?.cancel()
        wait(for: [exp], timeout: 2.0)
    }

    func testStatisticsEndPointBuilder() {
        let statisticsEndPoint = CovidApiEndPoint.statistics
        XCTAssertEqual(statisticsEndPoint.url?.url?.absoluteString,
                       "\(Constants.baseURL)/statistics")

        let historyEndPoint = CovidApiEndPoint.history(country: "Turkey", day: "02/10/2020")
        XCTAssertEqual(historyEndPoint.url?.allHTTPHeaderFields, Constants.headers)
        XCTAssertEqual(historyEndPoint.parameters, ["day": "02/10/2020", "country": "Turkey"])
    }

    func testErrorLocalizedDescription() {
        let expected: [String] = ["missing URL",
                                  "unable to decode the response",
                                  "unknown"]

        for (index, testError) in [
            NetworkError.missingURL,
            NetworkError.faildToDecode,
            NetworkError.noNetwork].enumerated() {
                XCTAssertEqual(testError.rawValue, expected[index])
        }
    }
}

//MARK:- Mock Session
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
class MockSession: URLSessionProtocol {

    var urlSessionDataTaskMock =  URLSessionDataTaskMock()
    var model = TestModel(name: "myName")
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let testData = try? JSONEncoder().encode(model)
        completionHandler(testData,nil,nil)


        return urlSessionDataTaskMock
    }

}

//MARK:- Mock Model
struct TestModel: Codable {
    var name: String?
}

//MARK:- Mock Data Task
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {

    var isResumedCalled = false
    var isCancelledCalled = false
    func resume() {
        isResumedCalled = true
    }
    func cancel() {
        isCancelledCalled = true
    }
}
