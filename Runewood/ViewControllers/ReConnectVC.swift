//
//  ReConnectVC.swift
//  Runewood
//
//  Created by Apple on 31/01/2022.
//

import UIKit


protocol Reconnectdelegate: class {
    func Reconnect()
}

class ReConnectVC: UIViewController {
    var delegate:Reconnectdelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func yesBtnAction(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate!.Reconnect()
        }
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
