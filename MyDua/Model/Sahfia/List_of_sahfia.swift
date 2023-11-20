/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Json4Swift_Base : Codable {
	let banner_left_slide : Banner_left_slide?
	let banner_right_slide : [Banner_right_slide]?
	let arabic_dua : [Arabic_dua]?
	let english_dua : [English_dua]?
	let hindi_dua : [Hindi_dua]?
	let gujrati_dua : [Gujrati_dua]?

	enum CodingKeys: String, CodingKey {

		case banner_left_slide = "banner_left_slide"
		case banner_right_slide = "banner_right_slide"
		case arabic_dua = "arabic_dua"
		case english_dua = "english_dua"
		case hindi_dua = "hindi_dua"
		case gujrati_dua = "gujrati_dua"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		banner_left_slide = try values.decodeIfPresent(Banner_left_slide.self, forKey: .banner_left_slide)
		banner_right_slide = try values.decodeIfPresent([Banner_right_slide].self, forKey: .banner_right_slide)
		arabic_dua = try values.decodeIfPresent([Arabic_dua].self, forKey: .arabic_dua)
		english_dua = try values.decodeIfPresent([English_dua].self, forKey: .english_dua)
		hindi_dua = try values.decodeIfPresent([Hindi_dua].self, forKey: .hindi_dua)
		gujrati_dua = try values.decodeIfPresent([Gujrati_dua].self, forKey: .gujrati_dua)
	}

}