//
//  TopEntriesResponse.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation
struct TopEntriesResponse: Codable {
    
    var data: EntryList
    
    struct EntryList: Codable {
        var children: [ChildrenResponse]
        var after : String
    }
    
    struct ChildrenResponse: Codable {
        let data: Entry
    }
}
