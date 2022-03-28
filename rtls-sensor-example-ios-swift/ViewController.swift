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
    }

    func generateAdvertisingData() -> [String: Any] {
        let id: UInt16 = 0x1234
        let alarm: UInt8 = 0
        let battery: UInt8 = 5
        let data = coreaiot_generate_service_uuids(id, alarm, battery);
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
            CBAdvertisementDataServiceUUIDsKey: uuids
        ]
    }
}

