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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = TempleCardManager.sharedInstance.templeForIndex(indexPath.row)!.name
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempleCardManager.sharedInstance.getTempleCount()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        templeDelegate.didSelectRowAtIndexPath(indexPath.row)
    }
}

protocol TempleTableViewDelegate {
    func didSelectRowAtIndexPath(row: Int)
}