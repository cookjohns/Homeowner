//
//  ItemsTableViewController.swift
//  Homeowner
//
//  Created by John Cook on 5/30/16.
//  Copyright © 2016 John Cook. All rights reserved.
//

import UIKit


class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        // create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // determine where item is in array
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
            // insert new row into table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        // if currently in editing mode
        if (editing) {
            // change button text to show proper state
            sender.setTitle("Edit", forState: .Normal)
            // turn off editing mode
            setEditing(false, animated: true)
        } else {
            // change button text to show proper state
            sender.setTitle("Done", forState: .Normal)
            // enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get height of status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        // set padding for tableView
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset          = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // create instance of UITableViewCell with default appearance
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        // update labels for new preferred text size (set by user in Settings app)
        cell.updateLabels()
        
        // set text on cell w/ description of item that is nth index of items 
        // (where n = row this cell will appear on)
        let item = itemStore.allItems[indexPath.row]
        
        // configure the cell with the Item
        cell.nameLabel.text         = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text        = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(table: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // if tableView asking to commit delete command
        if (editingStyle == .Delete) {
            let item = itemStore.allItems[indexPath.row]
            
            // pop up alert
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            // alert actions
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                (action) -> Void in
                // remove item from store
                self.itemStore.removeItem(item)
                // and remove row from tableView (with animation)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            ac.addAction(deleteAction)
            
            // present the alert controller
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    /* Update storage model in the event that user rearranges cells (which calls moveRowAtIndexPath) 
     * Also causes reordering controls to be visible simply be implementing 
     */
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // update the model
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if triggered segue is "ShowItem" segue
        if (segue.identifier == "ShowItem") {
            // figure out which row was tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // get item associated with that row, and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
            }
        }
    }
}