//
//  FileWritingListingUseCase.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class FileWritingFilterListingUseCase {
    private var fileWritingWorker: FileWriterWorker<LaunchFilterModel>
    
    init(fileWritingWorker: FileWriterWorker<LaunchFilterModel>) {
        self.fileWritingWorker = fileWritingWorker
    }
    
    func save(listingFilterModel: LaunchFilterModel) -> Bool {
        return fileWritingWorker.save(data: listingFilterModel)
    }
    
    func retrieve() -> LaunchFilterModel {
        guard let model = fileWritingWorker.retrieve() else {
            return LaunchFilterModel.defaultModel
        }
        return model
    }
}
