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
    var topAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    let realm = try! Realm()
    var channelsResults: Results<Channel>?
    var selectedPlaylist: Playlist?
    var currentChannel: CurrentChannel?
    
    // MARK: - Set Views, Labels and etc Programmatically
    
    let topArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        let playtvString = "playtv/".uppercased()
        let playAttr = [NSAttributedString.Key.font: UIFont.sansNarrowBold(size: 58), NSAttributedString.Key.foregroundColor: UIColor.white]
        let tvAttr = [NSAttributedString.Key.font: UIFont.sansNarrowRegular(size: 58), NSAttributedString.Key.foregroundColor: UIColor.white]
        let slashAttr = [NSAttributedString.Key.font: UIFont.sansNarrowRegular(size: 58), NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3FDE10")]
        let playtvAttributed = NSMutableAttributedString(string: playtvString, attributes: playAttr)
        playtvAttributed.setAttributes(tvAttr, range: NSRange(location: 4, length: 3))
        playtvAttributed.setAttributes(slashAttr, range: NSRange(location: 6, length: 1))
        label.attributedText = playtvAttributed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playlistLabel: UILabel = {
        let label = UILabel()
        label.text = "Плейлист".uppercased()
        label.textColor = UIColor(hexString: "#888994")
        label.font = UIFont.sansNarrowBold(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ИМЯ".uppercased()
        label.textColor = .white
        label.font = UIFont.sansNarrowRegular(size: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let channelLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .right
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let channelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Канал"
        label.textColor = .white
        label.font = UIFont.sansNarrowBold(size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Model Manipulation Methods
    
    func loadChannels() {
        
        // выбираем текущий плейлист из настроек пользователя
        if let playlistID: String = user.object(forKey: UserDefaultsKeys.CurrentPlaylist.key()) as? String {
            selectedPlaylist = realm.objects(Playlist.self).filter("id == '\(playlistID)'").first
            print("\n\n Был выбран плейлист из настроек пользователя")
            print("\n\n ID текущего плейлиста: \(playlistID)")

        } else {
            // если нет выбранного плейлиста, то берём последний добавленный в бд
            let playlist: Results<Playlist> = realm.objects(Playlist.self).sorted(byKeyPath: "id", ascending: true)
            selectedPlaylist = playlist.first
            user.set("\(selectedPlaylist!.id!)", forKey: UserDefaultsKeys.CurrentPlaylist.key())
            user.synchronize()
            print("\n\n Плейлист добавлен в настройки пользователя")
        }
        
        channelsResults = selectedPlaylist?.channels.sorted(byKeyPath: "index", ascending: true)
        currentChannel = realm.objects(CurrentChannel.self).first
    }
    
    // MARK: - Views Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChannels()
        setUpCollectionView()
        setUpTopArea()
        
        // Scroll to Current Channel Cell
        if self.currentChannel != nil {
            let indexPath: IndexPath = IndexPath(item: (self.currentChannel?.index)! - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addGradientToViewController()
        showInterfaceAnimation()
    }
    
    // MARK: - Get Channel Logo
    
    func getCurrentChannelLogo(with name: String) -> UIImage {
        guard let image = UIImage(named: "\(name)*68")?.resizeImage(to: CGSize(width: 400, height: 60)) else {
            return UIImage()
        }
        return image
    }
    
    // MARK: - Animations
    
    func showInterfaceAnimation() {
        topAnchor?.isActive = false
        bottomAnchor?.isActive = false
        topAnchor = topArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80)
        bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -54)
        topAnchor?.isActive = true
        bottomAnchor?.isActive = true
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.topArea.alpha = 1
            self.collectionView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (completion) in
            
        }
    }
    
    func dismissViewControllerAnimation() {
        topAnchor?.isActive = false
        bottomAnchor?.isActive = false
        topAnchor = topArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -topArea.bounds.height)
        bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.frame.height)
        topAnchor?.isActive = true
        bottomAnchor?.isActive = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.topArea.alpha = 0
            self.collectionView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setPopupPresentation() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    // MARK: - Set up Views
    
    func setUpCollectionView() {
        cellIdentifier = "Cell"
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 500, height: 80)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 80), collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.remembersLastFocusedIndexPath = true
        
        collectionView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        self.view.insertSubview(collectionView, at: Layer.ChannelsCollectionView.order())
        
        bottomAnchor?.isActive = false
        bottomAnchor = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.view.frame.height)
        bottomAnchor?.isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setUpTopArea() {
        playlistNameLabel.text = selectedPlaylist?.title?.uppercased()
        channelNameLabel.text = currentChannel?.name
        
        self.view.insertSubview(topArea, at: Layer.HeaderView.order())
        topArea.addSubview(logoLabel)
        topArea.addSubview(playlistLabel)
        topArea.addSubview(playlistNameLabel)
        topArea.addSubview(channelLogoImage)
        topArea.addSubview(channelNameLabel)
        topArea.alpha = 0
        
        // add constraits
        topArea.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 80).isActive = true
        topArea.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
        topArea.heightAnchor.constraint(equalToConstant: 200).isActive = true
        topAnchor?.isActive = false
        topAnchor = topArea.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -400)
        topAnchor?.isActive = true
        
        logoLabel.leadingAnchor.constraint(equalTo: topArea.leadingAnchor, constant: 0).isActive = true
        logoLabel.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 0).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        playlistLabel.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 12).isActive = true
        playlistLabel.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 1).isActive = true
        playlistLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        playlistNameLabel.leadingAnchor.constraint(equalTo: logoLabel.trailingAnchor, constant: 11).isActive = true
        playlistNameLabel.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: -3).isActive = true
        playlistNameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // если текущий канал не пустой
        if currentChannel != nil {
            let channelLogo: UIImage? = getCurrentChannelLogo(with: "\(currentChannel!.yaid)")
            if channelLogo?.imageAsset != nil {
                print("\n\n THERE IS AN IMAGE")
                channelLogoImage.image = channelLogo
                
                channelLogoImage.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 0).isActive = true
                channelLogoImage.trailingAnchor.constraint(equalTo: topArea.trailingAnchor, constant: 0).isActive = true
                channelLogoImage.widthAnchor.constraint(equalToConstant: 400).isActive = true
                channelLogoImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
                channelNameLabel.topAnchor.constraint(equalTo: channelLogoImage.bottomAnchor, constant: 10).isActive = true
            } else {
                print("\n\n NO IMAGE FOUND")
                channelLogoImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
                channelLogoImage.heightAnchor.constraint(equalToConstant: 0).isActive = true
                channelNameLabel.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 0).isActive = true
            }
            
            channelNameLabel.trailingAnchor.constraint(equalTo: topArea.trailingAnchor, constant: 0).isActive = true
            channelNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        } else {
            // если пустой
            channelLogoImage.widthAnchor.constraint(equalToConstant: 0).isActive = true
            channelLogoImage.heightAnchor.constraint(equalToConstant: 0).isActive = true
            channelNameLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        
    }
    
    // MARK: - Tap Gestures
    
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
        
        removeGradientFromViewController()
        delegate?.channelSelectionPressed(currentChannel: channel)
        dismissViewControllerAnimation()
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
                dismissViewControllerAnimation()
           
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
