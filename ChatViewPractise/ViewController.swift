//
//  ViewController.swift
//  ChatViewPractise
//
//  Created by Nitin Bhatia on 1/11/21.
//

import UIKit


let BOTTOM_GAP_TEXT_MESSAGE = 20

class ViewController: UIViewController,UITextViewDelegate {
    
    //outlets
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var inputViewContainer: UIView!
    @IBOutlet var txtMessageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var inputViewContainerBottomConstraint: NSLayoutConstraint!
    
    //variables
    var shouldMoveUp : Bool = true
    var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup input accessory
        setupInputAccessory()
    }
}


extension ViewController {
    
    func setupInputAccessory(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        txtMessage.delegate = self
        
        setupToolbar()
        setupPlaceholder()
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupToolbar(){
        //Create a toolbar
        let bar = UIToolbar()
        
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        
        //Add the toolbar to our textfield
        txtMessage.inputAccessoryView = bar
    }
    
    func setupPlaceholder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type a message"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (txtMessage.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtMessage.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtMessage.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        let isOversize = textView.contentSize.height >= txtMessageHeightConstraint.constant
        txtMessageHeightConstraint.isActive = isOversize
        txtMessage.isScrollEnabled = isOversize
        print(isOversize)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true

//        if txtMessage.textColor == UIColor.lightGray {
//            txtMessage.text = ""
//            txtMessage.textColor = UIColor.black
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if txtMessage.text == "" {
//
//            txtMessage.text = "Placeholder text ..."
//            txtMessage.textColor = UIColor.lightGray
            placeholderLabel.isHidden = false
        }
    }
    
    //keyboardHandler
    @objc func keyboardWillShow(notification: NSNotification) {
        if !shouldMoveUp {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            inputViewContainerBottomConstraint.constant -= keyboardSize.height
            print("key")
            shouldMoveUp = false
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        shouldMoveUp = true
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputViewContainerBottomConstraint.constant = 0
        }
        
    }
}

