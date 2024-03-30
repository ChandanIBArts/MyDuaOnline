
import Foundation
struct AamaalData : Codable {
	let arabic : [Arabic]?
	let english : [English]?
	let hindi : [String]?
	let gujarati : [Gujarati]?

	enum CodingKeys: String, CodingKey {

		case arabic = "arabic"
		case english = "english"
		case hindi = "hindi"
		case gujarati = "gujarati"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		arabic = try values.decodeIfPresent([Arabic].self, forKey: .arabic)
		english = try values.decodeIfPresent([English].self, forKey: .english)
		hindi = try values.decodeIfPresent([String].self, forKey: .hindi)
		gujarati = try values.decodeIfPresent([Gujarati].self, forKey: .gujarati)
	}

}
