//
//  EntryRepository.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 15/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation

protocol EntryRepository {
    typealias CompletionHandler = (String?) -> ()
    
    func load(completion : @escaping CompletionHandler)
    func loadMore(completion : @escaping CompletionHandler)
    func dismiss(entry : Entry)
    func markAsSeen(entry : Entry)
    
    var entriesCount : Int { get }
    var visibleEntriesCount : Int { get }
    func getVisibleEntry(atIndex index : Int) -> Entry?
    func getEntry(atIndex index : Int) -> Entry?
}

class EntryDataRepository : EntryRepository{
    
    private var data: [Entry]?
    private var nextPageId : String?
    
    let entryService: EntryService
    
    let pageSize : Int = 50
    
    public init(entryService: EntryService) {
        self.entryService = entryService
    }
    
    func load(completion : @escaping CompletionHandler) {
        entryService.getTopEntries(limit:pageSize) {[weak self] (entries,nextpage, errorMsg) in
            self?.data = entries
            self?.nextPageId = nextpage
            completion(errorMsg)
        }
    }
    
    func loadMore(completion : @escaping CompletionHandler){
        
    }
    
    func dismiss(entry: Entry) {
        entry.dismiss = true
    }
    
    func markAsSeen(entry: Entry) {
        entry.dismiss = true
    }
    
    var entriesCount : Int {
        get {
            return data?.count ?? 0
        }
    }
    
    private var visibleEntries : [Entry] {
        get {
            return data?.filter { !($0.dismiss ?? false) } ?? []
        }
    }
    
    var visibleEntriesCount : Int {
        get {
            return visibleEntries.count
        }
    }
    
    func getVisibleEntry(atIndex index : Int) -> Entry?{
        return visibleEntries[index]
    }
    
    func getEntry(atIndex index : Int) -> Entry?{
        return data?[index]
    }
}
