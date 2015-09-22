//
//  CreateCardViewController.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import UIKit
import CoreData

class CreateCardViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var navigationControl: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    
    var card = Card?()
    var cardArray = [Card]()
    var showFront = true
    var recievedSetName: String = ""
    var recievedDescriptionName: String = ""
    var cardNumber = 0
    var finalArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        checkAddButton()
        checkDeleteButton()
        checkBackButton()
        textView.delegate = self
        nameTextField.delegate = self
        if let card = card {
            nameTextField.text = card.front
            photoImageView.image = card.photo
            textView.text = card.back
        }
        checkValidCardName()
        checkForwardButton()
    }
    
    
    // MARK: Actions
    
    func saveAction(cardSet: [Card]) {
        // Get reference to app delegate for NSManagedObjectContext(acts as in-memory scratchpad to work with managed objects. Require to save/retrive from Core Data store.
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var managedContext = appDelegate.managedObjectContext!
        var cardEntity = NSEntityDescription.entityForName("Card1",inManagedObjectContext:managedContext)
        var setEntity = NSEntityDescription.entityForName("Set",inManagedObjectContext: managedContext)
        var set = NSManagedObject(entity: setEntity!,
            insertIntoManagedObjectContext:managedContext)
        set.setValue(recievedSetName, forKey: "setName")
        set.setValue(recievedDescriptionName, forKey: "setDescription")
        var setOrganization = set.mutableSetValueForKey("card1s")
        
        for var i = 0; i < cardSet.count; ++i {
            var card1 = NSManagedObject(entity: cardEntity!,insertIntoManagedObjectContext:managedContext)
            card1.setValue(cardSet[i].photo, forKey: "photo")
            card1.setValue(cardSet[i].front, forKey: "front")
            card1.setValue(cardSet[i].back, forKey: "back")
            setOrganization.addObject(card1)
            var error: NSError?
            do {
                try managedContext.save()
                print("Card was deleted")
            }catch{
                print("Could not delete card")
            }
        }
    }
    
    func checkBackButton(){
        if (cardNumber <= 0){
            backButton.enabled = false
        }
        else {
            backButton.enabled = true
        }
    }
    
    func checkAddButton(){
            if (cardNumber != cardArray.count - 1){
                addButton.enabled = false
                saveButton.enabled = false
                if (cardNumber == cardArray.count){
                    addButton.enabled = true
                    saveButton.enabled = true
                }
        }
    }

    func checkForwardButton() {
        if (cardNumber >= (cardArray.count-1)){
            forwardButton.enabled = false
        }
        else {
            forwardButton.enabled = true
        }
    }
    
    func checkDeleteButton(){
        if (cardArray.isEmpty || cardArray.count == 1 || cardNumber == cardArray.count){
            deleteButton.enabled = false
        }
        else {
            deleteButton.enabled = true
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
        backButton.enabled = false
        forwardButton.enabled = false
        addButton.enabled = false
        deleteButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkAddButton()
        checkDeleteButton()
        checkBackButton()
        checkValidCardName()
        checkForwardButton()
    }
    
    func checkValidCardName() {
        let text = nameTextField.text ?? ""
        let text2 = textView.text ?? ""
        addButton.enabled  = !text.isEmpty && !text2.isEmpty
        saveButton.enabled = !text.isEmpty && !text2.isEmpty
        deleteButton.enabled = !text.isEmpty && !text2.isEmpty
        forwardButton.enabled = !text.isEmpty && !text2.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView){
        animateViewMoving(true, moveValue: 175)
        saveButton.enabled = false
        backButton.enabled = false
        forwardButton.enabled = false
        addButton.enabled = false
        deleteButton.enabled = false
    }
    
    func textViewDidEndEditing(textView: UITextView){
        animateViewMoving(false, moveValue: 175)
        checkAddButton()
        checkBackButton()
        checkValidCardName()
        checkDeleteButton()
        checkForwardButton()
    }
    
    //from http://www.jogendra.com/2015/01/uitextfield-move-up-when-keyboard.html
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCard" {
            let dest = segue.destinationViewController as! CreateCardViewController
            dest.recievedDescriptionName = recievedDescriptionName
            dest.recievedSetName = recievedSetName
            let front = nameTextField.text ?? ""
            let photo = photoImageView.image
            let back = textView.text
            card = Card(setName: recievedSetName, setDescription: recievedDescriptionName, front: front, photo: photo, back: back)
            cardArray.append(card!)
            dest.cardArray = cardArray
            cardNumber++
            dest.cardNumber = cardNumber
        }
        else if segue.identifier == "Back" {
            let dest = segue.destinationViewController as! CreateCardViewController
            dest.recievedDescriptionName = recievedDescriptionName
            dest.recievedSetName = recievedSetName
            if ((card?.front != nameTextField.text) || (card?.photo != photoImageView.image) || (card?.back != textView.text)) && (!nameTextField.text!.isEmpty && !textView.text.isEmpty){
                let front = nameTextField.text ?? ""
                let photo = photoImageView.image
                let back = textView.text
                card = Card(setName: recievedSetName, setDescription: recievedDescriptionName, front: front, photo: photo, back: back)
                cardArray[cardNumber] = card!
            }
            cardNumber--
            dest.cardNumber = cardNumber
            card = cardArray[cardNumber]
            dest.card = card
            dest.cardArray = cardArray
        }
            
        else if segue.identifier == "Delete" {
            let dest = segue.destinationViewController as! CreateCardViewController
            dest.recievedDescriptionName = recievedDescriptionName
            dest.recievedSetName = recievedSetName
            cardArray.removeAtIndex(cardNumber)
            dest.cardArray = cardArray
            if cardNumber == 0 {
                cardNumber++
                dest.cardNumber = cardNumber
                card = cardArray[cardNumber]
                dest.card = card
            }
            cardNumber--
            dest.cardNumber = cardNumber
            card = cardArray[cardNumber]
            dest.card = card
        }

        else if segue.identifier == "Forward" {
            let dest = segue.destinationViewController as! CreateCardViewController
            dest.recievedDescriptionName = recievedDescriptionName
            dest.recievedSetName = recievedSetName
            if ((card?.front != nameTextField.text ?? "") || (card?.photo != photoImageView.image) || (card?.back != textView.text)) && (!nameTextField.text!.isEmpty && !textView.text.isEmpty){
                let front = nameTextField.text ?? ""
                let photo = photoImageView.image
                let back = textView.text
                card = Card(setName: recievedSetName, setDescription: recievedDescriptionName, front: front, photo: photo, back: back)
                cardArray[cardNumber] = card!
            }
            cardNumber++
            dest.cardNumber = cardNumber
            card = cardArray[cardNumber]
            dest.card = card
            dest.cardArray = cardArray
        }
            
        else if segue.identifier == "Save" {
            if (cardNumber != cardArray.count){
                if ((card?.front != nameTextField.text ?? "") || (card?.photo != photoImageView.image) || (card?.back != textView.text)) && (!nameTextField.text!.isEmpty && !textView.text.isEmpty){
                    let front = nameTextField.text ?? ""
                    let photo = photoImageView.image
                    let back = textView.text
                    card = Card(setName: recievedSetName, setDescription: recievedDescriptionName, front: front, photo: photo, back: back)
                    cardArray[cardNumber] = card!
                    saveAction(cardArray)
                    }
                else {
                    saveAction(cardArray)
                }
            }
            else {
                let front = nameTextField.text ?? ""
                let photo = photoImageView.image
                let back = textView.text
                card = Card(setName: recievedSetName, setDescription: recievedDescriptionName, front: front, photo: photo, back: back)
                cardArray.append(card!)
                saveAction(cardArray)
            }
        }
    }
    
    @IBAction func unwindToBack(segue: UIStoryboardSegue) {
        if let card = card {
            nameTextField.text = card.front
            photoImageView.image = card.photo
            textView.text = card.back
            checkValidCardName()
            checkForwardButton()
            checkAddButton()
            checkDeleteButton()
            checkBackButton()
        }
    }

}
