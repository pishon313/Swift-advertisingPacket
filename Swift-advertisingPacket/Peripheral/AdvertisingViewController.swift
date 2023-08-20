//
//  AdvertisingViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/26.
//

import UIKit
import CoreBluetooth
import UserNotifications

/*
 var refreshLogs: Timer?
 var ble: BLEPeripheralManager?

 var timerOn: Bool = false
 */

class AdvertisingViewController: UIViewController, CBPeripheralManagerDelegate {
    
    var centralManager: CBCentralManager?
    var peripheralManager: CBPeripheralManager?
    
    var timerOn: Bool = false
    var refreshTimer: Timer?
    
    var peripheralManager: PeripheralManager?
    
    @IBOutlet weak var adverStatusLB: UILabel!
    @IBOutlet weak var peripheralSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        peripheralSwitch.isOn = false
        adverStatusLB.text = "🌞 Start advertising"
        
        peripheralManager = PeripheralManager()
        peripheralManager?.delegate = self
        
    }
    
    @IBAction func peripheralSwitchOnOff(_ sender: Any) {
        
        if self.peripheralSwitch.isOn {
    
            self.adverStatusLB.text = "🌙 Stop advertising"
            startAdvertising()
        
        } else {
            
            self.adverStatusLB.text = "🌞 Start advertising"
            peripheralManager?.stopAdvertising()
            
        }
    }
     
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        
    }
    
    func startAdvertising() {
        
        let advertisingData: [String: Any] = [
            CBAdvertisementDataLocalNameKey: "TestDevice",
//            CBAdvertisementDataServiceUUIDsKey: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
//            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")]
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
    
    func checkBluetoothState() -> Bool {
        switch centralManager?.state {
        case .poweredOn:
            print("Bluetooth is On")
            return true
        case .unknown, .resetting:
            print("Bluetooth status is updating, wait for it to  finish")
            return false
        case .poweredOff, .unsupported, .unauthorized:
            print("Bluetooth is unusable on this device")
            showAlertToEnableBluetooth()
            return false
        default:
            fatalError("UnKnown state.")
            return false
        }
    }
    
    func showAlertToEnableBluetooth() {
        let alertController = UIAlertController(title: "Bluetooth Required", message: "Please turn on Bluetooth in Settings", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
