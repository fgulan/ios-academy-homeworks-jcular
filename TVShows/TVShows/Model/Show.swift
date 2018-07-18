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
    enum CodingKeys: String, CodingKey {
        case title
        case id = "_id"
    }
}
