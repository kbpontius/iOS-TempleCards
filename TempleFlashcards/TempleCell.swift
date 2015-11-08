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
    @IBOutlet weak var vwNameBackdrop: UIView!
    @IBOutlet weak var vwHighlight: UIView!
    
    private var isStudyMode = false
    private var cellIsSelected = false
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        UIView.transitionWithView(self, duration: 0.3, options: .CurveEaseOut, animations: {
            self.layer.borderWidth = self.cellIsSelected ? 0 : 4
            self.layer.borderColor = UIColor(red: 100/255, green: 103/255, blue: 212/255, alpha: 1.0).CGColor
            
            self.lblName.hidden = !self.isStudyMode
            self.vwNameBackdrop.hidden = !self.isStudyMode
            
            if self.cellIsSelected {
                self.vwHighlight?.alpha = 0.5
                
            } else {
                self.vwHighlight?.alpha = 0.0
            }
        }, completion: nil)
    }
    
    // MARK: - SETTERS
    
    func setIsSelected(isSelected: Bool) {
        cellIsSelected = isSelected
        setNeedsDisplay()
    }
    
    func toggleIsSelected() {
        setIsSelected(!cellIsSelected)
    }
    
    func setIsStudyMode(isStudyMode: Bool) {
        self.isStudyMode = isStudyMode
    }
    
    // MARK: - GETTERS
    
    func getCellIsSelected() -> Bool {
        return cellIsSelected
    }
}
