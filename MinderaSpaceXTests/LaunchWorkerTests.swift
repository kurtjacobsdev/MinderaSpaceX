//
//  LaunchWorkerTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class LaunchWorkerTests: XCTestCase {

    func testLaunchWorkerSucceeds() throws {
        let expectation = XCTestExpectation(description: "Launch Worker Loads Successfully.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let worker = LaunchWorker(session: urlSessionMocked)
        worker.request { result in
            switch result {
            case let .success(launches):
                XCTAssertEqual(launches.count, 111)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLaunchWorkerFails() throws {
        let expectation = XCTestExpectation(description: "Launch Worker Loads With Failure.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMockFailing.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let worker = LaunchWorker(session: urlSessionMocked)
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
