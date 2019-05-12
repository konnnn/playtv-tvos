//
//  ChannelProgramCell.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 09.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

class ChannelProgramCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    var channel: Channel? {
        didSet {
            if let name = channel?.name {
                
                nameLabel.text = name
                
                if let image = UIImage(named: "\(channel!.yaid)*68") {
                    logoImage.image = image
                    imageWidthConstraint.constant = 110
                } else {
                    logoImage.image = UIImage()
                    imageWidthConstraint.constant = 0
                }
                
                let localDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
                let program = channel?.program.filter("start <= %@ AND finish > %@", localDate!, localDate!).sorted(byKeyPath: "start")
                
                if program!.count != 0 {
                    
                    var title: String?
                                
                    if program!.first?.programTitle == program!.first?.episodeTitle {
                        title = "\(program!.first!.programTitle!)"
                    } else {
                        if program!.first?.seasonNumber == 0 {
                            title = "\(program!.first!.programTitle!). \(program!.first!.episodeTitle!)"
                        } else {
                            let seasonNumber: String = "\(program!.first!.seasonNumber)"
                            title = "\(program!.first!.programTitle!). Сезон \(seasonNumber). \(program!.first!.episodeTitle!)"
                        }
                    }
                    
                    programNameLabel.text = "- \(title!)"

                } else {
                    programNameLabel.text = "Загрузка..."
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.sansNarrowBold(size: 34)
        programNameLabel.textColor = .white
        programNameLabel.font = UIFont.sansNarrowRegular(size: 28)
        
        logoImage.contentMode = .scaleAspectFit
        
        self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.3)
        self.layer.cornerRadius = 24
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                self.layer.cornerRadius = 26
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.7)
            } else {
                self.transform = CGAffineTransform.identity
                self.layer.cornerRadius = 24
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.3)
            }
        }) {
            
        }
    }
    
}
