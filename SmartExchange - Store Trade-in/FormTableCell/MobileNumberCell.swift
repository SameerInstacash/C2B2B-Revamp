//
//  MobileNumberCell.swift
//  TechCheck
//
//  Created by sameer khan on 06/06/20.
//  Copyright © 2020 Prakhar Gupta. All rights reserved.
//

import UIKit

class MobileNumberCell: UITableViewCell {
    
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var paymentImgView: UIImageView!
    @IBOutlet weak var seperatorLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
        mobileNumberTxtField.leftView = paddingView
        mobileNumberTxtField.leftViewMode = .always
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
