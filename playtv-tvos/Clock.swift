//
//  Clock.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 21.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

class Clock: NSObject {
    
    private static var clockTimer = Timer()

    public static var label: UILabel = {
        let label = PaddingLabel(withInsets: 8, 8, 18, 18)
        label.text = "Time".uppercased()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.sansNarrowBold(size: 26)
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.3
        label.layer.shadowOffset = .zero
        label.layer.shadowRadius = 12
        label.layer.backgroundColor = UIColor.black.withAlphaComponent(0.14).cgColor
        label.layer.cornerRadius = 24
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    public static func run() {
        setDateFormatter()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            setDateFormatter()
        })
    }
    
    public static func stop() {
        clockTimer.invalidate()
    }
    
    private static func setDateFormatter() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM yyyy • EEE • HH:mm"
        label.text = formatter.string(from: date).uppercased()
    }
    

}
