//
//  ButtonsViewController.swift
//  Runewood
//
//  Created by Apple on 27/12/2021.
//

import UIKit
import CoreBluetooth
class ButtonsViewController: UIViewController {
    
    @IBOutlet weak var lightBtn: UIButton!
    
    @IBOutlet weak var dotView: UIView!
    var characteristic: CBCharacteristic?
    var timer       = Timer()
    var timer2       = Timer()
    var btntimer       = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLoader()
        constants.timerTimeOut.invalidate()
        dotView.layer.cornerRadius = 6
        let vcName = String(describing: type(of: self))
        constants.ViewCntrlName = vcName
        if constants.LightStatus == "LIGHT OFF"{
            lightBtn.setTitle("LIGHT ON", for: .normal)
        }else{
            lightBtn.setTitle("LIGHT OFF", for: .normal)
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            if constants.buttonClick == true{
                self.lodadata()
            }
            
        })
        
        self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.setdot()
        })
        
    }
    
    func lodadata(){
        if constants.LightStatus == "LIGHT OFF"{
            //            if lightBtn.titleLabel?.text == constants.LightStatus{
            //
            //            }
            //            else{
            //
            //            }
            lightBtn.setTitle("LIGHT ON", for: .normal)
        }else{
            lightBtn.setTitle("LIGHT OFF", for: .normal)
        }
    }
    
    @IBAction func openDoorBtn(_ sender: Any) {
        let password  = constants.Encypassword + ";Door_Open"
        let data = password.data(using: .utf8)!
        write(value: data, characteristic: characteristic!)
    }
    
    @IBAction func lightOnBtn(_ sender: Any) {
        var LightCommand = ""
        if lightBtn.titleLabel?.text == "LIGHT ON"{
            lightBtn.setTitle("LIGHT OFF", for: .normal)
            LightCommand = ";Light_On"
        }else{
            lightBtn.setTitle("LIGHT ON", for: .normal)
            LightCommand = ";Light_Off"
        }
        
        let password  = constants.Encypassword + LightCommand
        let data = password.data(using: .utf8)!
        write(value: data, characteristic: characteristic!)
        constants.buttonClick = false
        self.btntimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
            constants.buttonClick = true
        })
        
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        constants.centralManager?.cancelPeripheralConnection(constants.connectedPeripheral!)
        
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        //Comment if you want to minimise app
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            exit(0)
        }
        
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func write(value: Data, characteristic: CBCharacteristic) {
        constants.connectedPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
    }
    
    func setdot(){
        if constants.isGrey == true{
            dotView.backgroundColor = UIColor(hexString: "#707070")
        }else{
            dotView.backgroundColor = UIColor(hexString: "#912627")
        }
        
    }
    
    
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
