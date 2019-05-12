//
//  DispatchQueue+Background.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 07.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    /// Background Thread. The method runs in the background with delay and then runs main thread
    ///
    /// - Parameters:
    ///   - delay: Время задержки выполнения метода
    ///   - background: background description
    ///   - completion: completion description
    static func background(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

/// Background Thread. The method runs in the background.
///
/// - Parameter work: Do something in background thread
func background(task: @escaping() -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
        task()
    }
}

/// Main Thread. The method runs in the main thread (Update UI or what you need to do in main thread).
///
/// - Parameter work: Do something in main thread
func main(task: @escaping() -> ()) {
    DispatchQueue.main.async {
        task()
    }
}
