//
//  MenuViewController.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 20.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import AVFoundation
import GameController
import RealmSwift

protocol MenuViewDelegate: class {
    func channelSelectionPressed(currentChannel: CurrentChannel)
}

class MenuViewController: GCEventViewController {
    
    var delegate: MenuViewDelegate?
    
    var urlString = "http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/507/index.m3u8"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradient(to: self.view)
    }

    func setPopupPresentation() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        controllerUserInteractionEnabled = true
        
        for press in presses {
            
            switch press.type {
                
            case .select:
                print("\n\n  Menu Select")
                
                let channel = CurrentChannel()
                channel.id = 0
                channel.index = 0
                channel.name = "Name"
                channel.logoName = "Logo Name"
                channel.url = urlString
                
                delegate?.channelSelectionPressed(currentChannel: channel)
                
            case .playPause:
                playerIsPlaying == true ? player?.pause() : player?.play()
                playerIsPlaying = !playerIsPlaying
                
            case .menu:
                controllerUserInteractionEnabled = false
                self.dismiss(animated: true, completion: nil)
                
            default:
                super.pressesBegan(presses, with: event)
            }
        }
    }
    
    
    
    
    
}
