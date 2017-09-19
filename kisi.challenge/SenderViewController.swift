//
//  SenderViewController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 19/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class SenderViewController: BluetoothBaseViewController {
    fileprivate var beaconData: NSDictionary?
    
    fileprivate let major: CLBeaconMajorValue = 2
    
    fileprivate var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sender"
        
        setData(withMinor: self.minor)
        
        //Timer to swith minor value every 10 seconds
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.restartBeacon), userInfo: nil, repeats: true)
        
    }

    func restartBeacon(){
        self.minor = self.minor == 0 ? 1 : 0
        
        self.stopAdvertising()
        setData(withMinor: self.minor)
        self.startAdvertising()
    }
    
    private func setData(withMinor minor: CLBeaconMajorValue){
        guard let uuidValue = UUID(uuidString: Constants.UUID) else { return }
        
        beaconRegion = CLBeaconRegion(proximityUUID: uuidValue, major: self.major, minor: minor, identifier: Constants.BEACON_ID)
        beaconData = beaconRegion?.peripheralData(withMeasuredPower: nil)
    }
    
    private func startAdvertising(){
        guard let data = beaconData as? [String : Any] else { return }
        peripheralManager.startAdvertising(data)
    }
    
    private func stopAdvertising(){
        peripheralManager.stopAdvertising()
    }
    
    //MARK: CBPeripheralManagerDelegate
    override func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        super.peripheralManagerDidUpdateState(peripheral)
        
        switch peripheral.state{
        case .poweredOff:
            if peripheral.isAdvertising{
                self.stopAdvertising()
            }
        case .poweredOn:
            self.startAdvertising()
        default: break
        }
    }
}
