//
//  MainViewController.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import AVFoundation
import GameController
import RealmSwift

class MainViewController: GCEventViewController {
    
    let realm = try! Realm()
    var currentChannel: Results<CurrentChannel>?
    
    // Каналы новостей http://iptvsensei.ru/kanalyi-novostey
    
    // Россия 24 http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/507/index.m3u8
    // СТС http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/506/index.m3u8
    // Пятница http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/503/index.m3u8
    // ТНТ http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/502/index.m3u8
    // TV 1000 http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/132/index.m3u8
    // TV 1000 Action http://24121978.iptvbot.net/iptv/VSMYUYTV6UWLB3/131/index.m3u8
    
    // BBC News http://ott-cdn.ucom.am/s24/04.m3u8
    // News https://abc-iview-mediapackagestreams-1.akamaized.net/out/v1/50345bf35f664739912f0b255c172ae9/index_1.m3u8
    // ABC News http://abclive2-lh.akamaihd.net/i/abc_live11@423404/index_4000_av-p.m3u8
    // RT http://rt-news.secure.footprint.net/1103-inadv-qidx-1k_v5.m3u8
    var urlString = "http://rt-news.secure.footprint.net/1103-inadv-qidx-1k_v5.m3u8"
    
    // MARK: - Views Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPlayer()
        setUpClock()
        
    }
    
    // MARK: - Press Events
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        controllerUserInteractionEnabled = true
        
        for press in presses {
            
            switch press.type {
                
            case .select:
                print("\nSelect")
                
                self.view.backgroundColor = .black
                
                Player.playItem(with: URL(string: urlString)!)
                let playerSublayer = view.layer.sublayers?.filter({ $0 is AVPlayerLayer }).count
                
                if playerSublayer == 0 {
                    Player.add(to: self.view)
                    print("\n\n  New Player was added")
                }
                Player.setVideoGravity(to: .resizeAspect)
                
                player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
                player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
                player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
                Spinner.show(at: self.view)
                
            case .playPause:
                playerIsPlaying == true ? player?.pause() : player?.play()
                playerIsPlaying = !playerIsPlaying
                
            case .menu:
                controllerUserInteractionEnabled = false
                let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                menuVC.setPopupPresentation()
                self.present(menuVC, animated: true, completion: nil)
                
            default:
                super.pressesBegan(presses, with: event)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\nTouches began")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\nTouches moved")
    }
    
    // MARK: - Observe Events
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object is AVPlayerItem {
            
            switch keyPath {
            case "playbackBufferEmpty":
                print("\nShow spinner Empty")
                Spinner.show(at: self.view)
            case "playbackLikelyToKeepUp":
                print("\nHide spinner KeepUp")
                Spinner.hide()
            case "playbackBufferFull":
                print("\nHide spinner Full")
            default:
                break
            }
            
        }
    }
    
    // MARK: - Custom Methods
    
    func setUpPlayer() {
        currentChannel = realm.objects(CurrentChannel.self)
        
        if currentChannel!.count > 0, let channel = currentChannel?[0] {
            
            
            
        } else {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
            
            print("\nCurrent Channel is Empty")
        }
    }
    
    func setUpClock() {
        Clock.run()
        self.view.insertSubview(Clock.label, at: LayerOrder.clock.rawValue)
        Clock.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        Clock.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
    }
    
    
    
    
}

