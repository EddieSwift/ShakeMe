//
//  UIView+ShakeAnimation.swift
//  ShakeMe
//
//  Created by Eduard Galchenko on 10/20/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

import UIKit

extension UIView {

    func shakeAnimation(_ enabled: Bool) {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map { ( degrees: Double) -> Double in
            let radians: Double = (.pi * degrees) / 180.0
            return radians
        }

        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations  = [translation, rotation]
        shakeGroup.repeatCount = enabled ? 30 : 1
        shakeGroup.duration    = enabled ? 5.0 : 0.1
        shakeGroup.speed       = enabled ? 3.5 : 0.1
        self.layer.add(shakeGroup, forKey: "shakeIt")
    }
}
