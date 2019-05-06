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

enum UserDefaultsKeys: String {
    case PlaylistsURLs
    case CurrentPlaylist
    
    func key() -> String {
        return self.rawValue
    }
}

enum Layer: Int {
    case Player = 0
    case Gradient = 1
    case DownloaderBox = 255
    case ChannelsCollectionView = 199
    case HeaderView = 230
    case Spinner = 800
    case Clock = 999
    
    func order() -> Int {
        return self.rawValue
    }
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
