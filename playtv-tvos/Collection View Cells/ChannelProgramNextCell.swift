//
//  ChannelProgramNextCell.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 12.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

class ChannelProgramNextCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var programNextNameLabel: UILabel!
    @IBOutlet weak var programNextTimeLabel: UILabel!
    
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
                let program = channel?.program.filter("finish > %@", localDate!).sorted(byKeyPath: "start")
                
                if program!.count > 1 {
                    programNameLabel.text = ProgramGuide.getTitle(from: program![0])
                    progressView.setProgress(ProgramGuide.getProgressTime(from: program![0]), animated: true)
                    programNextTimeLabel.text = ProgramGuide.getTimeLeft(from: program![1])
                    programNextNameLabel.text = ProgramGuide.getTitle(from: program![1])
                    
                    print("\n\n  \(channel!.name!)/\(program![0].objectID!): \(program![0].start!) — \(program![1].start!)")
                    
                } else if program!.count == 1 {
                    programNameLabel.text = ProgramGuide.getTitle(from: program![0])
                    progressView.setProgress(ProgramGuide.getProgressTime(from: program![0]), animated: true)
                    programNextTimeLabel.text = "Далее, ..."
                    programNextNameLabel.text = "Загрузка..."
                    
                } else {
                    programNameLabel.text = "Загрузка..."
                    programNextTimeLabel.text = "Далее, ..."
                    programNextNameLabel.text = "Загрузка..."
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
        programNextNameLabel.textColor = .white
        programNextNameLabel.font = UIFont.sansNarrowRegular(size: 28)
        programNextTimeLabel.textColor = UIColor(hexString: "#888994")
        programNextTimeLabel.font = UIFont.sansNarrowRegular(size: 24)
        separatorView.backgroundColor = UIColor(hexString: "#1C1D27")
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
                self.separatorView.backgroundColor = UIColor(hexString: "#FFEC00")
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.7)
            } else {
                self.transform = CGAffineTransform.identity
                self.layer.cornerRadius = 24
                self.progressView.trackTintColor = UIColor(hexString: "#3E4157")
                self.separatorView.backgroundColor = UIColor(hexString: "#1C1D27")
                self.backgroundColor = UIColor(hexString: "#3E4157", alpha: 0.3)
            }
        }) {
            
        }
    }
    
}
