//
//  CAGradientLayer.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 20.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

extension UIViewController {
    func addGradient(to superView: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = superView.bounds
        gradientLayer.colors = [
            UIColor(hexString: "#1C1D27", alpha: 1).cgColor,
            UIColor(hexString: "#1C1D27", alpha: 0.45).cgColor,
            UIColor(hexString: "#1C1D27", alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.4, 1.0]
        superView.layer.insertSublayer(gradientLayer, at: UInt32(LayerOrder.gradient.rawValue))
    }
}
