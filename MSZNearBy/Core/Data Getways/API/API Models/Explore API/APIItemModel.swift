//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIItemModel: Codable {

	let venue: APIVenueModel?

	enum CodingKeys: String, CodingKey {
		case venue
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        venue = try values.decode(APIVenueModel.self, forKey: .venue)
	}

}
