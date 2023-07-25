//
//  ListViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/24.
//

import UIKit
import CoreBluetooth

class ListViewController: UIViewController {
    
    // CBCentralManager
    var centralManager: CBCentralManager!

    @IBOutlet weak var toggleBLE: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    @IBAction func toggleBtn(_ sender: Any) {
        
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
}

extension ListViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .unknown:
            print("central state is UNKNOWN")
        case .resetting:
            print("central state is RESETTING")
        case .unsupported:
            print("central state is UNSUPPORTED")
        case .unauthorized:
            print("central state is UNAUTHORIZED")
        case .poweredOff:
            print("central state is POWERED OFF")
        case .poweredOn:
            print("central state is POWER ON")
        default:
            print("central state is default unknown")
        }
        
    }
}
