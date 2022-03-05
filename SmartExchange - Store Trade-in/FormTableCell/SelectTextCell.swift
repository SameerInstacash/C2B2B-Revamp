//
//  SelectTextCell.swift
//  TechCheck
//
//  Created by sameer khan on 31/05/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class SelectTextCell: UITableViewCell {
    
    @IBOutlet weak var selectTextField: UITextField!
    @IBOutlet weak var seperatorLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
        selectTextField.leftView = paddingView
        selectTextField.leftViewMode = .always
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
