//
//  ProductCell.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/6.
//

import UIKit

class ProductCell: UITableViewCell {

    
    @IBOutlet weak var lbFirstName: UILabel!
    
    @IBOutlet weak var lbLastName: UILabel!
    
    @IBOutlet weak var lbEmail: UILabel!
    
    static let identifier = "ProductCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
