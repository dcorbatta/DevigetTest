//
//  EntriesPresenter.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation

protocol EntriesPresenterDelegate : NSObjectProtocol{
    func updateUI()
    func showError(_ errorMsg : String)
}

class EntriesPresenter {
    private var data: [Entry]?
    private var nextPageId : String?
    
    weak var delegate : EntriesPresenterDelegate?
    
    var entryRepository : EntryRepository
    
    init(delegate : EntriesPresenterDelegate, entryRepository: EntryRepository) {
        self.delegate = delegate
        self.entryRepository = entryRepository
    }
    
    func getAll() {
        entryRepository.load(){ [weak self](errorMsg) in
            
            DispatchQueue.main.async {
                self?.delegate?.updateUI()
                guard let errorMsg = errorMsg else { return }
                self?.delegate?.showError(errorMsg)
            }
        }
    }
    
    func dismissEntry(entry: Entry) {
        entryRepository.dismiss(entry: entry)
    }
}

extension EntriesPresenter {
    var entriesCount : Int {
        get {
            return entryRepository.entriesCount
        }
    }
    
    var visibleEntriesCount : Int {
        get {
            return entryRepository.visibleEntriesCount
        }
    }
    
    func getEntry(atIndex index : Int) -> Entry?{
        return entryRepository.getEntry(atIndex:index)
    }
    
    func getVisibleEntry(atIndex index : Int) -> Entry?{
        return entryRepository.getVisibleEntry(atIndex: index)
    }
    
}
