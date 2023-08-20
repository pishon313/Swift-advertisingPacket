//
//  PeripheralManager.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/08/01.
//

import Foundation
import CoreBluetooth
import UserNotifications


class PeripheralManager: NSObject, CBPeripheralManagerDelegate {
    
    var peripheralManager: CBPeripheralManager!
    var globalPeripheral: CBPeripheral? = nil
    var createService = [CBService]()
    
    var serviceStr = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    
    // Characteristics
    let CH_READ  = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    let CH_WRITE = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    let TextToAdvertise = "hello!"
    var TextToNotify = "Notification: "
    
    var notifyCharac: CBMutableCharacteristic? = nil
    var notifyValueTimer: Timer?
    
    var delegate: PeripheralProtocol?
    
    
    // start the PeripheralManager
    func startPeripheral() {
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        let state = getState(peripheral: peripheral)
        
        if peripheral.state == .poweredOn {
        }
        
    }
    
    func createServices() {
        
        // services
        let serviceUUID = CBUUID(string: serviceStr)
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // characteristic
        var chs = [CBMutableCharacteristic]()
        
        // Read characteristic
        let characteristicUUID_read = CBUUID(string: CH_READ)
        let properties_read: CBCharacteristicProperties = [.read, .notify]
        let permissions_read: CBAttributePermissions = [.readable]
        let ch_read = CBMutableCharacteristic(type: characteristicUUID_read, properties: properties_read, value: nil, permissions: permissions_read)
        chs.append(ch_read)
        
        // Write characteristic
        let charactertisticUUID_write = CBUUID(string: CH_WRITE)
        let properties_write: CBCharacteristicProperties = [.write, .notify]
        let permission_write: CBAttributePermissions = [.writeable]
        let ch_write = CBMutableCharacteristic(type: charactertisticUUID_write, properties: properties_write, value: nil, permissions: permission_write)
        chs.append(ch_write)
        
        // Cerate the service, add the characteristic to it
        service.characteristics = chs
        peripheralManager.add(service)
    }
    
    
    func getState(peripheral: CBPeripheralManager) -> String {
        
        switch peripheral.state {
        case .poweredOn:
            return "poweredON"
        case .poweredOff:
            return "poweredOFF"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        default:
            return "unknown"
        }
    }
}


