//
//  CowayScanData.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/08/03.
//

import Foundation
import UIKit
import CoreBluetooth

class CowayScanData: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // CBCentralManager
    var centralManager: CBCentralManager!
    var globalPeripheral: CBPeripheral!
    
    var peripherals: [CBPeripheral] = []
    var deviceNames: [String] = []
    var serviceUUIDs: [Any] = []
    var rssiValues:[NSNumber] = []
    var adverObj:[Data] = []
    var manufacturerData: [String] = []
    var servicesArr: [String] = []
    var materialCode: [String] = []
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleBLE: UISwitch!
    @IBOutlet weak var totalCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.dataSource = self
        tableView.delegate = self
        centralManager.delegate = self

    }
    
    @IBAction func toggleBtn(_ sender: UISwitch) {

        if toggleBLE.isOn {
            scanForBLEDevice()
            print("switch is ON")
        } else {
            centralManager.stopScan()
            print("switch is OFF")
        }
    }
    
    func scanForBLEDevice() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        } else if centralManager.state == .poweredOff {
            // BLE 권한을 켜달라는 팝업
        }
    }
    
    //ListCell regist
    let cellName = "CowayScanDataCell"
    let cellReuseIdentifier = "cowayScanDataCell"
    
    func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cowayScanDataCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! CowayScanDataCell
        
        let peripheral = peripherals[indexPath.row]
        cowayScanDataCell.deviceName.text = "Device name: \(peripheral.name ?? "Name Error")"
        cowayScanDataCell.manufacturerID.text = "0xFFFF"
        cowayScanDataCell.materialCode.text = "Material Code: \n \(materialCode.joined(separator: "\n"))"
        cowayScanDataCell.services.text = "services: \(servicesArr.joined(separator: ", "))"
        
        return cowayScanDataCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    // MARK: - CBCentralManagerDelegate
    
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
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("central state is default unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            
            var hexString = manufacturerData.map { String(format: "%02hhx", $0) }.joined()
            let firstTwoByte = hexString.prefix(2)
            //            print("manufacturerData: \(firstTwoByte)")
        }
        
        if let kCBAdvDataManufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
            
            let KCBhexString = kCBAdvDataManufacturerData.map { String(format: "%02x", $0) }
            let firstTwoByte = KCBhexString.prefix(2).joined()
            
//            print("KCBhexString: \(KCBhexString)")
//            print("첫 두글자: \(firstTwoByte)")
            
            // manufacturer Data
            if firstTwoByte == "ffff" {
                self.globalPeripheral = peripheral
                print("FFFF 발견: \(peripheral.name)")

                
                self.globalPeripheral = peripheral
                self.globalPeripheral.delegate = self
                centralManager.connect(self.globalPeripheral!, options: nil)
                
                if !peripherals.contains(peripheral) {
                    peripherals.append(peripheral)
                    print("peripheral.append: \(peripheral)")
                }
                
                // MaterialCode Data
                if KCBhexString.count >= 10 {
                    let slicedArray = Array(KCBhexString[0..<9])
                    print("Metarial Data: \(slicedArray)")
                    
                    let metarialCodeString = slicedArray.joined(separator: ",")
                    
                    if !materialCode.contains(metarialCodeString) {
                        materialCode.append(metarialCodeString)
                    }
                }
            }
        }
        
        tableView.reloadData()
        self.totalCount.text = String(peripherals.count)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        self.globalPeripheral.discoverServices(nil)
    
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            print("Error discoverig services: \(error.localizedDescription)")
            return
        }
        
        if let services = peripheral.services {
            for service in services {
                print("테스트 서비스 UUID: \(service)")
                
                let serviceString = service.uuid.uuidString
                
                if !servicesArr.contains(serviceString) {
                    servicesArr.append(serviceString)
                }
            }
        }
        tableView.reloadData()
    }
}
