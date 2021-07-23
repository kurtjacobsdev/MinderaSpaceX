//
//  NetworkServiceListingUseCase.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

enum NetworkServiceListingUseCaseError: Error {
    case loadError
}

class NetworkServiceListingUseCase {
    private var companyWorker: CompanyWorker
    private var launchWorker: LaunchWorker
    
    init(companyWorker: CompanyWorker, launchWorker: LaunchWorker) {
        self.companyWorker = companyWorker
        self.launchWorker = launchWorker
    }
    
    func fetch(complete: @escaping (Result<([CompanyInfo], [Launch]), Error>) -> ()) {
        let requestGroup = DispatchGroup()
        
        var companyInfoHolder: [CompanyInfo] = []
        var launchesHolder: [Launch] = []
        var failure = false
        
        requestGroup.enter()
        companyWorker.request { result in
            switch result {
            case let .success(info):
                companyInfoHolder = [info]
            default:
                failure = true
            }
            requestGroup.leave()
        }
        
        requestGroup.enter()
        launchWorker.request { result in
            switch result {
            case let .success(launches):
                launchesHolder = launches
            default:
                failure = true
            }
            requestGroup.leave()
        }
        
        requestGroup.notify(queue: DispatchQueue.global()) {
            if failure == true {
                complete(.failure(NetworkServiceListingUseCaseError.loadError))
                return
            }
            complete(.success((companyInfoHolder, launchesHolder)))
        }
    }
}
