//
//  TempleImageView.swift
//  TempleFlashcards
//
//  Created by Kyle on 11/1/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import UIKit

class TempleCell: UICollectionViewCell {
    @IBOutlet weak var imgTemple: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var vwShader: UIView!
    
    var isStudyMode = false
    
    override func drawRect(rect: CGRect) {
        layer.borderWidth = 4
        layer.borderColor = UIColor(red: 100/255, green: 103/255, blue: 212/255, alpha: 1.0).CGColor
        lblName.hidden = !isStudyMode
        vwShader.hidden = !isStudyMode
    }
    
    func setIsSelected(isSelected: Bool) {
        
    }
}
