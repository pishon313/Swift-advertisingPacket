//
//  ListCell.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/26.
//

import UIKit

class ListCell: UITableViewCell {
    
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
