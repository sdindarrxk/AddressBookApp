//
//  CommonTextField.swift
//  AddressBook
//
//  Created by Sabri on 2024.
//

import UIKit

@IBDesignable
class CommonTextField: UITextField {
    
    // MARK: - Properties
    @IBInspectable var imageName: String! {
        didSet {
            setLeftImage(imageName: imageName)
        }
    }
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helper Methods
    fileprivate func setLeftImage(imageName: String) {
        self.leftViewMode = .always
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let iconView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        iconView.image = UIImage(named: imageName)
        iconView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconView)
        self.leftView = iconContainer
    }
}
