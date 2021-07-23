//
//  CompanyInfo.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

struct CompanyInfo: Decodable {
    private (set) var name: String?
    private (set) var founder: String?
    private (set) var founded: Int?
    private (set) var employees: Int?
    private (set) var launchSites: Int?
    private (set) var valuation: Double?
    
    init(name: String?, founder: String?, founded: Int?, employees: Int?, launchSites: Int?, valuation: Double?) {
        self.name = name
        self.founder = founder
        self.founded = founded
        self.employees = employees
        self.launchSites = launchSites
        self.valuation = valuation
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case founder
        case founded
        case employees
        case launchSites = "launch_sites"
        case valuation
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        founder = try? values.decode(String.self, forKey: .founder)
        founded = try? values.decode(Int.self, forKey: .founded)
        employees = try? values.decode(Int.self, forKey: .employees)
        launchSites = try? values.decode(Int.self, forKey: .launchSites)
        valuation = try? values.decode(Double.self, forKey: .valuation)
    }
}
