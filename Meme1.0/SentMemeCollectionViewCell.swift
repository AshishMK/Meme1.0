//
//  SentMemeCollectionViewCell.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 10/3/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class SentMemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    // MARK : Setting Text Attributes
let strokeTextAttributes: [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.strokeColor : UIColor.black,
        NSAttributedStringKey.foregroundColor : UIColor.white,
          NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 18)!,
        NSAttributedStringKey.strokeWidth : -2.0,
        ]

   override func layoutSubviews() {
        super.layoutSubviews()
        configure(topLabel)
        configure(bottomLabel)
    }
    func configure(_ uiLabel: UILabel) {
        // TODO:- code to configure the textField
        uiLabel.attributedText = NSAttributedString(string: uiLabel.text!, attributes: strokeTextAttributes)
  
        
    }
  
    
    
}
