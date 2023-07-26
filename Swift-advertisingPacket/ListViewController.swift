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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func toggleBtn(_ sender: Any) {
        
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name ?? "Unknown Device"
        
        return cell
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
    }
}
