//
//  ViewController.swift
//  Runewood
//
//  Created by Apple on 15/12/2021.
//

import UIKit
import CoreBluetooth
import SwiftLoader
class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    @IBOutlet weak var deviceTableView: UITableView!
    @IBOutlet weak var ScanBtn: UIButton!
    private let refreshControl = UIRefreshControl()
    var myIndicator: MyIndicator?
    var discoveredPeripherals: Array<CBPeripheral> = []
    var DisconnectedshowToas = false
    var timeoutToast = false
    //var connectedPeripheral: CBPeripheral?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetMainLoader()
        hideLoader()
        AddRefreshControler()
        constants.centralManager = CBCentralManager(delegate: self, queue: nil)
        if DisconnectedshowToas == true{
            self.showToast(message: "Device Disconnected", font: .boldSystemFont(ofSize: 16))
        }
        if timeoutToast == true{
            self.showToast(message: "Connection Timeout", font: .boldSystemFont(ofSize: 16))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        constants.AppExitTimer.invalidate()
        constants.disconnecttimer.invalidate()
    }
    
    
    func reloadDevices(){
        constants.centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    func ReStartApp(){
        //        constants.centralManager?.cancelPeripheralConnection(constants.connectedPeripheral!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GoToMainScreen(){
        //        constants.centralManager?.cancelPeripheralConnection(constants.connectedPeripheral!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func manualRefresh() {
        if self.deviceTableView.refreshControl != nil {
            refreshControl.tintColor = UIColor.white
            self.deviceTableView.setContentOffset(CGPoint(x: 0, y: 60), animated: true)
            self.deviceTableView.refreshControl?.beginRefreshing()
            self.deviceTableView.refreshControl?.sendActions(for: .valueChanged)
        }
    }
    
    @IBAction func scanBtnAction(_ sender: Any) {
        
        manualRefresh()
        self.refreshControl.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            constants.centralManager = CBCentralManager(delegate: self, queue: nil)
            self.refreshControl.endRefreshing()
        }
        
    }
    func startScanning() -> Void {
        // Start Scanning
        discoveredPeripherals.removeAll()
        constants.centralManager?.scanForPeripherals(withServices: nil,options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        switch central.state {
        case .unauthorized: break
        case .unknown: break
        case .unsupported: break
        case .poweredOn:
            startScanning()
        case .poweredOff: break
        case .resetting: break
        @unknown default: break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == nil {}else{
            if discoveredPeripherals.count == 0{
                self.discoveredPeripherals.append(peripheral)
            }else{
                var ind = 0
                var isExist = false
                for (index,per ) in discoveredPeripherals.enumerated(){
                    if peripheral.identifier.uuidString == per.identifier.uuidString{
                        isExist = true
                        ind = index
                    }
                }
                if(isExist){
                    discoveredPeripherals.remove(at: ind)
                }
                self.discoveredPeripherals.append(peripheral)
            }
            
        }
        //centralManager?.connect(peripheral, options: nil)
        constants.centralManager?.stopScan()
        deviceTableView.reloadData()
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        constants.connectedPeripheral = peripheral
        GotoPasswordScreen()
    }
    
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell") as! DeviceTableViewCell
        let peripheral = discoveredPeripherals[indexPath.row]
        cell.nameLbl.text = peripheral.name
        let uuid = String( peripheral.identifier.uuidString)
        cell.uidLbl.text = uuid
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // createIndicator()
        constants.centralManager?.connect(discoveredPeripherals[indexPath.row], options: nil)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConnectionViewController") as! ConnectionViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        constants.AppExitTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
        //            //self.ReStartApp()
        //            self.showToast(message: "Connection Timeout", font: .boldSystemFont(ofSize: 16))
        //            self.stopCustomActivityIndicator(indicator: self.myIndicator!)
        //            
        //        })
        
    }
    
}
extension ViewController{
    func AddRefreshControler(){
        
        
        refreshControl.tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            
            deviceTableView.refreshControl = refreshControl
        } else {
            deviceTableView.addSubview(refreshControl)
            ScanBtn.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshDeviceData(_:)), for: .valueChanged)
        constants.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @objc private func refreshDeviceData(_ sender: Any) {
        
        constants.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.refreshControl.endRefreshing()
    }
    
    
    func GotoPasswordScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func GotoMainVc(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    fileprivate func createIndicator() {
        myIndicator = createCustomActivityIndicator()
        myIndicator?.startAnimating()
    }
}


