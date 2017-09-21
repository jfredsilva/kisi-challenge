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

class ReceiverViewController: BluetoothBaseViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {

    fileprivate var locationManager = CLLocationManager()
    fileprivate var lastUnlockedDoorTimeStamp : Date?
    fileprivate var centralManager:CBCentralManager?
    
    fileprivate var peripheral:CBPeripheral?
    
    fileprivate var imageIndicator = UIImageView(image: UIImage(named: "closed"))
    fileprivate let responseMessage = "Door opened!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receiver"

        guard let uuidValue = UUID(uuidString: Constants.UUID) else {return}
        
        beaconRegion = CLBeaconRegion.init(proximityUUID: uuidValue, identifier: Constants.BEACON_ID)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func setUI(){
        super.setUI()
    
        imageIndicator = UIImageView(image: UIImage(named: "closed"))
        
        self.view.addSubview(imageIndicator)
        imageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        imageIndicator.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageIndicator.widthAnchor.constraint(equalToConstant: 160).isActive = true
        imageIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
                    
                    //#FS_verify if there is internet connection
                    CommunicationManager.sharedInstance.openDoor(onCompletion: {(success) in
                        if success {
                            print("Door Unlocked")
                            self.lastUnlockedDoorTimeStamp = Date()
                            
                            DispatchQueue.main.async {
                                self.startOpenAnimation()
                            }
                            
                            self.locationManager.stopRangingBeacons(in: region)
                            
                            self.connectToDevice()
                        }
                    })
                }
                
            }
        }
    }
    
    private func startOpenAnimation(){
        imageIndicator.image = UIImage.gifImageWithName(name: "opening")
    }
    
    private func connectToDevice(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func sendResponse(){
        guard let services = self.peripheral?.services else { print("No services");return }
        
        for service in services{
            if service.uuid == CBUUID(string: Constants.UUID_SERVICE){
                guard let characteristics = service.characteristics else { print("No characteristics"); return }
                
                for characteristic in characteristics{
                    if characteristic.uuid == CBUUID(string: Constants.UUID_SERVICE_RESPONSE){
                        guard let data = self.responseMessage.data(using: .utf8) else { print("No data"); return }
                        
                        self.peripheral?.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
                    }
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
    
    //MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("poweredOn")
            centralManager?.scanForPeripherals(withServices: [CBUUID(string: Constants.UUID_SERVICE)], options: nil)
        case .poweredOff:
            print("poweredOff")
        case .unauthorized:
            print("unauthorized")
        case .unsupported:
            print("unsupported")
        case .unknown:
            print("unknown")
        default:break
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //Verify if the peripheral has the service Constants.UUID_SERVICE advertised
        for data in advertisementData{
            if data.key == "kCBAdvDataServiceUUIDs"{
                guard let value = data.value as? [CBUUID] else { return }
                if value[0] == CBUUID(string: Constants.UUID_SERVICE){
                    if self.peripheral != peripheral{
                        //need to keep a reference of it
                        self.peripheral = peripheral
                        
                        centralManager?.connect(peripheral, options: nil)
                    }
                    
                }
            }
        }

    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connection to peripheral failed")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection to peripheral successful")
        peripheral.delegate = self
        
        peripheral.discoverServices([CBUUID.init(string: Constants.UUID_SERVICE)])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { print("No services"); return }
        
        for service in services{
            if service.uuid == CBUUID(string: Constants.UUID_SERVICE){
                
                peripheral.discoverCharacteristics([CBUUID(string: Constants.UUID_SERVICE_RESPONSE)], for: service)
                
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { print("No characteristics"); return }
        
        for characteristic in characteristics{
            if characteristic.uuid == CBUUID(string: Constants.UUID_SERVICE_RESPONSE){
                guard let data = self.responseMessage.data(using: .utf8) else { print("No data"); return }
                
                self.peripheral?.writeValue(data, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
}
