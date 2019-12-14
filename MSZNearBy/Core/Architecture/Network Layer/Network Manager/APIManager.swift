//
//  APIManager.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises

class APIManager: NetworkManagerProtocol {
    
    func perform<T: Codable>(apiRequest: APIRequestProtocol,
                             providerType: APIRequestProviderProtocol,
                             outputType: T.Type) -> Promise<T> {
        return call(providerType: providerType, outputType: outputType, apiRequest: apiRequest)
    }

    private func call<T: Codable>(providerType: APIRequestProviderProtocol,
                                  outputType: T.Type,
                                  apiRequest: APIRequestProtocol) -> Promise<T> {
        return Promise<T>(on: .promises) { fulfill, reject in
            print(apiRequest.requestURL)
            providerType.perform(apiRequest: apiRequest, completion: { [weak self] result in
                if let result =  self?.validate(result: result, outputType: outputType) {
                    switch result {
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        reject(error)
                    }
                }
            })
        }
    }
    
    private func validate<T: Codable>(result: Result<Data, APIRequestProviderError>,
                                      outputType: T.Type )-> Result<T, APIManagerError> {
        
        let returnedresult: Result<T, APIManagerError>
        
        switch result {
        case .failure(let error):
            switch error {
            case .noInternet(let message):
                returnedresult = .failure(.noInternet(message: message))
            case .requestFailed(let error):
                returnedresult = .failure(.requestFailed(message: error.localizedDescription))
            case .server(let statusCode, let data):
                let decoder = JSONDecoder()
                if let data = data, let error =  try? decoder.decode(ErrorModel.self, from: data) {
                    returnedresult = .failure(.errorModel(errorModel: error))
                } else {
                    let error = ErrorModel(code: statusCode, errorDetail: "APIFailureError".localized)
                    returnedresult = .failure(.errorModel(errorModel: error))
                }
            }
        case .success(let data):
            
            if let decoded = try? JSONDecoder().decode(outputType, from: data) {
                returnedresult = .success(decoded)
            } else if let error =  try? JSONDecoder().decode(ErrorModel.self, from: data) {
                returnedresult = .failure(.errorModel(errorModel: error))
            } else if let decoded = String(bytes: data, encoding: .utf8) as? T {
                returnedresult = .success(decoded)
            } else {
                returnedresult = .failure(.requestFailed(message:"APIFailureError".localized))
            }
        }
        return returnedresult
    }
    
}
