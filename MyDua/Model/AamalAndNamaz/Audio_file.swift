/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Audio_file : Codable {
	let iD : Int?
	let id : Int?
	let title : String?
	let filename : String?
	let filesize : Int?
	let url : String?
	let link : String?
	let alt : String?
	let author : String?
	let description : String?
	let caption : String?
	let name : String?
	let status : String?
	let uploaded_to : Int?
	let date : String?
	let modified : String?
	let menu_order : Int?
	let mime_type : String?
	let type : String?
	let subtype : String?
	let icon : String?

	enum CodingKeys: String, CodingKey {

		case iD = "ID"
		case id = "id"
		case title = "title"
		case filename = "filename"
		case filesize = "filesize"
		case url = "url"
		case link = "link"
		case alt = "alt"
		case author = "author"
		case description = "description"
		case caption = "caption"
		case name = "name"
		case status = "status"
		case uploaded_to = "uploaded_to"
		case date = "date"
		case modified = "modified"
		case menu_order = "menu_order"
		case mime_type = "mime_type"
		case type = "type"
		case subtype = "subtype"
		case icon = "icon"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		iD = try values.decodeIfPresent(Int.self, forKey: .iD)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		filename = try values.decodeIfPresent(String.self, forKey: .filename)
		filesize = try values.decodeIfPresent(Int.self, forKey: .filesize)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		alt = try values.decodeIfPresent(String.self, forKey: .alt)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		uploaded_to = try values.decodeIfPresent(Int.self, forKey: .uploaded_to)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		modified = try values.decodeIfPresent(String.self, forKey: .modified)
		menu_order = try values.decodeIfPresent(Int.self, forKey: .menu_order)
		mime_type = try values.decodeIfPresent(String.self, forKey: .mime_type)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		subtype = try values.decodeIfPresent(String.self, forKey: .subtype)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
	}

}