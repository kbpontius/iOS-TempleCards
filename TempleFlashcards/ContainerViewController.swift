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
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var vwStatusBackground: UIView!
    
    // MARK: - COMPUTED PROPERTIES
    private var isStudyMode = false {
        didSet {
            if isStudyMode == true {
                // This redraws the cells selected cells,
                // then animates the positions changes.
                selectedPictureIndex = -1
            }
            
            // Set "Reset" button state.
            toolbar.items![0].enabled = !isStudyMode
            updateStudyButton()
            cllnvwTempleCards.reloadSections(NSIndexSet(index: 0))
        }
    }
    
    private var scoreMatches = 0 {
        didSet {
            updateScore()
        }
    }
    private var scoreAttempts = 0 {
        didSet {
            updateScore()
        }
    }
    
    // MARK: - GENERAL PROPERTIES
    
    private var selectedNameIndex = -1
    private var selectedPictureIndex = -1
    private var tableVC: TempleTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        setupCollectionView()
        setupStatusBar()
    }
    
    // MARK: - SETUP METHODS
    
    private func setupToolbar() {
        updateStudyButton()
        updateScore()
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
    
    private func setupStatusBar() {
        updateStatusMessage("", highlight: false)
    }
    
    // MARK: - NAVIGATION METHODS
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueTableView" {
            let templeTableVC = segue.destinationViewController as! TempleTableView
            templeTableVC.templeDelegate = self
            templeTableVC.tableView.contentInset.bottom = toolbar.bounds.height
            templeTableVC.tableView.scrollIndicatorInsets.bottom = toolbar.bounds.height
            tableVC = templeTableVC
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
        if selectedNameIndex != -1 && selectedPictureIndex != -1 {
            if selectedNameIndex == selectedPictureIndex {
                TempleCardManager.sharedInstance.setIsPicked(selectedNameIndex, isPicked: true)
                scoreMatches++
            } else {
                scoreAttempts++
            }
            
            resetSelectedIndices()
            refreshViews()
        }
    }
    
    // MARK: - IBACTION METHODS
    @IBAction func btnResetTapped(sender: UIBarButtonItem) {
        TempleCardManager.sharedInstance.resetAllTemples()
        refreshViews()
        
        scoreAttempts = 0
        scoreMatches = 0
        
        cllnvwTempleCards.setContentOffset(CGPointZero, animated: true)
        tableVC.tableView.setContentOffset(CGPointZero, animated: true)
        
        updateStatusMessage("Successfully Reset", highlight: true)
    }
    
    // MARK: - HELPER METHODS
    
    private func updateStatusMessage(message: String, highlight: Bool) {
        lblStatus.text = message
        
        if highlight {
            vwStatusBackground.backgroundColor = UIColor(red: 142/255, green: 255/255, blue: 157/255, alpha: 1.0)
            UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseOut, animations: {
                self.vwStatusBackground.backgroundColor = UIColor.darkGrayColor()
            }, completion: nil)
        }
    }
    
    private func updateStudyButton() {
        if !isStudyMode {
            let button = UIBarButtonItem(title: "Study", style: .Plain, target: self, action: "toggleStudyMode")
            button.customView?.backgroundColor = UIColor.redColor()
            toolbar.items![6] = button
        } else {
            toolbar.items![6] = UIBarButtonItem(title: "Game", style: .Plain, target: self, action: "toggleStudyMode")
        }
    }
    
    private func updateScore() {
        toolbar.items![4] = getIncorrectAttemptsView(String(scoreAttempts))
        toolbar.items![2] = getCorrectMatchesView(String(scoreMatches))
    }
    
    private func resetSelectedIndices() {
        if let selectedRow = tableVC.tableView.indexPathForSelectedRow {
            tableVC.tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
        
        selectedPictureIndex = -1
        selectedNameIndex = -1
    }
    
    private func refreshViews() {
        cllnvwTempleCards.reloadSections(NSIndexSet(index: 0))
        tableVC.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    private func getIncorrectAttemptsView(numberIncorrect: String) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Incorrect: \(numberIncorrect)", style: .Plain, target: nil, action: "")
        button.enabled = false
        return button
    }
    
    private func getCorrectMatchesView(numberCorrect: String) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: "Correct: \(numberCorrect)", style: .Plain, target: nil, action: "")
        button.enabled = false
        return button
    }
}

// MARK: - COLLECTIONVIEW DELEGATE/DATASOURCE METHODS
extension ContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TempleCell
        
        // Get correct templeCell, based on the app's mode.
        let templeCell = isStudyMode ? TempleCardManager.sharedInstance.templeForIndex(indexPath.row)
                                        : TempleCardManager.sharedInstance.availableTempleForIndex(indexPath.row)
        cell.imgTemple.image = templeCell!.image
        cell.lblName.text = templeCell!.name
        cell.setIsSelected(indexPath.row == selectedPictureIndex)
        cell.setIsStudyMode(isStudyMode)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Get correct # of templeCells, based on the app's mode.
        return isStudyMode ? TempleCardManager.sharedInstance.getTotallTempleCount()
                                : TempleCardManager.sharedInstance.getAvailableTempleCount()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if isStudyMode {
            return
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TempleCell
        cell.toggleIsSelected()
        
        if let previouslySelectedCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: selectedPictureIndex, inSection: 0)) as? TempleCell {
            previouslySelectedCell.setIsSelected(false)
            previouslySelectedCell.setNeedsDisplay()
            selectedPictureIndex = -1
        }
        
        if cell.getCellIsSelected() {
            selectedPictureIndex = indexPath.row
            evaluateMatch()
        }
    }
}

// MARK: - DELEGATE METHODS
extension ContainerViewController: TempleTableViewDelegate {
    func didSelectRowAtIndexPath(row: Int) {
        selectedNameIndex = row
        evaluateMatch()
    }
}