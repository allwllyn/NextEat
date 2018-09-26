//
//  UIViewExt.swift
//  NextEat
//
//  Created by Andrew Llewellyn on 9/19/18.
//  Copyright © 2018 Andrew Llewellyn. All rights reserved.
//

import Foundation
import UIKit

// This animation function was adapted from this stackoverflow.com post: https://stackoverflow.com/questions/28964346/swift-continuous-rotation-animation-not-so-continuous
// animation artwork is original content

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 5) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * -2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
