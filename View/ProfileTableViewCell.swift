//
//  ProfileTableViewCell.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    
     // MARK: - Cell Methods
     override init(frame: CGRect) {
         super.init(frame: frame)
         initializeCell()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         initializeCell()
     }
     
     override func awakeFromNib() {
         super.awakeFromNib()
         initializeCell()
     }
    
    // MARK: - Configuration Methods
    fileprivate func initializeCell() { }
    
    func configureCell(with user: User) {
        nameLabel.text = user?.username
        mailLabesl.text = user?.email
    }
}
