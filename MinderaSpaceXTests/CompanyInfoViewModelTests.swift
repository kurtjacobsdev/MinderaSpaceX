//
//  CompanyInfoViewModelTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class CompanyInfoViewModelTests: XCTestCase {

    func testCompanyInfoViewModel() {
        let companyModel = CompanyInfo(name: "Kurtify", founder: "Kurt Jacobs", founded: 2021, employees: 15, launchSites: 22, valuation: 25)
        let viewModel = CompanyInfoViewModel(model: companyModel)
        XCTAssertEqual(viewModel.title, "Kurtify was founded by Kurt Jacobs in 2021. It now has 15 employees, 22 launch sites, and is valued at USD 25.0.")
    }
    
}
