//
//  FileWriterWorkerTests.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import MinderaSpaceX

class FileWriterWorkerTests: XCTestCase {

    struct TestModel: AppFileReadWritable, Codable {
        static var fileName: AppFile = .launchFilterModel
        
        var something: Int
        var somethingMore: String
    }
    
    func testFileWriterWorker() {
        let fileWriter = FileWriterWorker<TestModel>()
        _ = fileWriter.save(data: TestModel(something: 1, somethingMore: "More Time!"))
        let model = fileWriter.retrieve()
        XCTAssertEqual(model?.something, 1)
        XCTAssertEqual(model?.somethingMore, "More Time!")
    }

}
