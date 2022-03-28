//
//  Ble.swift
//  sensor
//
//  Created by Yu Chen on 3/25/22.
//

import Foundation
import CoreBluetooth

protocol BleDelegate: AnyObject {
    func peripheralsDidUpdate()
}

protocol BluetoothManager {
    var delegate: BleDelegate? { get set }
    func start() throws
    func stop()
}

public class Ble: NSObject, BluetoothManager {
    weak var delegate: BleDelegate?
    
    public private(set) var isAdvertising = false
    public var advertisingData: [String: Any] = [:]

    private var peripheralManager: CBPeripheralManager?
    
    public override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    public func start() throws {
        peripheralManager?.startAdvertising(advertisingData)
    }
    
    public func stop() {
        peripheralManager?.stopAdvertising()
    }
}

extension Ble: CBPeripheralManagerDelegate {
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        isAdvertising = peripheral.isAdvertising
    }
}
