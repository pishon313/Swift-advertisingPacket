//
//  AdvertisingViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/26.
//

import UIKit
import CoreBluetooth

class AdvertisingViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOff {
            print("The peripheral statue is Power OFF")
        } else if peripheral.state == .poweredOn {
            startAdvertising()
            print("Advertising START")
        } else {
            print("Something is wrong")
        }
    }
    
    func startAdvertising() {
        
        let advertisingData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "TestDevice",
            // Please put your service UUID in the "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")]
        ]
        
        peripheralManager?.startAdvertising(advertisingData)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        
        if let error = error {
            print("Advertising Failed! error: \(error)")
            return
        }
        print("Advertising is Succeeded!")
    }
    
}
