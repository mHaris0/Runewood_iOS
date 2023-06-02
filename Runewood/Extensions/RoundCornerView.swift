//
//  RoundCornerView.swift
//  Runewood
//
//  Created by Apple on 23/12/2021.
//

import UIKit
class RoundCornerView: UIView {
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    
    
    /* BORDER */
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    /* BORDER RADIUS */
    //        @IBInspectable var cornerRadius:CGFloat {
    //            set {
    //                layer.cornerRadius = newValue
    //                clipsToBounds = newValue > 0
    //            }
    //            get {
    //                return layer.cornerRadius
    //            }
    //        }
    
    
    
    var cornerRadius: CACornerMask!
    
    @IBInspectable var topRight: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var topLeft: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomRight: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomLeft: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        cornerRadius = []
        
        if topRight {
            cornerRadius.insert(.layerMaxXMinYCorner)
        } else {
            cornerRadius.remove(.layerMaxXMinYCorner)
        }
        
        if topLeft {
            cornerRadius.insert(.layerMinXMinYCorner)
        } else {
            cornerRadius.remove(.layerMinXMinYCorner)
        }
        
        if bottomRight {
            cornerRadius.insert(.layerMaxXMaxYCorner)
        } else {
            cornerRadius.remove(.layerMaxXMaxYCorner)
        }
        
        if bottomLeft {
            cornerRadius.insert(.layerMinXMaxYCorner)
        } else {
            cornerRadius.remove(.layerMinXMaxYCorner)
        }
        
        layer.maskedCorners = cornerRadius
        layer.cornerRadius = radius
    }
    
}
