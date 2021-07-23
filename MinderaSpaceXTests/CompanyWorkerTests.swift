//
//  CompanyWorkerTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class CompanyWorkerTests: XCTestCase {

    func testCompanyWorkerSucceeds() throws {
        let expectation = XCTestExpectation(description: "Company Worker Loads Successfully.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let worker = CompanyWorker(session: urlSessionMocked)
        worker.request { result in
            switch result {
            case let .success(info):
                XCTAssertTrue(info.employees == 7000)
                XCTAssertTrue(info.founded == 2002)
                XCTAssertTrue(info.founder == "Elon Musk")
                XCTAssertTrue(info.launchSites == 3)
                XCTAssertTrue(info.name == "SpaceX")
                XCTAssertTrue(info.valuation == 27500000000.0)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCompanyWorkerFails() throws {
        let expectation = XCTestExpectation(description: "Company Worker Loads With Failure.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMockFailing.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let worker = CompanyWorker(session: urlSessionMocked)
        worker.request { result in
            switch result {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

}
