//
//  ViewController.swift
//  ChatViewPractise
//
//  Created by Nitin Bhatia on 1/11/21.
//

import UIKit


class CellIds {
    
    static let senderCellId = "senderCellId"
    
    static let receiverCellId = "receiverCellId"
}

class ViewController: UIViewController,UITextViewDelegate {
    
    //outlets
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var inputViewContainer: UIView!
    @IBOutlet var txtMessageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var inputViewContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnSend: UIButton!
    
    //variables
    var shouldMoveUp : Bool = true
    var placeholderLabel : UILabel!
    var items = [MessageModel]()
    
    var bottomHeight: CGFloat {
        guard #available(iOS 11.0, *),
            let window = UIApplication.shared.keyWindow else {
                return 0
        }
        return window.safeAreaInsets.bottom
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //setup input accessory
        setupInputAccessory()
        //setup chat table view
        setupChatView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.tableView.scrollToRow(at: IndexPath(row: self.items.count - 1, section: 0), at: .none, animated: false)
        })
        
    }
    
    // MARK: send button action
    @IBAction func btnSendAction(_ sender: Any) {
        items.append(MessageModel.createMessage(messageText: txtMessage.text, messageType: .Text, isSent: true, date: MessageModel.getMessageDate(date: Date())))
        tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.items.count - 1, section: 0), at: .none, animated: false)
        clearTextBoxOfMessage()
    }
    
    //MARK: clear text after sending message
    func clearTextBoxOfMessage(){
        txtMessage.text = ""
        placeholderLabel.isHidden = false
        btnSend.isEnabled = false
    }
    
}


extension ViewController {
    // MARK: sets up input accessory
    func setupInputAccessory(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        txtMessage.delegate = self
        //set up tool bar
        setupToolbar()
        //setup placeholder
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
    
    // MARK: text view delegates
    func textViewDidChange(_ textView: UITextView)
    {
        let isOversize = textView.contentSize.height >= txtMessageHeightConstraint.constant
        txtMessageHeightConstraint.isActive = isOversize
        txtMessage.isScrollEnabled = isOversize
        print(isOversize)
        
        if textView.text == "" {
            placeholderLabel.isHidden = false
            btnSend.isEnabled = false
        } else {
            placeholderLabel.isHidden = true
            btnSend.isEnabled = true
        }
    }
    
    /* for now this block is not required, as this is being handled in text did change event
     
//    func textViewDidBeginEditing(_ textView: UITextView) {
////        placeholderLabel.isHidden = true
////        btnSend.isEnabled = true
////        if txtMessage.textColor == UIColor.lightGray {
////            txtMessage.text = ""
////            txtMessage.textColor = UIColor.black
////        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        if txtMessage.text == "" {
////
////            txtMessage.text = "Placeholder text ..."
////            txtMessage.textColor = UIColor.lightGray
//            placeholderLabel.isHidden = false
//            btnSend.isEnabled = false
//        }
    }
     */
    
    // MARK: handles keyboard will show
    @objc func keyboardWillShow(notification: NSNotification) {
        if !shouldMoveUp {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            inputViewContainerBottomConstraint.constant -= keyboardSize.height
            print("key")
            shouldMoveUp = false
           // let oldOffset = self.tableView.contentOffset
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
               // self.tableView.setContentOffset(CGPoint(x: oldOffset.x, y: oldOffset.y + keyboardSize.height - self.bottomHeight), animated: false)
            }
        }
    }
    
    // MARK: handles keyboard will hide
    @objc func keyboardWillHide(notification: NSNotification) {
        shouldMoveUp = true
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputViewContainerBottomConstraint.constant = 0
        }
        
    }
}

//chat table view extension
extension ViewController: UITableViewDataSource {
    
    func setupChatView(){
     //   tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: CellIds.receiverCellId)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: CellIds.senderCellId)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        for index in 0...50 {
            let date = MessageModel.getMessageDate(date: Date())
            let message = MessageModel.createMessage(messageText: randomString(length: Int.random(in: 2...50)), messageType: .Text, isSent: (index % 2 == 0),date: date)
            items.append(message)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !items[indexPath.row].isSent {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "recevierCell", for: indexPath) as? RecevierTableViewCell {
                cell.selectionStyle = .none
                cell.txtChatMessage.text = items[indexPath.row].messageText
                cell.txtChatMessage.sizeToFit()
                cell.lblDate.text = items[indexPath.row].date
                //cell.showTopLabel = false
                return cell
            }
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as? SenderTableViewCell {
                cell.selectionStyle = .none
                cell.txtChatMessage.text = items[indexPath.row].messageText
                cell.lblDate.text = items[indexPath.row].date
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

