//
//  EntryRepository.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 15/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation

protocol EntryRepository {
    typealias CompletionHandler = ([Int]?,String?) -> ()
    
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
            let addedEntries = Array(0..<(entries?.count ?? 0))
            completion(addedEntries,errorMsg)
        }
    }
    
    var isLoadingMore = false
    func loadMore(completion : @escaping CompletionHandler) {
       
        if isLoadingMore {
            return
        }
        isLoadingMore = true
        
        entryService.getTopEntries(after: nextPageId,limit:pageSize) { [weak self](entries,nextpage, errorMsg) in

            self?.isLoadingMore = false
            
            //Add new data
            if let entries = entries {
                self?.data?.append(contentsOf:entries)
            }
            
            //Update next page id
            self?.nextPageId = nextpage
            
            //Calculate added indexes.
            let startIndex = (self?.data?.count ?? 0) - (entries?.count ?? 0)
            let endIndex = startIndex + (entries?.count ?? 0)
            let addedEntries = Array(startIndex..<endIndex)
            
            completion(addedEntries,errorMsg)
        }
    }
    
    func dismiss(entry: Entry) {
        entry.dismiss = true
    }
    
    func markAsSeen(entry: Entry) {
        entry.read = true
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
