//
//  AuthCell.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/3.
//

import UIKit

class AuthCell: UITableViewCell {

    @IBOutlet weak var lbFirstname: UILabel!
    
    @IBOutlet weak var lbLastname: UILabel!
    
    @IBOutlet weak var lbEmail: UILabel!
    
    @IBOutlet weak var lbPassword: UILabel!
    
    static let identifier = "AuthCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
