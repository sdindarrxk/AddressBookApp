//
//  CommonButton.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

@IBDesignable
class CommonButton: UIButton {
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor(named: "PrimaryColor")
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
