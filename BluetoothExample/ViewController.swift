//
//  ViewController.swift
//  BluetoothExample
//
//  Created by Michael Sigsbey on 5/1/21.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {
    
    let discoveryQueue = DispatchQueue(label: "discoveryQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)
    var bluetoothManager: CBCentralManager?
    var deviceList: DiscoveredDevicesTableViewController =  {
        let controller = UIStoryboard(name: "DiscoveredDevicesTableViewController", bundle: .main).instantiateInitialViewController() as! DiscoveredDevicesTableViewController
        return controller
    }()
    @IBOutlet var discoverDevicesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bluetoothManager = CBCentralManager(delegate: self, queue: discoveryQueue)

    }

    @IBAction func startDiscoveryPressed(sender: UIButton) {
        guard let central = bluetoothManager,
              central.state == .poweredOn else {
            print("Bluetooth not set up.")
            return
        }
        
        if central.isScanning {
            central.stopScan()
        }
        
        deviceList.bluetoothManager = central
        central.delegate = deviceList
        central.scanForPeripherals(withServices: nil, options: nil)
        self.navigationController?.pushViewController(deviceList, animated: true)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            DispatchQueue.main.async {
                self.discoverDevicesButton.isEnabled = true
            }
            print("Bluetooth powered on")
        case .poweredOff:
            DispatchQueue.main.async {
                self.discoverDevicesButton.isEnabled = false
            }
            print("Bluetooth powered off.")
        case .unsupported, .unauthorized, .unknown, .resetting:
            DispatchQueue.main.async {
                self.discoverDevicesButton.isEnabled = false
            }
            print("Issue turning on BT, please check settings")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered device")
    }
}

