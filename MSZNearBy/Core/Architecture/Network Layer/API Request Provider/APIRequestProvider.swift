//
//  APIRequestProvider.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

class APIRequestProvider: NSObject, APIRequestProviderProtocol {

    @Injected var internetManager: InternetManagerProtocol

    func perform(apiRequest: APIRequestProtocol, completion: @escaping APIRequestCompletion) {
        guard internetManager.isInternetConnectionAvailable() else {
            completion(Result<Data, APIRequestProviderError>.failure(.noInternet(message: "NoInterneError".localized)))
            return
        }
        performRequest(apiRequest.requestURL, completion: completion)
    }

    private func performRequest( _ request: URLRequest, completion: @escaping APIRequestCompletion) {

        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                let failure = APIRequestProviderError.requestFailed(error: error)
                completion(Result<Data, APIRequestProviderError>.failure(failure))
                return
            }

            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                switch statusCode {
                case 200...299:
                    let success = data ?? Data.init()
                    completion(Result<Data, APIRequestProviderError>.success(success))
                default:
                    let failure = APIRequestProviderError.server(statusCode: statusCode, data: data)
                    completion(Result<Data, APIRequestProviderError>.failure(failure))
                }
            }
        }
        dataTask.resume()
    }
}
extension APIRequestProvider: URLSessionDelegate {

}
