//
//  ProductTableViewCell.swift
//  SupermomQuiz
//
//  Created by Jakkrit S on 10/2/2558 BE.
//  Copyright (c) 2558 AppIllustrator. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        productImageView.layer.cornerRadius = 30
        productImageView.clipsToBounds = true
        productImageView.layer.borderWidth = 3
        productImageView.layer.borderColor = ThemeColor.MainLogoColor.CGColor
        
        productTitle.textColor = ThemeColor.BrightRed
        productDescription.textColor = ThemeColor.LightBlue
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            self.selected = false
        }
    }

}
