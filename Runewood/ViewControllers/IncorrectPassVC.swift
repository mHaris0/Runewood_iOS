//
//  IncorrectPassVC.swift
//  Runewood
//
//  Created by Apple on 31/01/2022.
//

import UIKit

class IncorrectPassVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constants.timerTimeOut.invalidate()
        hideLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popToViewController(ofClass: WelcomeViewController.self, animated: true)
        }
    }
    
    
}
extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
