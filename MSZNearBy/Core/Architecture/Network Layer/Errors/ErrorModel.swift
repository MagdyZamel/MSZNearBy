//
//  ErrorModel.swift
//  MSZNearBy
//
//  Created by MSZ on 12/6/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation

struct ErrorModel: Codable {
    let code: Int?
    let errorDetail: String?
    let errorType: String?
    let requestId: String?

    init(code: Int, errorDetail: String) {
        self.code = code
        self.errorDetail  = errorDetail
        self.errorType = ""
        self.requestId = ""

    }
    enum CodingKeys: String, CodingKey {
        case code
        case errorDetail
        case errorType
        case requestId
    }

    enum ParentKeys: String, CodingKey {
        case meta
        case response
    }

    init(from decoder: Decoder) throws {
        let container  = try? decoder.container(keyedBy: ParentKeys.self)
        let values = try? container?.nestedContainer(keyedBy: CodingKeys.self, forKey: .meta)
        self.code = try values?.decodeIfPresent(Int.self, forKey: .code)
        self.errorDetail = try values?.decodeIfPresent(String.self, forKey: .errorDetail)
        self.errorType = try values?.decodeIfPresent(String.self, forKey: .errorType)
        self.requestId = try values?.decodeIfPresent(String.self, forKey: .requestId)
    }

}
