//
//  LaunchFilterListingUseCase.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class LaunchFilterListingUseCase {
    private var launchFilterWorker: LaunchFilterWorker
    
    init(launchFilterWorker: LaunchFilterWorker) {
        self.launchFilterWorker = launchFilterWorker
    }
    
    func applyFilters(launch: [Launch], filterModel: LaunchFilterModel) -> [Launch] {
        return launchFilterWorker.applyFilters(launch: launch, filterModel: filterModel)
    }
}
