//
//	Group.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIGroupModel: Codable {

	let items: [APIItemModel]?
	let name: String?
	let type: String?

	enum CodingKeys: String, CodingKey {
		case items
		case name
        case type
    }
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		items = try values.decodeIfPresent([APIItemModel].self, forKey: .items)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		type = try values.decodeIfPresent(String.self, forKey: .type)
	}

}
