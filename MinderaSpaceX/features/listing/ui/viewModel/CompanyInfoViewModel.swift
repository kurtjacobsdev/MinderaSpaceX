//
//  CompanyInfoViewModel.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

struct CompanyInfoViewModel {
    private var model: CompanyInfo
    
    init(model: CompanyInfo) {
        self.model = model
    }
    
    var title: String {
        guard let name = model.name, let founder = model.founder, let founded = model.founded, let employees = model.employees, let launchSites = model.launchSites, let valuation = model.valuation else { return "" }
        
        return "\(name) was founded by \(founder) in \(founded). It now has \(employees) employees, \(launchSites) launch sites, and is valued at USD \(valuation)."
    }
}
