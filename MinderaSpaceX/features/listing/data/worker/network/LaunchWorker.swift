//
//  LaunchWorker.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

enum LaunchWorkerError: Error {
    case jsonDecodeError
}

class LaunchWorker {
    private var url = URL(string:"https://api.spacexdata.com/v3/launches")!
    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(complete: @escaping (Result<[Launch], Error>) -> ()) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                complete(.failure(error))
                return
            }
            
            guard let jsonData = data,
                  let model = try? Launch.decoder.decode([Launch].self, from: jsonData) else {
                complete(.failure(LaunchWorkerError.jsonDecodeError))
                return
            }
            complete(.success(model))
        }.resume()
    }
}
