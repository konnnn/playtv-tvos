//
//  ProgramGuide.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 12.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import Foundation

class ProgramGuide: NSObject {
    
    public static func getTitle(from program: Program) -> String {
        
        var title: String?
        
        if program.programTitle == program.episodeTitle {
            title = "\(program.programTitle!)"
        } else {
            if program.seasonNumber == 0 {
                title = "\(program.programTitle!). \(program.episodeTitle!)"
            } else {
                let seasonNumber: String = "\(program.seasonNumber)"
                title = "\(program.programTitle!). Сезон \(seasonNumber). \(program.episodeTitle!)"
            }
        }
        
        return title!
        
    }
    
    public static func getTimeLeft(from program: Program) -> String {
        
        var time: String?
        let calendar = Calendar.current
        
        guard let start = Calendar.current.date(byAdding: .hour, value: -1, to: Date()), let finish = program.start else {
            return "Далее, недоступно"
        }
        
        let components = calendar.dateComponents([.hour, .minute], from: start, to: finish)
        
        if components.hour == 0 && components.minute == 0 {
            time = "Далее, через несколько секунд"
        } else if components.hour == 0 {
            time = "Далее, через \(components.minute! + 1)мин"
        } else if components.minute == 0 {
            time = "Далее, через \(components.hour!)ч"
        } else {
            time = "Далее, через \(components.hour!)ч \(components.minute! + 1)мин"
        }

        return time!
    }
    
    public static func getProgressTime(from program: Program) -> Float {
        
        var progress: Float = 0.0
        let calendar = Calendar.current
        
        guard let currentTime = Calendar.current.date(byAdding: .hour, value: -1, to: Date()), let startTime = program.start, let finishTime = program.finish else {
            return progress
        }
        
        let passedTime = calendar.dateComponents([.second], from: startTime, to: currentTime)
        let fullTime = calendar.dateComponents([.second], from: startTime, to: finishTime)
        progress = Float(passedTime.second!) / Float(fullTime.second!)
        
        return progress
    }
    
}
