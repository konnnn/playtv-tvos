//
//  Spinner.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 21.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

open class Spinner {
    
    private static var spinner: UIActivityIndicatorView?
    
    public static func show(at superView: UIView) {
        if spinner == nil {
            spinner = UIActivityIndicatorView(frame: superView.bounds)
            spinner?.style = .whiteLarge
            spinner?.color = .white
            spinner?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            superView.addSubview(spinner!)
            spinner?.startAnimating()
        }
    }
    
    public static func hide() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }
    
}
