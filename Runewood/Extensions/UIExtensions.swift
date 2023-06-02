//
//  UIExtensions.swift
//  Runewood
//
//  Created by Apple on 27/12/2021.
//
import CoreBluetooth
import Foundation
import SwiftLoader
import UIKit
extension UIViewController{
    func SetLoader(){
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = #colorLiteral(red: 0.5921569467, green: 0.5921569467, blue: 0.5921569467, alpha: 1)
        config.foregroundColor = UIColor.clear
        config.backgroundColor = UIColor.clear
        config.foregroundAlpha = 0
        config.spinnerLineWidth = 5
        config.titleTextColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        SwiftLoader.setConfig(config: config)
    }
    
    func SetMainLoader(){
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        config.foregroundColor = UIColor.clear
        config.backgroundColor = UIColor.clear
        config.foregroundAlpha = 0
        config.spinnerLineWidth = 5
        config.titleTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        SwiftLoader.setConfig(config: config)
    }
    
    
    func ShowLoader(tile:String){
        SwiftLoader.show(title: tile, animated: true)
    }
    func hideLoader(){
        SwiftLoader.hide()
    }
    
    func encryptPassword(passwod:String) -> String{
        
        var encryptedStrinig = ""
        var ind = 0
        for value in passwod {
            let b = Character(String(value)).asciiValue!
            let encryptedAscii = b - 46
            encryptedStrinig = encryptedStrinig + String(encryptedAscii)
            if ind < passwod.count - 1 {
                encryptedStrinig = encryptedStrinig + ","
            }
            ind += 1
        }
        return encryptedStrinig
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 220, height: 50))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
struct CBUUIDs{
    
    static let kBLEService_UUID = UUID().uuidString
    static let kBLE_Characteristic_uuid_Tx = UUID().uuidString
    static let kBLE_Characteristic_uuid_Rx = UUID().uuidString
    
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)
}
extension UIViewController{
    func createCustomActivityIndicator() -> MyIndicator {
        let grayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0)
        grayView.tag = 100
        view.addSubview(grayView)
        
        let ind = MyIndicator(frame: CGRect(x: self.view.frame.size.width / 2 - 50, y: self.view.frame.size.height / 2 - 50, width: 70, height: 70), image: UIImage(named: "next")!)
        ind.tintColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        let label = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - 60, y: self.view.frame.size.height / 2 + 40, width: 160, height: 50))
        label.text = "Connecting device...."
        label.textColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        label.font = label.font.withSize(16)
        
        
        
        let button = UIButton(frame: CGRect(x: self.view.frame.size.width / 2 - 40,
                                            y: self.view.frame.size.height / 2 + 100,
                                            width: 100,
                                            height: 40))
        button.layer.cornerRadius = 4
        button.setTitle("Cancel",
                        for: .normal)
        button.setTitleColor(.white,for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self,
                         action: #selector(buttonAction),
                         for: .touchUpInside)
        
        button.tag = 200
        label.tag = 300
        view.addSubview(ind)
        view.addSubview(label)
        self.view.addSubview(button)
        view.bringSubviewToFront(button)
        //ind.startAnimating()
        
        return ind
    }
    @objc func buttonAction() {
        print("Button pressed")
    }
    func stopCustomActivityIndicator(indicator: MyIndicator) {
        indicator.stopAnimating()
        
        let mySubviews = self.view.subviews
        
        for subview in mySubviews {
            if let graySubview = subview.viewWithTag(100) ??  subview.viewWithTag(200) ??  subview.viewWithTag(300) {
                graySubview.removeFromSuperview()
            }
        }
    }
}
