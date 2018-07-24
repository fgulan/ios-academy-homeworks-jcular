//
//  Episode.swift
//  TVShows
//
//  Created by Jure Cular on 24/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let title: String
    let description: String
    let imageURL: URL
    let id: String
    enum CodingKeys: String, CodingKey {
        case description
        case title
        case imageURL = "imageUrl"
        case id = "_id"
    }
}
