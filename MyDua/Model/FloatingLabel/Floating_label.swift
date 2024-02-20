

//import Foundation
//import Network
//struct Floating_label : Codable {
//	let type : String?
//	let message : Message?
//
//	enum CodingKeys: String, CodingKey {
//
//		case type = "type"
//		case message = "message"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		type = try values.decodeIfPresent(String.self, forKey: .type)
//		message = try values.decodeIfPresent(Message.self, forKey: .message)
//	}
//
//}
