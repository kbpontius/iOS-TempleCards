//
//  TempleTableViewController.swift
//  TempleFlashcards
//
//  Created by Kyle on 11/7/15.
//  Copyright © 2015 kylepontius. All rights reserved.
//

import UIKit

class TempleTableView: UITableViewController {
    var templeDelegate: TempleTableViewDelegate!
    
    // MARK: - TABLEVIEW METHODS
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let templeCell = TempleCardManager.sharedInstance.availableTempleForIndex(indexPath.row)
        cell.textLabel!.text = templeCell!.name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempleCardManager.sharedInstance.getAvailableTempleCount()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        templeDelegate.didSelectRowAtIndexPath(indexPath.row)
    }
}

// MARK: - TEMPLETABLEVIEWDELEGATE PROTOCOL
protocol TempleTableViewDelegate {
    func didSelectRowAtIndexPath(row: Int)
}