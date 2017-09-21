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

class SenderViewController: BluetoothBaseViewController{
    fileprivate var beaconData: NSDictionary?
    
    fileprivate let major: CLBeaconMajorValue = 2
    
    fileprivate var timer: Timer?
    
    fileprivate let infoLabel = UILabel()
    fileprivate let bleSwitchButton = UIButton()
    fileprivate var beaconIsActive = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sender"
        
        bleSwitchButton.addTarget(self, action: #selector(bleSwitchTapped), for: .touchUpInside)
        
        changeAdvertisingInfo(labelText: "Advertising as Beacon", buttonText: "Switch to BLE")
        setUI()
        
        setData(withMinor: self.minor)
    }

    private func setUI(){
        self.navigationController?.navigationBar.isTranslucent = false
        
        bleSwitchButton.backgroundColor = UIColor.gray
        bleSwitchButton.titleLabel?.textAlignment = .center
        bleSwitchButton.titleLabel?.textColor = UIColor.white
        
        infoLabel.font = infoLabel.font.withSize(13)
        
        self.view.addSubview(bleSwitchButton)
        bleSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        
        bleSwitchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bleSwitchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        bleSwitchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        bleSwitchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    }
    
    func restartBeacon(){
        self.minor = self.minor == 0 ? 1 : 0
        
        self.stopAdvertising()
        setData(withMinor: self.minor)
        self.startAdvertisingBeacon()
    }
    
    private func switchButtonState(){
        self.stopAdvertising()
        
        if beaconIsActive{
            changeAdvertisingInfo(labelText: "Advertising as BLE", buttonText: "Switch to Beacon")
            
            self.startAdvertisingBle()
        }else{
            changeAdvertisingInfo(labelText: "Advertising as Beacon", buttonText: "Switch to BLE")
            
            self.startAdvertisingBeacon()
        }
        
        beaconIsActive = !beaconIsActive
    }
    
    private func changeAdvertisingInfo(labelText textL: String, buttonText textB: String){
        infoLabel.text = textL
        bleSwitchButton.setTitle(textB, for: .normal)
    }
    
    func bleSwitchTapped(sender: UITapGestureRecognizer) {
        switchButtonState()
    }
    
    private func setData(withMinor minor: CLBeaconMajorValue){
        guard let uuidValue = UUID(uuidString: Constants.UUID) else { return }
        
        beaconRegion = CLBeaconRegion(proximityUUID: uuidValue, major: self.major, minor: minor, identifier: Constants.BEACON_ID)
        beaconData = beaconRegion?.peripheralData(withMeasuredPower: nil)
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    private func startAdvertisingBle(){
        self.stopTimer()
        
        let data = [CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: Constants.UUID_SERVICE)]]
        peripheralManager.startAdvertising(data)
    }
    
    private func startAdvertisingBeacon(){
        if timer == nil{
            //Timer to swith minor value every 10 seconds
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.restartBeacon), userInfo: nil, repeats: true)
        }
        
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
            if beaconIsActive{
                self.startAdvertisingBeacon()
            }else{
                self.startAdvertisingBle()
            }
            
        default: break
        }
    }
}
