//
//  ViewController.swift
//  TempleFlashcards
//
//  Created by Kyle on 10/31/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    @IBOutlet weak var cllnvwTempleCards: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var lcCllnVwRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lcTableViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lcTableViewWidth: NSLayoutConstraint!
    
    private var isStudyMode = false
    private var selectedNameIndex = -1
    private var selectedPictureIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStudyButton()
        setupCollectionView()
    }
    
    private func setupStudyButton() {
        toolbar.items![1] = UIBarButtonItem(title: "Study", style: .Plain, target: self, action: "toggleStudyMode")
    }
    
    private func setupCollectionView() {
        cllnvwTempleCards.delegate = self
        cllnvwTempleCards.dataSource = self
        cllnvwTempleCards.contentInset.bottom = toolbar.bounds.height
        cllnvwTempleCards.backgroundColor = UIColor.clearColor()
        
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        view.insertSubview(blurEffectView, atIndex: 0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueTableView" {
            let tableVC = segue.destinationViewController as! TempleTableView
            tableVC.templeDelegate = self
            tableVC.tableView.contentInset.bottom = toolbar.bounds.height
            tableVC.tableView.scrollIndicatorInsets.bottom = toolbar.bounds.height
        }
    }
    
    func toggleStudyMode() {        
        if isStudyMode {
            isStudyMode = false
            self.lcCllnVwRightConstraint.constant += self.lcTableViewWidth.constant
            self.lcTableViewRightConstraint.constant += self.lcTableViewWidth.constant
        } else {
            isStudyMode = true
            self.lcCllnVwRightConstraint.constant -= self.lcTableViewWidth.constant
            self.lcTableViewRightConstraint.constant -= self.lcTableViewWidth.constant
        }
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func evaluateMatch() {
        print("Name Index: \(selectedNameIndex)")
        print("Picture Index: \(selectedPictureIndex)")
        if selectedNameIndex != -1 && selectedPictureIndex != -1 {
            if selectedNameIndex == selectedPictureIndex {
                
            } else {
                // Evaluate points
            }
            
            resetSelectedIndices()
        }
    }
    
    private func resetSelectedIndices() {
        selectedPictureIndex = -1
        selectedNameIndex = -1
    }
}

extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TempleCell
        cell.imgTemple.image = TempleCardManager.sharedInstance.templeForIndex(indexPath.row)!.image
        cell.lblName.text = TempleCardManager.sharedInstance.templeForIndex(indexPath.row)!.name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TempleCardManager.sharedInstance.getTempleCount()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPictureIndex = indexPath.row
        evaluateMatch()
    }
}

// MARK: - DELEGATE METHODS
extension ContainerViewController: TempleTableViewDelegate {
    func didSelectRowAtIndexPath(row: Int) {
        selectedNameIndex = row
        evaluateMatch()
    }
}