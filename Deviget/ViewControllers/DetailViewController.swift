//
//  DetailViewController.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var authorLB: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    func configureView() {
        self.titleLB.text = detailEntry.title
        self.authorLB.text = detailEntry.author
        self.postImageView.setImage(fromURL: detailEntry.thumbnail)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard detailEntry != nil else { return }
        configureView()
    }

    var detailEntry: Entry! 


}

