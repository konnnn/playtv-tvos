//
//  Clock.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 21.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

class Clock: NSObject {
    
    private static var clockTimer: Timer?

    private static var label: UILabel = {
        let label = PaddingLabel(withInsets: 5, 6, 20, 20)
        label.text = "Часы".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.sansNarrowBold(size: 28)
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = .zero
        label.layer.shadowRadius = 12
        label.layer.backgroundColor = UIColor.black.withAlphaComponent(0.24).cgColor
        label.layer.cornerRadius = 24
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public static func run(in view: UIView) {
        setDateFormatter()
        
        if clockTimer == nil {
            clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                setDateFormatter()
            })
        }
        
        view.insertSubview(label, at: LayerOrder.clock.rawValue)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    }
    
    public static func stop() {
        
        if clockTimer != nil {
            clockTimer?.invalidate()
            clockTimer = nil
        }
        
        label.removeFromSuperview()
    }
    
    private static func setDateFormatter() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy • EEE • HH:mm"
        label.text = formatter.string(from: date).uppercased()
    }
    

}
