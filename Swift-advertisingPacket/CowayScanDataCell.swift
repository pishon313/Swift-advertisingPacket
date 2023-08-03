//
//  CowayScanDataCell.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/08/03.
//

import Foundation
import UIKit

class CowayScanDataCell: UITableViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var manufacturerID: UILabel!
    @IBOutlet weak var materialCode: UILabel!
    @IBOutlet weak var services: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
