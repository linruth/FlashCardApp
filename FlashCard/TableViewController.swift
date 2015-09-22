//
//  tableViewCell.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    // MARK: Properties
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var finalArray = [Set]()
    var cardArray = [Card1]()
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = editButtonItem()
        
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        getAllSets()
    }
    
    // MARK: Actions
    
    func getAllSets(){
        let fetchRequest = NSFetchRequest(entityName:"Set")
        var error: NSError?
        do{
            let fetchedResults = try managedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
            finalArray = results as! [Set]
            }
        }catch{
           print("Could not fetch")
        }
    }
    
    func getCardsFromSet(index: Int){
        let fetchRequest = NSFetchRequest(entityName: "Set")
        var error: NSError?
        let predicate = NSPredicate(format: "ANY card1s in %@", finalArray[index].card1s)
        fetchRequest.predicate = predicate
        do{
            let results = try managedContext!.executeFetchRequest(fetchRequest)
            cardArray = results as![Card1]
        }catch{
            print("Could not fetch cards form set")
        }
    }

    
    // MARK: Display
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SetTableViewCell
        // Fetches the appropriate set for the data source layout.
        let sets = finalArray[indexPath.row]
        cell.setName.text = sets.valueForKey("setName")as? String
        cell.setDescription.text = sets.valueForKey("setDescription")as? String
        return cell
    }
    
    // MARK: Edit
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedContext!.deleteObject(finalArray[indexPath.row])
            finalArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            var error: NSError?
            do {
                try managedContext!.save()
                print("Set was deleted")
                }catch{
                print("Could not delete set")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let dest = segue.destinationViewController as! DisplayViewController
            // Get the cell that generated this segue.
            if let selectedCell = sender as? SetTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let cardArray = finalArray[indexPath.row].card1s
                dest.recievedSet = cardArray
            }
        }
    }
    
    @IBAction func unwindToBack(segue: UIStoryboardSegue) {
        getAllSets()
    }
    
}