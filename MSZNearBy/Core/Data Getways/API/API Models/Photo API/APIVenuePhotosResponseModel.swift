//
//	Response.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIVenuePhotosResponseModel: Codable {

	let photos: APIPhotosModel?

    enum CodingKeys: String, CodingKey {
        case photos
	}
    
    enum ParentKeys: String, CodingKey {
        case meta
        case response
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: ParentKeys.self)
        let values = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        photos = try values.decodeIfPresent(APIPhotosModel.self, forKey: .photos)
    }

}
