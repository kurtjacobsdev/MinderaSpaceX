//
//  DIContainer.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class DIContainer {
    // Worker
    private (set) var companyWorker: CompanyWorker
    private (set) var launchWorker: LaunchWorker
    private (set) var launchFilterWorker: LaunchFilterWorker
    private (set) var filterFileWriterWorker: FileWriterWorker<LaunchFilterModel>
    
    // Use Case
    private (set) var fileWriterListingFilterUseCase: FileWritingFilterListingUseCase
    private (set) var networkServiceListingUseCase: NetworkServiceListingUseCase
    private (set) var launchFilterListingUseCase: LaunchFilterListingUseCase
    
    // Use Case Interactor
    private (set) var listingUseCaseInteractor: ListingUseCaseInteractor
    
    init() {
        companyWorker = CompanyWorker(session: URLSession.shared)
        launchWorker = LaunchWorker(session: URLSession.shared)
        launchFilterWorker = LaunchFilterWorker()
        filterFileWriterWorker = FileWriterWorker<LaunchFilterModel>()
        
        launchFilterListingUseCase = LaunchFilterListingUseCase(launchFilterWorker: launchFilterWorker)
        fileWriterListingFilterUseCase = FileWritingFilterListingUseCase(fileWritingWorker: filterFileWriterWorker)
        networkServiceListingUseCase = NetworkServiceListingUseCase(companyWorker: companyWorker, launchWorker: launchWorker)
        
        listingUseCaseInteractor = ListingUseCaseInteractor(filterFileWriterListingUseCase: fileWriterListingFilterUseCase, networkServiceListingUseCase: networkServiceListingUseCase, launchFilterListingUseCase: launchFilterListingUseCase)
    }
}
