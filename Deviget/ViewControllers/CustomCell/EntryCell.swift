//
//  EntryCell.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 15/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import UIKit

protocol EntryCellDelegate: class {
    func dismiss(_ cell: EntryCell, withEntry entry : Entry)
}

class EntryCell: UITableViewCell {
    @IBOutlet weak var readStatusView: UIView!
    @IBOutlet weak var usernameLB: UILabel!
    @IBOutlet weak var postedTimeLB: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var dismissBTN: UIButton!
    @IBOutlet weak var numOfCommentsLB: UILabel!
    
    weak var delegate: EntryCellDelegate?
    
    var entry: Entry! {
        didSet {
            self.usernameLB.text = entry.author
            self.titleLB.text = entry.title
            self.numOfCommentsLB.text = "\(entry.numOfcomments ?? 0) comments"
            readStatusView.isHidden = false
            if let isRead = self.entry.read, isRead {
                readStatusView.isHidden = true
            }
            self.postedTimeLB.text = entry.createdAt?.timeAgo() ?? ""
            self.thumbnailImageView.setImage(fromURL: entry.thumbnail, contentMode: .scaleAspectFill)
        }
    }
    
    @IBAction func dismissBTNTapped(_ sender: Any) {
        self.delegate?.dismiss(self, withEntry:entry)
    }
}
