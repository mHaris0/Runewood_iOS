//
//  WelcomeViewController.swift
//  Runewood
//
//  Created by Apple on 29/12/2021.
//

import UIKit

class WelcomeViewController: UIViewController,Reconnectdelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLoader()
        constants.AppExitTimer.invalidate()
        constants.disconnecttimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { _ in
            if constants.connectedPeripheral?.state.rawValue == 0{
                constants.disconnecttimer.invalidate()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                vc.DisconnectedshowToas = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
            }
            
        })
        
        
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func reConnectBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReConnectVC") as! ReConnectVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func Reconnect() {
        constants.centralManager?.cancelPeripheralConnection(constants.connectedPeripheral!)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
