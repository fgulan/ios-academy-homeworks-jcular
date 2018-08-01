//
//  Comment.swift
//  TVShows
//
//  Created by Jure Cular on 01/08/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let text: String
    let userEmail: String
    let episodeID: String
    let userID: String?
    let type: String?
    let id: String
    enum CodingKeys: String, CodingKey {
        case text
        case userEmail
        case userID = "userId"
        case type
        case episodeID = "episodeId"
        case id = "_id"
    }
}
