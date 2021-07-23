//
//  NetworkServiceListingUseCaseTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class NetworkServiceListingUseCaseTests: XCTestCase {
    
    func testNetworkServiceListingUseCaseSuccess() {
        let expectation = XCTestExpectation(description: "Use Case Loads Successfully.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let companyWorker = CompanyWorker(session: urlSessionMocked)
        let launchWorker = LaunchWorker(session: urlSessionMocked)
        let networkServiceListingUseCase = NetworkServiceListingUseCase(companyWorker: companyWorker, launchWorker: launchWorker)
        
        networkServiceListingUseCase.fetch { result in
            switch result {
            case let .success((info, launch)):
                
                XCTAssertTrue(info.first?.employees == 7000)
                XCTAssertTrue(info.first?.founded == 2002)
                XCTAssertTrue(info.first?.founder == "Elon Musk")
                XCTAssertTrue(info.first?.launchSites == 3)
                XCTAssertTrue(info.first?.name == "SpaceX")
                XCTAssertTrue(info.first?.valuation == 27500000000.0)
                
                XCTAssertEqual(launch.count, 111)
                
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testNetworkServiceListingUseCaseFailure() {
        let expectation = XCTestExpectation(description: "Use Case Loads Failing.")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMockFailing.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let companyWorker = CompanyWorker(session: urlSessionMocked)
        let launchWorker = LaunchWorker(session: urlSessionMocked)
        let networkServiceListingUseCase = NetworkServiceListingUseCase(companyWorker: companyWorker, launchWorker: launchWorker)
        
        networkServiceListingUseCase.fetch { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
}
