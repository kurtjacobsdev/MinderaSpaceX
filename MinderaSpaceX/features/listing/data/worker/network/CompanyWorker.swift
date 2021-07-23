//
//  CompanyWorker.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

enum CompanyWorkerError: Error {
    case jsonDecodeError
}

class CompanyWorker {
    private var url = URL(string:"https://api.spacexdata.com/v3/info")!
    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(complete: @escaping (Result<CompanyInfo, Error>) -> ()) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                complete(.failure(error))
                return
            }
            
            guard let jsonData = data,
                  let model = try? JSONDecoder().decode(CompanyInfo.self, from: jsonData) else {
                complete(.failure(CompanyWorkerError.jsonDecodeError))
                return
            }
            complete(.success(model))
        }.resume()
    }
}
