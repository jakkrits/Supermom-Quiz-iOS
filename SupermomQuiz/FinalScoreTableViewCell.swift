//
//  FinalScoreTableViewCell.swift
//  SupermomQuiz
//
//  Created by JakkritS on 11/3/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

class FinalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var quizName: UILabel!
    @IBOutlet weak var quizDescription: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quizName.textColor = ThemeColor.HeaderText
        quizDescription.textColor = ThemeColor.DescriptionText
        bestScoreLabel.textColor = ThemeColor.LimeGreen
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
