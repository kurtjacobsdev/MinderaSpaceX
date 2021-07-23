//
//  LaunchViewModelTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class LaunchViewModelTests: XCTestCase {

    func testLaunchViewModel() {
        let model = Launch(missionName: "Bezos To The Moon!", missionImage: "http://jeffbezos.com/promos/blue.png", launchSuccess: true, rocketName: "Bezos Mobile!", rocketType: "The Finest", wikipediaLink: nil, videoLink: nil, articleLink: nil, launchYear: 2021, launchDate: Date(timeIntervalSince1970: 1626912000)) // 2021/7/22
        
        let dayBefore = Date(timeIntervalSince1970: 1626825600) // 2021/7/21
        let dayAfter = Date(timeIntervalSince1970: 1626998400) // 2021/7/23
        
        let viewModelBefore = LaunchViewModel(model: model, currentDate: dayBefore)
        let viewModelAfter = LaunchViewModel(model: model, currentDate: dayAfter)
        
        XCTAssertEqual(viewModelBefore.missionName.string, "Mission: Bezos To The Moon!")
        XCTAssertEqual(viewModelBefore.rocketName.string, "Rocket: Bezos Mobile! / The Finest")
        XCTAssertEqual(viewModelBefore.dateTime?.string, "Date/Time: 22 July 2021 at 02:00")
        XCTAssertEqual(viewModelBefore.days?.string, "Days From Now: 1")
        XCTAssertEqual(viewModelBefore.hasLaunched, true)
        XCTAssertEqual(viewModelBefore.missionImage, URL(string: "http://jeffbezos.com/promos/blue.png")!)
        
        XCTAssertEqual(viewModelAfter.missionName.string, "Mission: Bezos To The Moon!")
        XCTAssertEqual(viewModelAfter.rocketName.string, "Rocket: Bezos Mobile! / The Finest")
        XCTAssertEqual(viewModelAfter.dateTime?.string, "Date/Time: 22 July 2021 at 02:00")
        XCTAssertEqual(viewModelAfter.days?.string, "Days Since Now: 1")
        XCTAssertEqual(viewModelAfter.hasLaunched, true)
        XCTAssertEqual(viewModelAfter.missionImage, URL(string: "http://jeffbezos.com/promos/blue.png")!)
    }

}
