//
//  Player.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import AVFoundation

class Player: NSObject {
    
    private static var asset: AVAsset?
    public static var playerItem: AVPlayerItem?
    public static var playerLayer = AVPlayerLayer()
    
//    public static func playItem(with url: URL) {
//        asset = AVAsset(url: url)
//        playerItem = AVPlayerItem(asset: asset!)
//
//        if playerLayer.isReadyForDisplay {
//            player?.replaceCurrentItem(with: playerItem)
//            print("\n\n  Player URL is replaced for Play")
//
//        } else {
//            player = AVPlayer(playerItem: playerItem)
//            print("\n\n  Player URL is added for Play")
//        }
//
//        player?.play()
//        playerIsPlaying = true
//    }
    
    public static func replaceItem(with url: URL) {
        asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset!)
        player?.replaceCurrentItem(with: playerItem)
        print("\n\n  Player URL is replaced for Play")
        player?.play()
        playerIsPlaying = true
    }
    
    public static func addItem(with url: URL) {
        asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem)
        print("\n\n  Player URL is added for Play")
        player?.play()
        playerIsPlaying = true
    }
    
    public static func add(to superView: UIView) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = superView.bounds
        superView.layer.insertSublayer(playerLayer, at: UInt32(Layer.Player.order()))
        print("\n\n  New PlayerLayer was Added to View")
    }
    
    public static func setVideoGravity(to gravity: AVLayerVideoGravity) {
        playerLayer.videoGravity = gravity
    }
}

