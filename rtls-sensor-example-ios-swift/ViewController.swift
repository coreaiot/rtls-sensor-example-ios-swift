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
    var channel: UInt8 = 0

    @IBOutlet weak var mac: UITextField!
    @IBOutlet weak var alarm: UISwitch!
    @IBOutlet weak var moving: UISwitch!
    @IBOutlet weak var channelButton: UIButton!
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var channel37: UICommand!
    @IBOutlet weak var channel38: UICommand!
    @IBOutlet weak var channel39: UICommand!
    @IBOutlet weak var content: UITextView!
    
    @IBAction func channelSelect(_ sender: UICommand) {
        channelButton.setTitle(sender.title, for: .normal)
        
        if sender.title.starts(with: "38") {
            channel = 1
        } else if sender.title.starts(with: "39") {
            channel = 2
        } else {
            channel = 0
        }
    }
    
    @IBAction func btnClick(_ sender: Any) {
        if !started {
            ble.advertisingData = generateAdvertisingData()
            try! ble.start()
        } else {
            ble.stop()
            content.text = ""
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
        
        print("mac:", mac.text ?? "1234")
        print("id:", id)
        print("alarm:", alarm)
        print("battery:", battery)
        print("channel:", channel)
        
        let data = coreaiot_generate_service_uuids(id, alarm, battery, channel, isStatic);
        let len = Int(COREAIOT_NUMBER_OF_SERVICE_UUIDS);
        var arr = [UInt16](repeating: 0, count: len)

        for i in 0..<len {
            arr[i] = data![i]
        }
        
        let uuids = arr.map { x in
            return CBUUID(string: String(format: "%04x", x))
        }
        
        content.text = uuids.description;

        return [
            CBAdvertisementDataServiceUUIDsKey: uuids
        ]
    }
}

