//
//	Location.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APILocationModel: Codable {

	let formattedAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case formattedAddress
    }
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		formattedAddress = try values.decodeIfPresent([String].self, forKey: .formattedAddress)
	}

}
