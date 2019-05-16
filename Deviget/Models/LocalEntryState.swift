//
//  LocalEntryState.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 16/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation
class LocalEntryState: Codable {
    
    var entryId: String?
    var read: Bool? = false
    var dismiss: Bool? = false
    
    init(entry: Entry) {
        entryId = entry.id
        read = entry.read
        dismiss = entry.dismiss
    }
    
    enum CodingKeys: String, CodingKey {
        case entryId = "id"
        case read
        case dismiss
    }
}
