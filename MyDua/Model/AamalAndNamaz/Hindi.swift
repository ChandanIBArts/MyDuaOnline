//
//  Hindi.swift
//  MyDua
//
//  Created by IB Arts Mac on 30/03/24.
//

import Foundation
struct Hindi : Codable {
    let aamaal_type : String?
    let title : String?
    let pdf_content : [Pdf_content]?

    enum CodingKeys: String, CodingKey {

        case aamaal_type = "aamaal_type"
        case title = "title"
        case pdf_content = "pdf_content"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aamaal_type = try values.decodeIfPresent(String.self, forKey: .aamaal_type)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        pdf_content = try values.decodeIfPresent([Pdf_content].self, forKey: .pdf_content)
    }

}
