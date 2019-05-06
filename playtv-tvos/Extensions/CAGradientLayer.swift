//
//  CAGradientLayer.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 20.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

extension UIViewController {
    func addGradientToViewController() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: UInt32(Layer.Gradient.order()))
        gradientLayer.locations = [0.0, 0.4, 1.0]
        gradientLayer.colors = [
            UIColor(hexString: "#1C1D27", alpha: 1).cgColor,
            UIColor(hexString: "#1C1D27", alpha: 0.45).cgColor,
            UIColor(hexString: "#1C1D27", alpha: 1).cgColor
        ]
    }
    
    func removeGradientFromViewController() {
        let gradientLayers = view.layer.sublayers?.filter({ $0 is CAGradientLayer }) as! [CAGradientLayer]
        for layer in gradientLayers {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                layer.colors = [
                    UIColor(hexString: "#1C1D27", alpha: 0).cgColor,
                    UIColor(hexString: "#1C1D27", alpha: 0).cgColor,
                    UIColor(hexString: "#1C1D27", alpha: 0).cgColor
                ]
            }) { (completion) in
                layer.removeFromSuperlayer()
            }
        }
    }
}
