//
//  RequestData.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 06/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import Foundation

extension URL {
    static let searchRepoURLString: String = "https://api.github.com/search/repositories?"
    static let readMeURLString: String = "https://api.github.com/repos/"
    static let sortString: String = "&sort=stars&order=desc&per_page=60"
}

enum HTTPMethod: String {
    case GET
}

enum APIError: Error {
    case emptyBody
    case unexpectedResponseType
}

enum APIResult {
    case success(SearchResult)
    case successForReadMe(ReadMe)
    case failure(Error)
}

protocol Endpoint {
    var url: URL { get }
    var readMeUrl: URL { get }
    var method: HTTPMethod { get }
    var query: String { get }
}

extension Endpoint {
    fileprivate var urlRequest: URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        return req
    }
    
    fileprivate var urlRequestReadMe: URLRequest {
        var req = URLRequest(url: readMeUrl)
        req.httpMethod = method.rawValue
        return req
    }
}

class RequestData: Endpoint {
    var url: URL
    var readMeUrl: URL
    var method: HTTPMethod
    var query: String
    
    init(query: String) {
        guard let url = URL(string: URL.searchRepoURLString + "q=\(query)" + URL.sortString) else { fatalError("Could not configure URL") }
        guard let readMeUrl = URL(string: URL.readMeURLString + query) else { fatalError("Could not configure URL") }
        self.readMeUrl = readMeUrl
        self.url = url
        self.method = .GET
        self.query = query
    }
    
    func request(callback: @escaping (APIResult) -> Void) {
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let e = error {
                callback(.failure(e))
            } else if let respData = data {
                do {
                    let repoResult = try JSONDecoder().decode(SearchResult.self, from: respData)
                    callback(.success(repoResult))
                    print("✅✅✅ Fetch [repos] SUCCESS ✅✅✅")
                    
                } catch {
                    callback(.failure(error))
                    print("🔥🔥🔥 Fetch [repos] FAIL 🔥🔥🔥")
                }
            } else {
                callback(.failure(APIError.emptyBody))
            }
        }).resume()
    }
    
    func requestReadMe(callback: @escaping (APIResult) -> Void) {
        URLSession.shared.dataTask(with: urlRequestReadMe, completionHandler: { (data, response, error) in
            if let e = error {
                callback(.failure(e))
            } else if let respData = data {
                do {
                    let repoResult = try JSONDecoder().decode(ReadMe.self, from: respData)
                    callback(.successForReadMe(repoResult))
                    print("✅✅✅ Fetch [readMe] SUCCESS ✅✅✅")
                    
                } catch {
                    callback(.failure(error))
                    print("🔥🔥🔥 Fetch [readMe] FAIL 🔥🔥🔥")
                }
            } else {
                callback(.failure(APIError.emptyBody))
            }
        }).resume()
    }
}
