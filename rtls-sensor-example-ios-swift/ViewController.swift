//
//  ViewController.swift
//  rtls-sensor-example-ios-swift
//
//  Created by Yu Chen on 2022/3/25.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    let ble = Ble()
    var started = false

    @IBOutlet weak var mac: UITextField!
    @IBOutlet weak var alarm: UISwitch!
    @IBOutlet weak var moving: UISwitch!
    
    @IBOutlet weak var btn: UIButton!
    @IBAction func btnClick(_ sender: Any) {
        if !started {
            ble.advertisingData = generateAdvertisingData()
            try! ble.start()
        } else {
            ble.stop()
        }
        started = !started
        btn.setTitle(started ? "Stop" : "Start", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    func generateAdvertisingData() -> [String: Any] {
        let id: UInt16 = UInt16(mac.text ?? "1234", radix: 16) ?? 0x1234
        let alarm: UInt8 = self.alarm.isOn ? 1 : 0
        let battery: UInt8 = UInt8(UIDevice.current.batteryLevel * 10)
        let isStatic: UInt8 = moving.isOn ? 0 : 1
        let data = coreaiot_generate_service_uuids(id, alarm, battery, isStatic);
        let len = Int(COREAIOT_NUMBER_OF_SERVICE_UUIDS);
        var arr = [UInt16](repeating: 0, count: len)

        for i in 0..<len {
            arr[i] = data![i]
        }
        
        let uuids = arr.map { x in
            return CBUUID(string: String(format: "%04x", x))
        }
        
        dump(uuids)

        return [
            CBAdvertisementDataServiceUUIDsKey: uuids,
            CBAdvertisementDataTxPowerLevelKey: CBAdvertisementDataTxPowerLevelKey
        ]
    }
}

