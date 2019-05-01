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

protocol MenuViewControllerDelegate: class {
    func channelSelectionPressed(currentChannel: CurrentChannel)
}

class MenuViewController: GCEventViewController {
    
    var delegate: MenuViewControllerDelegate?
    
    var collectionView: UICollectionView!
    var cellIdentifier = "Cell"
    var bottomAnchor: NSLayoutConstraint?
    
    let realm = try! Realm()
    var channelsResults: Results<Channel>?
    var selectedPlaylist: Playlist?
    var currentChannel: CurrentChannel?
    
    // MARK: - Model Manipulation Methods
    
    func loadChannels() {
        
        if let playlistByDate = user.object(forKey: "playlist") as? Date {
            selectedPlaylist = realm.objects(Playlist.self).filter("date = '\(playlistByDate)'").first

        } else {
            let playlistByDate: Results<Playlist> = realm.objects(Playlist.self).sorted(byKeyPath: "dateAdded", ascending: true)
            selectedPlaylist = playlistByDate.first
        }
        
        channelsResults = selectedPlaylist?.channels.sorted(byKeyPath: "index", ascending: true)
        currentChannel = realm.objects(CurrentChannel.self).first
    }
    
    // MARK: - Views Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradient(to: self.view)
        loadChannels()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Scroll to Current Channel Cell
        if self.currentChannel != nil {
            let indexPath: IndexPath = IndexPath(item: (self.currentChannel?.index)! - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
        }
        animateView()
    }
    
    // MARK: - Custom Methods
    
    func animateView() {
        bottomAnchor?.isActive = false
        bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -54)
        bottomAnchor?.isActive = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.collectionView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setPopupPresentation() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    func setUpCollectionView() {
        cellIdentifier = "Cell"
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 500, height: 80)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.remembersLastFocusedIndexPath = true
        
        collectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        
        self.view.insertSubview(collectionView, at: LayerOrder.channelsCollectionView.rawValue)
        
        bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80)
        bottomAnchor?.isActive = true
        
//        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func pressCell(gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? ChannelCell else { return }
        
        let channel = CurrentChannel()
        channel.index = cell.channel?.index ?? 0
        channel.yaid = cell.channel?.yaid ?? 0
        channel.name = cell.channel?.name
        channel.genre = cell.channel?.genre
        channel.genreID = cell.channel?.genreID ?? 0
        channel.url = cell.channel?.url
        
        do {
            if currentChannel != nil {
                // обновляем объект в бд
                try realm.write {
                    currentChannel!.index = channel.index
                    currentChannel!.yaid = channel.yaid
                    currentChannel!.name = channel.name
                    currentChannel!.genre = channel.genre
                    currentChannel!.genreID = channel.genreID
                    currentChannel!.url = channel.url
                }
            } else {
                // добавляем в бд
                try realm.write {
                    realm.add(channel)
                }
            }
            
        } catch {
            print("\n\n  Error to play selected channel: \(error)")
        }
        
        delegate?.channelSelectionPressed(currentChannel: channel)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Collection View Focus Environment
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        var index: Int = 0
        if currentChannel != nil {
            index = (currentChannel?.index)! - 1
        }
        return IndexPath(item: index, section: 0)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        for press in presses {
            switch press.type {
           
            case .playPause:
                playerIsPlaying == true ? player?.pause() : player?.play()
                playerIsPlaying = !playerIsPlaying
            
            case .menu:
                bottomAnchor?.isActive = false
                bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80)
                bottomAnchor?.isActive = true
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.collectionView.alpha = 1
                }) { (completion) in
                    self.dismiss(animated: true, completion: nil)
                }
           
            default:
                super.pressesBegan(presses, with: event)
            }
        }
    }
    
}

// MARK: - CollectionView DataSource and Delegate Methods

extension MenuViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelsResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChannelCell
        
        cell.channel = channelsResults![indexPath.item]

        if cell.gestureRecognizers?.count == nil {
            let press = UITapGestureRecognizer(target: self, action: #selector(pressCell(gesture:)))
            press.allowedPressTypes = [NSNumber(integerLiteral: UIPress.PressType.select.rawValue)]
            cell.addGestureRecognizer(press)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 500, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
