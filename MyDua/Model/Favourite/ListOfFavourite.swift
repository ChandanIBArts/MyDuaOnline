//
//  ListOfFavourite.swift
//  MyDua
//
//  Created by IB Arts Mac on 15/11/23.
//

import Foundation
struct ListOfFavourite : Codable {
    let track : Int?
    let name : String?
    let file : String?
    let id : String?
    let fav : String?

    enum CodingKeys: String, CodingKey {

        case track = "track"
        case name = "name"
        case file = "file"
        case id = "id"
        case fav = "fav"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        track = try values.decodeIfPresent(Int.self, forKey: .track)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        fav = try values.decodeIfPresent(String.self, forKey: .fav)
    }

}
