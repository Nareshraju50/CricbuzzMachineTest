//
//  UIView+Ext.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
        func addPulsationAnimation() {
            /// transparency animation
            /// you can pick any values you like
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1.5
            pulseAnimation.fromValue = 0.7
            pulseAnimation.toValue = 1
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .greatestFiniteMagnitude
            self.layer.add(pulseAnimation, forKey: nil)
            
            /// transform scale animation
            /// you can pick any values you like
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 1.5
            scaleAnimation.fromValue = 0.95
            scaleAnimation.toValue = 1
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            scaleAnimation.autoreverses = true
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            self.layer.add(scaleAnimation, forKey: nil)
    }
}
