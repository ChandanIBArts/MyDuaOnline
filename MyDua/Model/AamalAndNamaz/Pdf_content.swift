
import Foundation
struct Pdf_content : Codable {
	let acf_fc_layout : String?
	let pdf_content : String?

	enum CodingKeys: String, CodingKey {

		case acf_fc_layout = "acf_fc_layout"
		case pdf_content = "pdf_content"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		acf_fc_layout = try values.decodeIfPresent(String.self, forKey: .acf_fc_layout)
		pdf_content = try values.decodeIfPresent(String.self, forKey: .pdf_content)
	}

}
