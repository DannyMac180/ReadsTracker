//
//  BookTableViewCell.swift
//  BookTracker
//
//  Created by Daniel McAteer on 10/8/17.
//  Copyright © 2017 Daniel McAteer. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    var currentBook: GoogleBook?
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backGroundCardView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func updateUI() {
        self.backgroundColor = UIColor.clear
        backGroundCardView.backgroundColor = UIColor.white
        backGroundCardView.layer.cornerRadius = 3.0
        backGroundCardView.layer.masksToBounds = false
        backGroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backGroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGroundCardView.layer.shadowOpacity = 0.8
        titleLabel.font = UIFont(name: "GillSans", size: 23.0)
        authorLabel.font = UIFont(name: "GillSans", size: 20.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
