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
    var currentChannel: CurrentChannel?
    var playlist = Playlist()
    
    // MARK: - Views Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundImage()
        Clock.run(in: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Проверяем наличие плейлиста
        if playlist.isThereAnyPlaylists {
            
            // Проверяем текущий канал
            print("\n\n  Проверяем текущий канал")
            setUpPlayer()
            
        } else {
            
            // Выводим контролер загрузки плейлиста
            print("\n\n  Выводим контролер загрузки плейлиста")
            presentLoaderViewController()
        }
    }
    
    // MARK: - Press Events
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for press in presses {
            
            switch press.type {
                
            case .select:
                print("\n\n  Main Select")
                print("\n\n  Nothing to do")
                
            case .playPause:
                playerIsPlaying == true ? player?.pause() : player?.play()
                playerIsPlaying = !playerIsPlaying
                
            case .menu:
                
                print(playlist.isThereAnyPlaylists)
                
                if playlist.isThereAnyPlaylists {
                    presentMenuViewController()
                } else {
                    presentLoaderViewController()
                }
                
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
                Spinner.show(in: self.view)
            case "playbackLikelyToKeepUp":
                print("\nHide spinner KeepUp")
                Spinner.hide(from: self.view)
            case "playbackBufferFull":
                print("\nHide spinner Full")
            default:
                break
            }
            
        }
    }
    
    // MARK: - Custom Methods
    
    func presentMenuViewController() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu.setPopupPresentation()
        menu.delegate = self as MenuViewControllerDelegate
        self.present(menu, animated: true, completion: nil)
    }
    
    func presentLoaderViewController() {
        let loader = self.storyboard?.instantiateViewController(withIdentifier: "LoaderViewController") as! LoaderViewController
        loader.setPopupPresentation()
        self.present(loader, animated: true, completion: nil)
    }
    
    func setUpPlayer() {
        currentChannel = realm.objects(CurrentChannel.self).first
        
        if let url = currentChannel?.url {
            channelSelectionPressed(channelURL: url)
            print("\n\n  Current Channel: \((currentChannel?.name)!)")
            
        } else {
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
            presentMenuViewController()
            
            print("\n\n Current Channel is Empty")
        }
    }
    
}

// MARK: - Menu Delegate Methods

extension MainViewController: MenuViewControllerDelegate {
    
    func channelSelectionPressed(channelURL: String) {
       
        print("\n\n Main Delegate is ON")
        
        self.view.backgroundColor = .black
        
        if let url = URL(string: channelURL) {
            
            let playerSublayer = self.view.layer.sublayers?.filter({ $0 is AVPlayerLayer }).count
            if playerSublayer == 0 {
                Player.addItem(with: url)
                Player.add(to: self.view)
            } else {
                Player.replaceItem(with: url)
            }
            
            Player.setVideoGravity(to: .resizeAspect)
            
            player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            
            Spinner.show(in: self.view)
        }
    }
    
}

