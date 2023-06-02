//
//  AppDelegate.swift
//  Runewood
//
//  Created by Apple on 15/12/2021.
//

import UIKit
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1)
        IQKeyboardManager.shared.enable = true
        return true
    }

   


}

