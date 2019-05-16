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
    func dismissAllEntries()
    func markAsSeen(entry : Entry)
    
    var entriesCount : Int { get }
    var visibleEntriesCount : Int { get }
    func getVisibleEntry(atIndex index : Int) -> Entry?
    func getEntry(atIndex index : Int) -> Entry?
}

class EntryDataRepository : EntryRepository{
    
    private var data: [Entry]?
    private var nextPageId : String?
    
    private var localEntryStates : [String:LocalEntryState]
    
    let entryService: EntryService
    
    let pageSize : Int = 10
    
    let localEntryStatesFileName = "localEntryStates.data"
    
    public init(entryService: EntryService) {
        self.entryService = entryService
        
        if Storage.fileExists(localEntryStatesFileName, in: .documents) {
            self.localEntryStates = Storage.retrieve(localEntryStatesFileName, from: .documents, as: [String:LocalEntryState].self)
        }else{
            self.localEntryStates = [:]
        }
    }
    
    func load(completion : @escaping CompletionHandler) {
        data?.removeAll()
        
        entryService.getTopEntries(limit:pageSize) {[weak self] (entries,nextpage, errorMsg) in
            self?.data = self?.mixRemoteEntryWithLocalState(entries: entries ?? [])
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
            if let entries = entries,
                let mixedEntries = self?.mixRemoteEntryWithLocalState(entries: entries){
                self?.data?.append(contentsOf:mixedEntries)
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
        markAsDismissInLocalStorage(entry)
    }
    
    func dismissAllEntries(){
        data?.forEach {
            $0.dismiss = true
            markAsDismissInLocalStorage($0)
        }
    }
    
    func markAsSeen(entry: Entry) {
        entry.read = true
        markAsReadInLocalStorage(entry)
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

extension EntryDataRepository {
    func markAsDismissInLocalStorage(_ entry : Entry ){
        if let id = entry.id {
            localEntryStates[id]?.dismiss = true
            Storage.store(localEntryStates, to: .documents, as: localEntryStatesFileName)
        }
    }
    
    func markAsReadInLocalStorage(_ entry : Entry ){
        if let id = entry.id {
            localEntryStates[id]?.read = true
            Storage.store(localEntryStates, to: .documents, as: localEntryStatesFileName)
        }
    }
    
    private func mixRemoteEntryWithLocalState(entries : [Entry]) -> [Entry]{
        let entries : [Entry] = entries.compactMap({
            if let id = $0.id {
                guard let entryState = self.localEntryStates[id] else {
                    self.localEntryStates[id] = LocalEntryState(entry: $0)
                    return $0
                }
                $0.dismiss = entryState.dismiss ?? false
                $0.read = entryState.read ?? false
                return $0
            }else{
                return nil
            }
        })
        
        Storage.store(localEntryStates, to: .documents, as: localEntryStatesFileName)
        
        return entries
    }
}
