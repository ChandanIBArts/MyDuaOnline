//
//import Foundation
//struct Messagess : Codable {
//	let animatedtext : [Animatedtext]?
//
//	enum CodingKeys: String, CodingKey {
//
//		case animatedtext = "animatedtext"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		animatedtext = try values.decodeIfPresent([Animatedtext].self, forKey: .animatedtext)
//	}
//
//}
