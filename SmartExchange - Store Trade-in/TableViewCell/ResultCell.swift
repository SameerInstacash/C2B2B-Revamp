//
//  ResultCell.swift
//  TechCheck Exchange
//
//  Created by Sameer Khan on 19/07/21.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblQuestion.setLineHeight(lineHeight: 3.0)
        self.lblQuestion.textAlignment = .left
        
        self.lblAnswer.setLineHeight(lineHeight: 3.0)
        self.lblAnswer.textAlignment = .left
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
