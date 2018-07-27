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
    let type: String?
    let showID: String?
    let description: String
    let episodeNumber: String?
    let season: String?
    let imageURL: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case showID = "showId"
        case description
        case episodeNumber
        case season
        case imageURL = "imageUrl"
        case id = "_id"
    }
}
