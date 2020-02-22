//
//  BaseAPIRequest.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

class BaseAPIRequest: APIRequestProtocol {

    var queryParamss: [String: String]?
    var scheme: String
    var baseDomain: String
    var portNumber: Int
    var path: String
    var authorization: APIAuthorization
    var method: HTTPMethod
    var queryBody: Any?
    var headers: [String: String]

    var queryItems: [URLQueryItem]? {
        return queryParams()?.map({ URLQueryItem.init(name: $0.key, value: $0.value)})
    }
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.port = self.portNumber
        urlComponents.path = "\(self.path)"
        urlComponents.host = self.baseDomain
        urlComponents.queryItems = self.queryItems
        return urlComponents.url!
    }
    var requestURL: URLRequest {
        let timeoutInterval = Environment().configuration(.timeoutInterval).doubleValue
        var request = URLRequest(url: self.url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeoutInterval)
        switch authorization {
        case .bearerToken:
            guard let header = authorization.authData as? [String: String] else {
                fatalError("bearerToken header must be as [String:String] ")
            }
            headers.merge(header) { (_, new) in new }
        case .none:
            break
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = self.method.rawValue
        var bodyData: Data?
        if let queryBody = self.queryBody as? [String: Any] {
            bodyData = try? JSONSerialization.data(withJSONObject: queryBody, options: [])
        } else if let queryBody = self.queryBody as? String {
            bodyData = queryBody.data(using: .utf8)
        }
        request.httpBody = bodyData
        return request
    }

    init() {
        portNumber = Environment().configuration(.port).integerValue
        scheme = "\(Environment().configuration(.urlProtocol))"
        baseDomain = "\(Environment().configuration(.baseDomain))"
        authorization = .none
        headers = ["Content-Type": "application/json"]
        path = ""
        method = .get
    }
    func queryParams() -> [String: String]? {
        return nil
    }

}
