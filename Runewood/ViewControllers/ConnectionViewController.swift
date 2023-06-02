//
//  ConnectionViewController.swift
//  Runewood
//
//  Created by Apple on 25/02/2022.
//

import UIKit
import CoreBluetooth

class ConnectionViewController: UIViewController,CBPeripheralDelegate {
    
    var myIndicator: MyIndicator?
    override func viewDidLoad() {
        super.viewDidLoad()
        createIndicator()
        constants.AppExitTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            
            self.stopCustomActivityIndicator(indicator: self.myIndicator!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.timeoutToast = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        })
    }
    
    func GotoPasswordScreen(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc override func buttonAction() {
        //self.showToast(message: "Connection Timeout", font: .boldSystemFont(ofSize: 16))
        self.stopCustomActivityIndicator(indicator: self.myIndicator!)
        
        self.navigationController?.popViewController(animated: true)
    }
    fileprivate func createIndicator() {
        myIndicator = createCustomActivityIndicator()
        myIndicator?.startAnimating()
    }
}
