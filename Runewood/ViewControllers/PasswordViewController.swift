//
//  PasswordViewController.swift
//  Runewood
//
//  Created by Apple on 23/12/2021.
//

import UIKit
import CoreBluetooth
class PasswordViewController: UIViewController, UITextFieldDelegate,CBPeripheralDelegate  {
    
    
    
    @IBOutlet weak var txtFeild1: UITextField!
    @IBOutlet weak var txtFeild2: UITextField!
    @IBOutlet weak var txtFeild3: UITextField!
    @IBOutlet weak var txtFeild4: UITextField!
    @IBOutlet weak var txtFeild5: UITextField!
    @IBOutlet weak var txtFeild6: UITextField!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnView: RoundCornerView!
    
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var encryptedCode = ""
    var timer         = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetLoader()
        txtFeild1.delegate = self
        txtFeild2.delegate = self
        txtFeild3.delegate = self
        txtFeild4.delegate = self
        txtFeild5.delegate = self
        txtFeild6.delegate = self
        
        btnSubmit.isEnabled = false
        btnView.alpha = 0.5
    }
    override func viewWillAppear(_ animated: Bool) {
        mainView.isHidden = false
        let vcName = String(describing: type(of: self))
        constants.ViewCntrlName = vcName
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        guard let firstDigit = txtFeild1.text else { return }
        guard let secondDigit = txtFeild2.text else { return }
        guard let thirdDigit = txtFeild3.text else { return }
        guard let forthDigit = txtFeild4.text else { return }
        guard let fifthDigit = txtFeild5.text else { return }
        guard let sixthDigit = txtFeild6.text else { return }
        let str = "00"
        let code = str + firstDigit + secondDigit + thirdDigit + forthDigit + fifthDigit + sixthDigit
        
        encryptedCode = encryptPassword(passwod: code)
        constants.Encypassword = encryptedCode
        constants.connectedPeripheral?.discoverServices(nil)
        constants.connectedPeripheral?.delegate = self
        mainView.isHidden = true
        ShowLoader(tile: "Please Wait....")
        
        constants.timerTimeOut = Timer.scheduledTimer(withTimeInterval: 9, repeats: false, block: { _ in
            constants.timerTimeOut.invalidate()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
        
        
    }
}

extension PasswordViewController{
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard peripheral.services != nil else {
            return
        }
        discoverCharacteristics(peripheral: peripheral)
    }
    
    // Call after discovering services
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic in characteristics {
            rxCharacteristic = characteristic
            constants.connectedPeripheral?.setNotifyValue(true, for: rxCharacteristic!)
            let password  = encryptedCode + ";PASS_Verify;"
            let data = password.data(using: .utf8)
            write(value: data!, characteristic: rxCharacteristic)
        }
    }
    
    
    func discoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.discoverDescriptors(for: characteristic)
    }
    
    
    func write(value: Data, characteristic: CBCharacteristic) {
        constants.connectedPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
        
    }
    func reaDValue(characteristic: CBCharacteristic) {
        constants.connectedPeripheral?.readValue(for: characteristic)
    }
    
    func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        constants.connectedPeripheral?.setNotifyValue(false, for: characteristic)
    }
    
    
    // In CBPeripheralDelegate class/extension
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            // Handle error
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            // Handle error
            return
        }
        let strValue = String(decoding: characteristic.value!, as: UTF8.self)
        print(strValue)
        let arry = strValue.split(separator: ";")
        let count = arry.count
        let passStatus = arry[count - 1]
        print(passStatus)
        checkPassword(value: String(passStatus))
        if constants.buttonClick == true{
            checkLightStatus(value: String(passStatus))
        }
        
        
        
        if constants.isGrey == true{
            constants.isGrey = false
        }else{
            constants.isGrey = true
        }
        
        guard characteristic.value != nil else {
            return
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        //peripheral.readValue(for: characteristic)
        //        guard let data = characteristic.value else { return }
        //        characteristic.observationInfo
        if(error != nil){
            print("\nError while writing on Characteristic:\n\(characteristic). Error Message:")
            print(error as Any)
            return
        }
        
    }
    
    func checkPassword(value:String){
        if value == "PassWord_Error"
        {
            mainView.isHidden = true
            ShowLoader(tile: "Please Wait....")
            //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IncorrectPassVC") as! IncorrectPassVC
            self.navigationController?.pushViewController(vc, animated: true)
            //}
        }else if value == "PassWord_Ok"{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if constants.ViewCntrlName == "PasswordViewController"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ButtonsViewController") as! ButtonsViewController
                    vc.characteristic = self.rxCharacteristic
                    self.navigationController?.pushViewController(vc, animated: true)
                    // Do something with data
                }
            }
        }else{
            
        }
    }
    func checkLightStatus(value:String){
        if value == "Light Off"
        {
            constants.LightStatus = "LIGHT OFF"
        }else if value == "Light On" {
            constants.LightStatus = "LIGHT ON"
        }else{
            
        }
        print(constants.LightStatus)
    }
}

extension PasswordViewController{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // On inputing value to textfield
        if ((textField.text?.count)! < 1  && string.count > 0){
            
            if(textField == txtFeild1)
            {
                txtFeild2.becomeFirstResponder()
            }
            if(textField == txtFeild2)
            {
                txtFeild3.becomeFirstResponder()
            }
            if(textField == txtFeild3)
            {
                txtFeild4.becomeFirstResponder()
            }
            if(textField == txtFeild4)
            {
                txtFeild5.becomeFirstResponder()
            }
            if(textField == txtFeild5)
            {
                txtFeild6.becomeFirstResponder()
            }
            if(textField == txtFeild6)
            {
                btnSubmit.isEnabled = true
                btnView.alpha = 1
            }
            
            textField.text = string
            return false
        }
        else if ((textField.text?.count)! >= 1  && string.count == 0){
            
            // on deleting value from Textfield
            if(textField == txtFeild2)
            {
                txtFeild1.becomeFirstResponder()
            }
            if(textField == txtFeild3)
            {
                txtFeild2.becomeFirstResponder()
            }
            if(textField == txtFeild4)
            {
                txtFeild3.becomeFirstResponder()
            }
            if(textField == txtFeild5)
            {
                txtFeild4.becomeFirstResponder()
            }
            if(textField == txtFeild6)
            {
                txtFeild5.becomeFirstResponder()
                btnSubmit.isEnabled = false
                btnView.alpha = 0.5
            }
            textField.text = ""
            return false
        }
        else if ((textField.text?.count)! >= 1  )
        {
            
            textField.text = string
            return false
        }
        return true
    }
}
