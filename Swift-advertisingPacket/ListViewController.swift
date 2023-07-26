//
//  ListViewController.swift
//  Swift-advertisingPacket
//
//  Created by Sarah Jeong on 2023/07/24.
//

import UIKit
import CoreBluetooth

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // CBCentralManager
    var centralManager: CBCentralManager!
    var peripherals: [CBPeripheral] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleBLE: UISwitch!
    
    @IBOutlet weak var totalCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.dataSource = self
        tableView.delegate = self

        self.toggleBLE.addTarget(self, action: #selector(self.onClickSwitch(sender:)), for: UIControl.Event.valueChanged)

    }
    
//    @IBAction func toggleBtn(_ sender: UISwitch) {
//
//        if centralManager.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: nil)
//        }
//
//        if toggleBLE.isOn {
//            scanForBLEDevice()
//        } else {
//            centralManager.stopScan()
//        }
//    }
    
    @objc func onClickSwitch(sender: UISwitch) {
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
    let cellName = "ListCell"
    let cellReuseIdentifier = "listCell"
    
    func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ListCell
        
        let peripheral = peripherals[indexPath.row]
        
        listCell.deviceName.text = peripheral.name ?? "Unknown device"
        listCell.address.text = peripheral.identifier.uuidString
        listCell.backgroundColor = UIColor.clear.withAlphaComponent(0)

        return listCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("central state is default unknown")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
            tableView.reloadData()
        }
        
        self.totalCount.text = String(peripherals.count)
    }
}
