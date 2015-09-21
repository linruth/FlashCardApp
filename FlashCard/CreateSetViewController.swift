//
//  CreateSetViewController.swift
//  FlashCard
//
//  Created by Ruth Lin on 2015-09-18.
//  Copyright (c) 2015 Ruth Lin. All rights reserved.
//

import Foundation
import UIKit

class CreateSetViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    // MARK: Properties
    
    var sets = [[Card]]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var placelabelText: String = "Enter text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = mainColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        descriptionTextView.delegate = self
        descriptionTextView.text = placelabelText
        descriptionTextView.textColor = UIColor.lightGrayColor()
        descriptionTextView.selectedRange = NSMakeRange(0, 0)
        titleTextField.delegate = self
        checkValidCardSetName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        titleLabel.text = textField.text
        checkValidCardSetName()
    }
    
    func checkValidCardSetName() {
        // Disable the Done button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    // MARK: UITextViewDelegate
    
    //From http://stackoverflow.com/questions/27652227/text-view-placeholder-swift
    //Either set placeholder, replace with initial text, or update existing text
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        // If updated text view will be empty, use nil and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            return false
        }
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        // Else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text view and set its color to black to prepare for the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        return true
    }
    
    // Don't let the cursor move while the placeholder is visible
    func textViewDidChangeSelection(textView: UITextView) {
        if textView.text.hasPrefix(placelabelText) {
            textView.selectedRange = NSMakeRange(0, 0)
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Done" {
        let dest = segue.destinationViewController as! UINavigationController
        let finalDestination = dest.topViewController as! CreateCardViewController
        finalDestination.recievedSetName = titleTextField.text
        finalDestination.recievedDescriptionName = descriptionTextView.text
        }
    }
}




