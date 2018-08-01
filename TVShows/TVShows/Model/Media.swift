//
//  Media.swift
//  TVShows
//
//  Created by Jure Cular on 01/08/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation

struct Media: Codable {
    let path: String
    let type: String
    let id: String
    enum CodingKeys: String, CodingKey {
        case path
        case type
        case id = "_id"
    }
}
