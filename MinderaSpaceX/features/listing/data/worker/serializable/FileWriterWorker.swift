//
//  FileWriterWorker.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

class FileWriterWorker<T: Codable & AppFileReadWritable> {
    
    func save(data: T) -> Bool {
        let data = try? JSONEncoder().encode(data)
        guard let _ = try? data?.write(to: filePath()) else {
            return false
        }
        return true
    }
    
    func retrieve() -> T? {
        guard let data = try? Data(contentsOf: filePath()) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    private func filePath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(T.fileName.rawValue)
        return path
    }
}
