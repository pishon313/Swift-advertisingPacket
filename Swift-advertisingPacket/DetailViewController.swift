//
//  DetailViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/26.
//

import Foundation
import UIKit

protocol connectDelegate: AnyObject {
    func connectiong()
}

class DetailViewController: UIViewController {
    
    var connectionDelegate: connectDelegate?
    
    @IBOutlet weak var detailDeviceName: UILabel!
    @IBOutlet weak var serviceUUID: UILabel!
    @IBOutlet weak var rssiValue: UILabel!
    
    var deviceName: String?
    var uuidString: String?
    var rssiString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailDeviceName.text = deviceName ?? "Unknown device"
        serviceUUID.text = uuidString ?? "None"
        rssiValue.text = rssiString ?? "None"
    }
    
    
    @IBAction func connectionBtn(_ sender: UIButton) {
        connectionDelegate?.connectiong()
        print("click Button")
    }
    
}
