//
//  LaunchFilterWorkerTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

struct LaunchFilterWorkerTestsYearUnixTimeStamps {
    static var _1999: TimeInterval = 915148800
    static var _2000: TimeInterval = 946684800
    static var _2001: TimeInterval = 978307200
    static var _2002: TimeInterval = 1009843200
    static var _2003: TimeInterval = 1041379200
    static var _2004: TimeInterval = 1072915200
    static var _2005: TimeInterval = 1104537600
    static var _2006: TimeInterval = 1136073600
    static var _2007: TimeInterval = 1167609600
}

class LaunchFilterWorkerTests: XCTestCase {
    
    private var launch: [Launch] = []
    private let filter = LaunchFilterWorker()
    
    override func setUp() {
        super.setUp()
        
        let launch1 = Launch(missionName: "Mission 1", missionImage: nil, launchSuccess: true, rocketName: "Mission 1 Rocket", rocketType: "Mission 1 Rocket Type", wikipediaLink: nil, videoLink: nil, articleLink: nil, launchYear: 2000, launchDate: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2000)) // 2000 / 1 / 1
        
        let launch2 = Launch(missionName: "Mission 2", missionImage: nil, launchSuccess: false, rocketName: "Mission 2 Rocket", rocketType: "Mission 2 Rocket Type", wikipediaLink: nil, videoLink: nil, articleLink: nil, launchYear: 2001, launchDate: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2001)) // 2001 / 1 / 1
        
        let launch3 = Launch(missionName: "Mission 3", missionImage: nil, launchSuccess: true, rocketName: "Mission 3 Rocket", rocketType: "Mission 3 Rocket Type", wikipediaLink: nil, videoLink: nil, articleLink: nil, launchYear: 2005, launchDate: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2005)) // 2005 / 1 / 1
        
        let launch4 = Launch(missionName: "Mission 4", missionImage: nil, launchSuccess: false, rocketName: "Mission 4 Rocket", rocketType: "Mission 4 Rocket Type", wikipediaLink: nil, videoLink: nil, articleLink: nil, launchYear: 2007, launchDate: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007)) // 2007 / 1 / 1
        
        self.launch = [launch2, launch4, launch1, launch3]
    }
    
    func testLaunchFilterYear() {
        let betweenFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2003), sort: .asc, launch: .all, fromYearEnabled: true, untilYearEnabled: true)
        
        let sinceFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2002), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2003), sort: .asc, launch: .all, fromYearEnabled: true, untilYearEnabled: false)
        
        let untilFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2005), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2005), sort: .asc, launch: .all, fromYearEnabled: false, untilYearEnabled: true)
        
        XCTAssertEqual(filter.yearFilter(launch: self.launch, filterModel: betweenFilter).count, 2)
        XCTAssertEqual(filter.yearFilter(launch: self.launch, filterModel: sinceFilter).count, 2)
        XCTAssertEqual(filter.yearFilter(launch: self.launch, filterModel: untilFilter).count, 3)
    }
    
    func testLaunchFilterSort() {
        let ascendingFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007), sort: .asc, launch: .all, fromYearEnabled: false, untilYearEnabled: false)
        
        let descendingFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007), sort: .desc, launch: .all, fromYearEnabled: false, untilYearEnabled: false)
        
        let asc = filter.sortFilter(launch: self.launch, filterModel: ascendingFilter)
        let desc = filter.sortFilter(launch: self.launch, filterModel: descendingFilter)
        
        for (idx, item) in asc.enumerated() {
            XCTAssertEqual(item.missionName, "Mission \(idx+1)")
        }
        
        for (idx, item) in desc.enumerated() {
            XCTAssertEqual(item.missionName, "Mission \(desc.count - idx)")
        }
    }
    
    func testLaunchFilterSuccess() {
        let successFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007), sort: .asc, launch: .successful, fromYearEnabled: false, untilYearEnabled: false)
        
        let failureFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007), sort: .asc, launch: .failed, fromYearEnabled: false, untilYearEnabled: false)
        
        let allFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2007), sort: .asc, launch: .all, fromYearEnabled: false, untilYearEnabled: false)
        
        XCTAssertEqual(filter.successFilter(launch: launch, filterModel: successFilter).count, 2)
        XCTAssertEqual(filter.successFilter(launch: launch, filterModel: failureFilter).count, 2)
        XCTAssertEqual(filter.successFilter(launch: launch, filterModel: allFilter).count, 4)
    }
    
    func testCombinedFilter() {
        let combinedFilter = LaunchFilterModel(fromYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._1999), untilYear: Date(timeIntervalSince1970: LaunchFilterWorkerTestsYearUnixTimeStamps._2003), sort: .asc, launch: .successful, fromYearEnabled: true, untilYearEnabled: true)
        
        XCTAssertEqual(filter.applyFilters(launch: launch, filterModel: combinedFilter).count, 1)
    }
}
