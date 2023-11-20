

import Foundation
struct List_of_sahfia : Codable {

	let arabic_dua : [Arabic_dua]?
	let english_dua : [English_dua]?
	let hindi_dua : [Hindi_dua]?
	let gujrati_dua : [Gujrati_dua]?

	enum CodingKeys: String, CodingKey {
		case arabic_dua = "arabic_dua"
		case english_dua = "english_dua"
		case hindi_dua = "hindi_dua"
		case gujrati_dua = "gujrati_dua"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		arabic_dua = try values.decodeIfPresent([Arabic_dua].self, forKey: .arabic_dua)
		english_dua = try values.decodeIfPresent([English_dua].self, forKey: .english_dua)
		hindi_dua = try values.decodeIfPresent([Hindi_dua].self, forKey: .hindi_dua)
		gujrati_dua = try values.decodeIfPresent([Gujrati_dua].self, forKey: .gujrati_dua)
	}

}
