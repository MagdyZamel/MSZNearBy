//
//	Venue.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct APIVenueModel: Codable {

	let venueId: String?
	let location: APILocationModel?
	let name: String?

	enum CodingKeys: String, CodingKey {
		case venueId = "id"
		case location
		case name
	}
    
}
