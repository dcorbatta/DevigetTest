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
    
    init(delegate : EntriesPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getAll() {
        let serv = EntryService()
        serv.getTopEntries(after: nil, before: nil) { [weak self](entries,nextpage, errorMsg) in
            self?.data = entries
            self?.nextPageId = nextpage
            
            DispatchQueue.main.async {
                self?.delegate?.updateUI()
                guard let errorMsg = errorMsg else { return }
                self?.delegate?.showError(errorMsg)
            }
        }
    }
}

extension EntriesPresenter {
    var entriesCount : Int {
        get {
            return data?.count ?? 0
        }
    }
    
    func getEntry(atIndex index : Int) -> Entry?{
        return data?[index]
    }
}
