//
//  LaunchFilterWorker.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class LaunchFilterWorker {
    
    func yearFilter(launch: [Launch], filterModel: LaunchFilterModel) -> [Launch] {
        if filterModel.fromYearEnabled && filterModel.untilYearEnabled {
            return launch
                .filter({ $0.launchYear ?? 0 >= Calendar.current.component(.year, from: filterModel.fromYear) })
                .filter({ $0.launchYear ?? 0 <= Calendar.current.component(.year, from: filterModel.untilYear) })
        } else if filterModel.fromYearEnabled {
            return launch.filter({ $0.launchYear ?? 0 >= Calendar.current.component(.year, from: filterModel.fromYear) })
        } else if filterModel.untilYearEnabled {
            return launch.filter({ $0.launchYear ?? 0 <= Calendar.current.component(.year, from: filterModel.untilYear) })
        }
        
        return launch
    }
    
    func successFilter(launch: [Launch], filterModel: LaunchFilterModel) -> [Launch] {
        switch filterModel.launch {
        case .all:
            return launch
        case .failed:
            return launch.filter { $0.launchSuccess == false }
        case .successful:
            return launch.filter { $0.launchSuccess == true }
        }
    }
    
    func sortFilter(launch: [Launch], filterModel: LaunchFilterModel) -> [Launch] {
        switch filterModel.sort {
        case .asc:
            return launch.sorted(by: >)
        case .desc:
            return launch.sorted(by: <)
        }
    }
    
    func applyFilters(launch: [Launch], filterModel: LaunchFilterModel?) -> [Launch] {
        guard let filterModel = filterModel else {
            return launch
        }
        var result = yearFilter(launch: launch, filterModel: filterModel)
        result = successFilter(launch: result, filterModel: filterModel)
        result = sortFilter(launch: result, filterModel: filterModel)
        return result
    }
}
