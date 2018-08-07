//
//  Show.swift
//  TVShows
//
//  Created by Jure Cular on 18/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

struct Show: Codable {
    let title: String
    let id: String
    let imageURL: String
    let likesCount: Int
    enum CodingKeys: String, CodingKey {
        case title
        case id = "_id"
        case imageURL = "imageUrl"
        case likesCount
    }
}

struct ShowDetails: Codable {
    let title: String
    let type: String
    let description: String
    let likes: Int
    let imageURL: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case type
        case description
        case title
        case likes = "likesCount"
        case imageURL = "imageUrl"
        case id = "_id"
    }
}
