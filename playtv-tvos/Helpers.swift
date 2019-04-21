//
//  Helpers.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation
import AVFoundation

var playerIsPlaying: Bool = false
var player: AVPlayer?
let user = UserDefaults.standard

enum LayerOrder: Int {
    case player = 0
    case spinner = 888
    case clock = 999
}

