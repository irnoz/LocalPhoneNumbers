//
//  PhoneNumberTableViewCell.swift
//  PhoneNubersCoreData
//
//  Created by Irakli Nozadze on 19.12.22.
//

import UIKit

class PhoneNumberTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var PhoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
