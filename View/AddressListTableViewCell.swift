//
//  AddressListTableViewCell.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var cellData: Address? {
        didSet {
            guard let cellData = cellData else { return }
            addressImage.image = address.photo!
            addressTitle.text = address.title
            addressDesc.text = address.desc
        }
    }
    
    // MARK: - Outlets
    @IBOutlet var addressImage: UIImageView!
    @IBOutlet var addressTitle: UILabel!
    @IBOutlet var addressDesc: UILabel!
}
