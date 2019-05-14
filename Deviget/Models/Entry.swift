//
//  Entry.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation
struct Entry: Codable {
    
    var id: String?
    var title: String?
    var author: String?
    var createdAt: Date?
    var thumbnail: String?
    var numOfcomments: Int?
    var fullImage: String?
    var read: Bool? = false
    var dismiss: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id = "name"
        case title
        case author
        case thumbnail
        case numOfcomments = "num_comments"
        case createdAt = "created_utc"
        case fullImage = "url"
        case read
        case dismiss
    }
}
