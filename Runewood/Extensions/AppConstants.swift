//
//  AppConstants.swift
//  Runewood
//
//  Created by Apple on 27/12/2021.
//

import Foundation
import SwiftLoader
import CoreBluetooth
class constants{
    
   static var connectedPeripheral: CBPeripheral?
    static var centralManager: CBCentralManager?
    static var Encypassword = ""
    static var ViewCntrlName = ""
    static var LightStatus = ""
    static var disconnecttimer = Timer()
    static var AppExitTimer    = Timer()
    static var timerTimeOut    = Timer()
    static var isGrey = true
    static var buttonClick = true
    
}
