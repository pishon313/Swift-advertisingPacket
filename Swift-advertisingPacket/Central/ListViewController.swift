//
//  ListViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/24.
//

import UIKit
import CoreBluetooth

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, connectDelegate {

    // CBCentralManager
    var centralManager: CBCentralManager!
    var peripherals: [CBPeripheral] = []
    var deviceNames: [String] = []
    var serviceUUIDs: [Any] = []
    var rssiValues:[NSNumber] = []
    var adverObj:[Data] = []
    var manufacturerData: [String] = []
    
    var globalPeripheral: CBPeripheral!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleBLE: UISwitch!
    
    @IBOutlet weak var totalCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.dataSource = self
        tableView.delegate = self

//        self.toggleBLE.addTarget(self, action: #selector(self.onClickSwitch(sender:)), for: UIControl.Event.valueChanged)

    }
    
    @IBAction func toggleBtn(_ sender: UISwitch) {

//        if centralManager.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: nil)
//        }

        if toggleBLE.isOn {
            scanForBLEDevice()
            print("switch is ON")
        } else {
            centralManager.stopScan()
            print("switch is OFF")
        }
    }
    
//    @objc func onClickSwitch(sender: UISwitch) {
//        if toggleBLE.isOn {
//            scanForBLEDevice()
//        } else if !toggleBLE.isOn {
//            centralManager.stopScan()
//            print("switch is OFF")
//        }
//    }
    
    func scanForBLEDevice() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        } else if centralManager.state == .poweredOff {
            // BLE 권한을 켜달라는 팝업
        }
    }
    
    //ListCell regist
    let cellName = "ListCell"
    let cellReuseIdentifier = "listCell"
    
    func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController {
            detailViewController.connectionDelegate = self
        }
    }

    func connectiong() {
        self.centralManager.connect(self.globalPeripheral, options: nil)
    }
    
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ListCell
        
        let peripheral = peripherals[indexPath.row]
        
        listCell.deviceName.text = peripheral.name ?? "Unknown device"
        listCell.backgroundColor = UIColor.clear.withAlphaComponent(0)

        return listCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let peripheral = peripherals[indexPath.row]
        let rssiValue = rssiValues[indexPath.row]
        
        self.globalPeripheral = peripheral
        
        detailViewController.deviceName = peripheral.name
        detailViewController.uuidString = peripheral.identifier.uuidString
        detailViewController.rssiString = rssiValue.stringValue
        detailViewController.manufacturerDataArr = manufacturerData.joined(separator: ", ")
        
        print("Device name: \(String(describing: peripheral.name))")
        print("uuidString: \(String(describing: peripheral.identifier.uuidString))")
        print("rssiString: \(String(describing: rssiValue.stringValue))")
//        print("manufacturer ID: \(String(describing: ))")
        
        present(detailViewController, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension ListViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
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
        
        self.globalPeripheral = peripheral
        self.globalPeripheral.delegate = self
        self.globalPeripheral.discoverServices(nil)
        
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
            rssiValues.append(RSSI)
            
            if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                print("Device name: \(name)")
            }
            //
            if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
                let manufacturerString = String(data: manufacturerData, encoding: .utf8)
                var bytes = [UInt8](manufacturerData)
                let hexString = manufacturerData.map { String(format: "%02hhx", $0) }.joined()
                let range = 0..<2
                let firstTwoByte = hexString.prefix(2)
                
                print("CBmanufacturerData: \(manufacturerData)")
                print("CBmanufacturerString: \(manufacturerString)")
                print("CBManufacturerData Data: \(bytes)")
                print("CBmanufacturerString: \(manufacturerString)")
                print(" CBhexString: \(hexString)")
                print("여기: \(firstTwoByte)")
            }
            
            let advertisingData = advertisementData
            print("advertisingData: \(advertisingData)")
            if let kCBAdvDataManufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
//                var kCBmanufacturerString = String(data: kCBAdvDataManufacturerData, encoding: .utf8)
                let kCBbytes = [UInt8](kCBAdvDataManufacturerData)
                let KCBhexString = kCBAdvDataManufacturerData.map { String(format: "%02x", $0) }
                let firstTwoByte = KCBhexString.prefix(2).joined()
//                print("kCBmanufacturerString: \(kCBmanufacturerString)")
                print("kCBbytes: \(kCBbytes)")
                print("KCBhexString: \(KCBhexString)")
                print("첫 두글자: \(firstTwoByte)")
                // Task: kCBAdvDataManufacturerData 가 없는 periphseral 도 있어서 이건 신뢰도가 떨어짐
                self.manufacturerData = KCBhexString
                
                if firstTwoByte == "ffff" {
                    print("테스트 name: \(peripheral.name!)")
//                    print("테스트 serviceUUID: \(peripheral.services)")
                }
            }
            
            if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
                for uuid in serviceUUIDs {
                    print("Service UUID: \(uuid)")
                }
            }
            var serviceUUID = advertisementData[CBAdvertisementDataServiceUUIDsKey] ?? "N/A"
            serviceUUIDs.append(serviceUUID)
            
            print("test serviceUUID: \(serviceUUID)")
            
            /*
             NSString *serviceData = [advertisementData valueForKey:@"kCBAdvDataServiceData"];
             NSString *devInfo = [self serviceDataValue:@"Device Information" withData:serviceData];

             devInfo = [[devInfo stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
             */
            
            var serviceData = advertisementData["kCBAdvDataServiceData"]
            print("serviceData: \(serviceData)")
            
            
            
            tableView.reloadData()
        }
        self.totalCount.text = String(peripherals.count)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let error = error {
            print("Error discoverig services: \(error.localizedDescription)")
            return
        }
     
        if let services = peripheral.services {
            for service in services {
                print("테스트 서비스 UUID: \(service)")
            }
        }
        
    }
    
}
