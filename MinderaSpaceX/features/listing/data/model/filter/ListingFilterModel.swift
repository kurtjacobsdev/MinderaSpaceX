//
//  ListingFilterModel.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

enum LaunchFilterType: Int, Codable {
    case all = 0
    case failed = 1
    case successful = 2
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .failed:
            return "Failed"
        case .successful:
            return "Successful"
        }
    }
}

enum SortFilterType: Int, Codable {
    case asc = 0
    case desc = 1
    
    var title: String {
        switch self {
        case .asc:
            return "Ascending"
        case .desc:
            return "Descending"
        }
    }
}

struct LaunchFilterModel: Codable, AppFileReadWritable {
    static var fileName: AppFile = .launchFilterModel
    
    private (set) var fromYear: Date
    private (set) var untilYear: Date
    private (set) var sort: SortFilterType
    private (set) var launch: LaunchFilterType
    private (set) var fromYearEnabled: Bool
    private (set) var untilYearEnabled: Bool
    
    static var defaultModel: LaunchFilterModel {
        return LaunchFilterModel(fromYear: Date(),
                                  untilYear: Date(),
                                  sort: .asc,
                                  launch: .all,
                                  fromYearEnabled: false,
                                  untilYearEnabled: false)
    }
    
}
