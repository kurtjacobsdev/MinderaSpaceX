//
//  URLProtocolMock.swift
//  MinderaSpaceXTests
//
//  Created by Kurt Jacobs
//

import Foundation

class URLProtocolFileLoader {
    static func load(file: String) throws -> Data {
        let testBundle = Bundle(for: Self.self)
        guard let url = testBundle.url(forResource: file, withExtension: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError()
        }
        return data
    }
}

enum URLProtocolMockRequests: String {
    case companyInfo = "https://api.spacexdata.com/v3/info"
    case launches = "https://api.spacexdata.com/v3/launches"
}

class URLProtocolMock: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let urlString = request.url?.absoluteString else {
            return
        }
        let data = try! dataPayload(for: URLProtocolMockRequests(rawValue: urlString)!)
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: urlString)!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
    private func dataPayload(for request: URLProtocolMockRequests) throws -> Data {
        switch request {
        case .companyInfo:
            let data = try! URLProtocolFileLoader.load(file: "company")
            return data
        case .launches:
            let data = try! URLProtocolFileLoader.load(file: "launches")
            return data
        }
    }
}

class URLProtocolMockFailing: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let urlString = request.url?.absoluteString else {
            return
        }
        self.client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: urlString)!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: nil)!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didFailWithError: NSError(domain: "com.mindera.failing.url.mock", code: 9999, userInfo: nil))
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
