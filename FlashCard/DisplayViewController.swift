//
//  DisplayViewController.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

    import Foundation
    import UIKit
    import CoreData

    class DisplayViewController: UIViewController, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate{

    // MARK: Properties
        
    @IBOutlet weak var front: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var recievedSet = NSSet()
    var cardArray = [AnyObject]()
    var currentCard = 0
    var showBack = true
    var finalArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        cardArray = recievedSet.allObjects
        checkNextButton()
        showCard()
    }
        
    func checkNextButton() {
        if (currentCard >= (cardArray.count-1)){
                nextButton.enabled = false
            }
    }
        
    func showCard(){
        front.text = cardArray[currentCard].valueForKey("front") as? String
        photo.image = cardArray[currentCard].valueForKey("photo") as? UIImage
    }
        
    @IBAction func answerClicked(sender: AnyObject) {
            if (self.showBack){
                textView.text =  cardArray[currentCard].valueForKey("back") as? String
                self.showBack = false
            }
            else {
                textView.text = nil
                self.showBack = true
            }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "Next" {
                let dest = segue.destinationViewController as! DisplayViewController
                currentCard++
                dest.currentCard = currentCard
                dest.recievedSet = recievedSet
            }
            else if segue.identifier == "Back" {
                currentCard--
                if currentCard >= 0 {
                    let dest = segue.destinationViewController as! DisplayViewController
                    dest.currentCard = currentCard
                    dest.recievedSet = recievedSet
                }
                else {
                    let dest = segue.destinationViewController as! TableViewController
                }
            }
        }
        
        @IBAction func unwindToBack(segue: UIStoryboardSegue) {
            showCard()
            checkNextButton()
        }

    }
