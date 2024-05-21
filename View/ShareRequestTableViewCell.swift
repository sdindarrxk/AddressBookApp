//
//  ShareRequestTableViewCell.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class ShareRequestTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var cellData = cellData {
        didSet {
            usernameLbl.text = user.username
        }
    }
    
    // MARK: - Outlets
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var positiveBtn: UIButton!
    @IBOutlet var negativeBtn: UIButton!
    
    // MARK: - Init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeCell()
    }
    
    fileprivate func initializeCell() {
        positiveBtn.layer.cornerRadius = 5
        negativeBtn.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
