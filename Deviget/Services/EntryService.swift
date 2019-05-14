//
//  EntryService.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation

private enum ParamsKey : String {
    case after  = "after"
    case before = "before"
    case limit  = "limit"
}

class EntryService {
    
    typealias EntriesResponse = ([Entry]?,String?, String?) -> ()
    let baseURLString = "https://www.reddit.com/top.json"
    
    func getTopEntries(after: String? = nil, before: String? = nil, limit: Int? = 10, completion: @escaping EntriesResponse) {
        
        var params : [String:String] = [:]
        if let after = after {
            params[ParamsKey.after.rawValue] = after
        }
        if let before = before {
            params[ParamsKey.before.rawValue] = before
        }
        
        if let limit = limit {
            params[ParamsKey.limit.rawValue] = "\(limit)"
        }
        
        let resource = Resource<TopEntriesResponse>(get: URL(string: baseURLString)!,params:params)
        URLSession.shared.load(resource) { entriesResponse, errorMessage in
            
            guard let entriesResponse = entriesResponse else {
                completion(nil,nil,errorMessage)
                return
            }
            let entries = entriesResponse.data.children.compactMap{$0.data}
            completion(entries,entriesResponse.data.after,nil)
        }
        
    }
}
