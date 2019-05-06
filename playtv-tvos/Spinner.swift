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
    
    public static func show(in view: UIView,
                            title: String = "Подключение",
                            cornerRadius: CGFloat = 0,
                            backgroundAlpha: CGFloat = 0.4,
                            isUserInteractionEnabled: Bool = true) {
        if spinner == nil {
            spinner = UIActivityIndicatorView(frame: view.bounds)
            spinner?.style = .whiteLarge
            spinner?.color = .white
            spinner?.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
            view.insertSubview(spinner!, at: Layer.Spinner.order())
            spinner?.startAnimating()
            spinner?.hidesWhenStopped = true
            spinner?.layer.cornerRadius = cornerRadius
            view.isUserInteractionEnabled = isUserInteractionEnabled
            
            let label: UILabel = {
                let label = UILabel()
                label.text = title.uppercased()
                label.textColor = .white
                label.textAlignment = .center
                label.numberOfLines = 0
                label.font = UIFont.sansNarrowBold(size: 28)
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            spinner?.addSubview(label)
            label.centerXAnchor.constraint(equalTo: (spinner?.centerXAnchor)!).isActive = true
            label.centerYAnchor.constraint(equalTo: (spinner?.centerYAnchor)!, constant: 70).isActive = true
            label.widthAnchor.constraint(equalToConstant: 250).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    public static func hide(from view: UIView, isUserInteractionEnabled: Bool = true) {
        spinner?.stopAnimating()
        view.isUserInteractionEnabled = isUserInteractionEnabled
        spinner = nil
        spinner?.removeFromSuperview()
    }
    
}
