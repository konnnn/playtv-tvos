//
//  Helpers.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
//import Foundation
import AVFoundation

var playerIsPlaying: Bool = false
var player: AVPlayer?
let user = UserDefaults.standard

enum LayerOrder: Int {
    case player = 0
    case gradient = 1
    case downloaderBox = 255
    case channelsCollectionView = 199
    case headerView = 230
    case spinner = 800
    case clock = 999
}

class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
