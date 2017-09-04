//
//  ChooseQuizTableViewCell.swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/19/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

class ChooseQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var clockView: ClockView! {
        didSet {
            clockView.addScalingUpAnimationAnimationCompletionBlock(nil)
        }
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentProgress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImageView.layer.cornerRadius = 30
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.borderWidth = 3
        categoryImageView.layer.borderColor = ThemeColor.MainLogoColor.CGColor
        titleLabel.textColor = ThemeColor.HeaderText
        descriptionLabel.textColor = ThemeColor.DescriptionText
        highScoreLabel.textColor = ThemeColor.LightBlue
        percentLabel.textColor = ThemeColor.LightBlue
        scoreLabel.textColor = ThemeColor.HeaderText
        percentProgress.textColor = ThemeColor.LimeGreen
        progressView.progressTintColor = ThemeColor.LimeGreen
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            self.selected = false
        }
    }

}
