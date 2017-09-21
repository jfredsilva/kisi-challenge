//
//  BluetoothBaseViewController.swift
//  kisi.challenge
//
//  Created by Fred Silva on 19/09/17.
//  Copyright © 2017 Fred Silva. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class BluetoothBaseViewController: UIViewController, CBPeripheralManagerDelegate {

    var peripheralManager = CBPeripheralManager()
    var beaconRegion: CLBeaconRegion?
    
    var minor: CLBeaconMajorValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setUI()
        
        peripheralManager.delegate = self
    }

    func setUI(){
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state{
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("Not supported")
        case .unauthorized:
            print("Please authorize")
        case .poweredOff:
            print("PoweredOff")
        case .poweredOn:
            print("PoweredOn")
        }
    }
}
