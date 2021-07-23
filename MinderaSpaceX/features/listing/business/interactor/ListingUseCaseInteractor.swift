//
//  SpaceXListingUseCaseInteractor.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class ListingUseCaseInteractor {
    private (set) var company: [CompanyInfo] = []
    private (set) var launches: [Launch] = []
    
    private var _launches: [Launch] = []
    
    private var networkServiceListingUseCase: NetworkServiceListingUseCase
    private var filterFileWriterListingUseCase: FileWritingFilterListingUseCase
    private var launchFilterListingUseCase: LaunchFilterListingUseCase
    
    init(filterFileWriterListingUseCase: FileWritingFilterListingUseCase,
         networkServiceListingUseCase: NetworkServiceListingUseCase,
         launchFilterListingUseCase: LaunchFilterListingUseCase) {
        self.networkServiceListingUseCase = networkServiceListingUseCase
        self.filterFileWriterListingUseCase = filterFileWriterListingUseCase
        self.launchFilterListingUseCase = launchFilterListingUseCase
    }
    
    func refresh(complete: @escaping () -> ()) {
        networkServiceListingUseCase.fetch { [weak self] result in
            switch result {
            case let .success((info, launches)):
                self?.company = info
                self?._launches = launches
                self?.applyFilters()
                complete()
            case .failure(_):
                complete()
            }
        }
    }
    
    func applyFilters() {
        launches = launchFilterListingUseCase.applyFilters(launch: _launches,
                                                           filterModel: filterFileWriterListingUseCase.retrieve())
    }
}
