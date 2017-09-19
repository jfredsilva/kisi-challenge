//
//  ReceiverViewController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 19/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ReceiverViewController: BluetoothBaseViewController, CLLocationManagerDelegate {

    fileprivate var locationManager = CLLocationManager()
    fileprivate var lastUnlockedDoorTimeStamp : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receiver"
        
        guard let uuidValue = UUID(uuidString: Constants.UUID) else {return}
        
        beaconRegion = CLBeaconRegion.init(proximityUUID: uuidValue, identifier: Constants.BEACON_ID)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    private func isDoorUnlockedMoreThan4Seconds() -> Bool{
        guard let lastData = self.lastUnlockedDoorTimeStamp else { return true }
        let interval = Date().timeIntervalSince(lastData)
        return !interval.isLess(than: 4)
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            print("Found beacon")
            let beacon = beacons.first
            
            guard let isMinor = beacon?.minor.isEqual(minor) else { return }
            
            //since there's no exact guarantee on actual distance value, I use CLProximityNear and CLProximityImmediate
            if isMinor && (beacon?.proximity == .near || beacon?.proximity == .immediate){
                //Only continue if door was unlocked more than 4 seconds ago
                if isDoorUnlockedMoreThan4Seconds(){
                    locationManager.stopRangingBeacons(in: region)
                    CommunicationManager.sharedInstance.openDoor(onCompletion: {(success) in
                        if success {
                            print("Door Unlocked")
                            self.lastUnlockedDoorTimeStamp = Date()
                            self.locationManager.startRangingBeacons(in: region)
                        }
                    })
                }
                
            }
        }
    }
    
    //MARK: CBPeripheralManagerDelegate
    override func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        super.peripheralManagerDidUpdateState(peripheral)
        
        guard let region = beaconRegion else { return }
        
        switch peripheral.state{
        case .poweredOff:
            locationManager.stopRangingBeacons(in: region)
        case .poweredOn:
            locationManager.startRangingBeacons(in: region)
        default: break
        }
    }
}
