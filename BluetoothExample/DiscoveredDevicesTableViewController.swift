//
//  DiscoveredDevicesTableViewController.swift
//  BluetoothExample
//
//  Created by Michael Sigsbey on 5/1/21.
//

import Foundation
import UIKit
import CoreBluetooth

class DiscoveredDevicesTableViewController: UITableViewController, CBCentralManagerDelegate {
    
    struct PeripheralData {
        let peripheral: CBPeripheral
        let advertisementData: [String: Any]
        var rssi: NSNumber
    }
    
    var bluetoothManager: CBCentralManager?
    var peripherals: [PeripheralData] = []
    
    // MARK: - UITableViewDelegate/DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peripheralCell")!
        
        let currentPeripheral = peripherals[indexPath.row]
        cell.textLabel?.text = currentPeripheral.peripheral.name
        cell.detailTextLabel?.text = "RSSI: \(currentPeripheral.rssi), Advertisement: \(currentPeripheral.advertisementData)"
        
        return cell
    }
    
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("State changed: \(central.state)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = PeripheralData(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
        DispatchQueue.main.async {
            self.updatePeripherals(peripheral: newPeripheral)
        }
    }
    
    func updatePeripherals(peripheral: PeripheralData) {
        if let index = peripherals.firstIndex(where: { $0.peripheral.name == peripheral.peripheral.name }) {
            peripherals[index] = peripheral
        } else {
            peripherals.append(peripheral)
        }
        
        tableView.reloadData()
    }
}
