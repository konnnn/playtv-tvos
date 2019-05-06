//
//  ChannelCell.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 29.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

class ChannelCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    var channel: Channel? {
        didSet {
            if let name = channel?.name {
                nameLabel.text = name
                if let image = UIImage(named: "\(channel!.yaid)*68") {
                    logoImage.image = image
                } else {
                    logoImage.image = UIImage()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.sansNarrowBold(size: 34)
        
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
