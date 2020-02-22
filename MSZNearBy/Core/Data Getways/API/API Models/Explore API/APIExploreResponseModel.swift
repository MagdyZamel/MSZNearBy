//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIExploreResponseModel: Codable {

	let groups: [APIGroupModel]?
	let totalResults: Int?

	enum CodingKeys: String, CodingKey {
		case groups
		case totalResults
	}
    enum ParentKeys: String, CodingKey {
        case meta
        case response
    }

    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: ParentKeys.self)
        let values = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
		groups = try values.decodeIfPresent([APIGroupModel].self, forKey: .groups)
		totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
	}
}
