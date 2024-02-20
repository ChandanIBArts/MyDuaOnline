

import Foundation
struct Gujrati_ziyarat : Codable {
	let track : Int?
	let name : String?
	let file : String?
	let id : Int?
	let caption : String?
	let fav : String?
    let duration : String?

	enum CodingKeys: String, CodingKey {

		case track = "track"
		case name = "name"
		case file = "file"
		case id = "id"
		case caption = "caption"
		case fav = "fav"
        case duration = "duration"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		track = try values.decodeIfPresent(Int.self, forKey: .track)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		file = try values.decodeIfPresent(String.self, forKey: .file)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		fav = try values.decodeIfPresent(String.self, forKey: .fav)
        duration = try values.decodeIfPresent(String.self, forKey: .duration)

	}

}
