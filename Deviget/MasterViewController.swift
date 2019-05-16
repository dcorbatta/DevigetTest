//
//  MasterViewController.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    private var entriesPresenter : EntriesPresenter!
    
    var detailViewController: DetailViewController? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let repository = EntryDataRepository(entryService: EntryService())
        entriesPresenter = EntriesPresenter(delegate: self,entryRepository: repository)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.prefetchDataSource = self
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        showLoading()
        entriesPresenter.getAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = entriesPresenter.getVisibleEntry(atIndex:indexPath.row)  as! Entry
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object.title
                entriesPresenter.markEntryAsSeen(entry: object)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Visibles Entries + Load More Cell
        return entriesPresenter.visibleEntriesCount + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if isLoadingCell(for: indexPath) {
            cell.textLabel!.text = "Loading"
        }else if let object = entriesPresenter.getVisibleEntry(atIndex:indexPath.row) {
            cell.textLabel!.text = object.title
            cell.contentView.backgroundColor = object.read ?? false ? .blue : .white
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let entry = entriesPresenter.getVisibleEntry(atIndex:  indexPath.row) {
                entriesPresenter.dismissEntry(entry: entry)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

extension MasterViewController {
    func showLoading(){
        
    }
    
    func hideLoading(){
        
    }
    
}

extension MasterViewController : EntriesPresenterDelegate {
    
    func reload(atIndexPath indexPaths: [IndexPath]){
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: indexPaths)
        
        if indexPathsToReload.count > 0 {
            //Insert the new rows
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        
        //Reload visible rows
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func updateUI() {
        hideLoading()
        tableView.reloadData()
    }
    
    func showError(_ errorMsg: String) {
        
    }
    
    
}

extension MasterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            entriesPresenter.loadMore()
        }
    }
}

private extension MasterViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= entriesPresenter.visibleEntriesCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
