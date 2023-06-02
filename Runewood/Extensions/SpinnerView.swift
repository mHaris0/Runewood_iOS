//
//  SpinnerView.swift
//  Runewood
//
//  Created by Apple on 23/02/2022.
//

import Foundation
import UIKit
class SpinnerView: UIView {
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        //            layer.strokeColor = UIColor(named: "#FFD83E")?.cgColor
        layer.strokeColor = #colorLiteral(red: 0.6196078431, green: 0.231372549, blue: 0.2392156863, alpha: 1)
        layer.lineWidth = 5
        setPath()
    }
    
    override func didMoveToWindow() {
        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init( secondsSincePriorPose: CFTimeInterval,  start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(secondsSincePriorPose: 0.0, start: 0.000, 0.7),
                Pose(secondsSincePriorPose: 0.6, start: 0.500, 0.5),
                Pose(secondsSincePriorPose: 0.6, start: 1.000, 0.3),
                Pose(secondsSincePriorPose: 0.6, start: 1.500, 0.1),
                Pose(secondsSincePriorPose: 0.2, start: 1.875, 0.1),
                Pose(secondsSincePriorPose: 0.2, start: 2.250, 0.3),
                Pose(secondsSincePriorPose: 0.2, start: 2.625, 0.5),
                Pose(secondsSincePriorPose: 0.2, start: 3.000, 0.7),
            ]
        }
    }
    
    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2  * .pi)
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        /*
         animation.values = (0 ... count).map {
         //UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
         UIColor(hexString: "#FFD83E").cgColor
         }
         */
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}
class MyIndicator: UIView {
    
    let imageView = UIImageView()
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        /*
         imageView.frame = bounds
         imageView.image = image
         imageView.contentMode = .scaleAspectFit
         imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         addSubview(imageView)
         */
        print(frame)
        //            let spinningView = SpinnerView(frame: bounds)
        let spinningView = SpinnerView(frame: CGRect(x: 0, y: 0, width: 100.0, height: 100.0))
        addSubview(spinningView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    func startAnimating() {
        isHidden = false
        //rotate()
    }
    
    func stopAnimating() {
        isHidden = true 
        removeRotation()
    }
    
    private func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.imageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func removeRotation() {
        self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
}
