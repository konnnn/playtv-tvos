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
    @IBOutlet weak var progressView: UIProgressView!
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
                    programNameLabel.text = ProgramGuide.getTitle(from: program![0])
                    progressView.setProgress(ProgramGuide.getProgressTime(from: program![0]), animated: true)

                } else {
                    programNameLabel.text = "Загрузка..."
                    progressView.progress = 0.0
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
        progressView.trackTintColor = UIColor(hexString: "#3E4157")
        progressView.progressTintColor = UIColor(hexString: "#3FDE10")
        progressView.layer.masksToBounds = true
        progressView.progress = 0.0
        logoImage.contentMode = .scaleAspectFit
        
        self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.3)
        self.layer.cornerRadius = 24
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                self.layer.cornerRadius = 26
                self.progressView.trackTintColor = UIColor(hexString: "#6B6B85")
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.7)
            } else {
                self.transform = CGAffineTransform.identity
                self.layer.cornerRadius = 24
                self.progressView.trackTintColor = UIColor(hexString: "#3E4157")
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.3)
            }
        }) {
            
        }
    }
    
}
