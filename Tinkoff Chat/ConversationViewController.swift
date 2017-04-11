//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

protocol ConversationViewControllerDelegate: class {
    func conversationViewController(lostUser withID: String)
}

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicationManagerDelegate {

    var messages = [Message]()
    
    var userID: String? = nil
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    weak var delegate: ConversationViewControllerDelegate?
    
    @IBOutlet weak var sendButton: UIButton!
    
    let manager = CommunicationManager.getInstance()
    
    @IBAction func sendAction(_ sender: Any) {
        guard let text  = inputTextField.text, !text.isEmpty else {
            return
        }
        let message = Message(message: text, fromTo: 1)
        if let userID = self.userID {
            MultipeerCommunicator.getInstance().sendMessage(string: inputTextField.text!, to: userID, completionHandler: { (true, error) in
            })
            messages.append(message)
            inputTextField.text = ""
            self.tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        manager.delegate = self
        
        tableView.estimatedRowHeight = 150
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func communicationManager(foundUser userID: String, withUserName: String?) {}
    
    func communicationManager(lostUser userName: String) {
        let alertController = UIAlertController(title: "Чат завершен", message: "Пользователь покинул беседу", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel) { (alert) in
            self.sendButton.isEnabled = false
            self.delegate?.conversationViewController(lostUser: userName)
        }
        alertController.addAction(action)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func communicationManager(receiveMessage message: String, fromUser userId: String) {
        let message = Message(message: message, fromTo: 2)
        messages.append(message)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            let isKeyboardHiding = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint.constant = isKeyboardHiding ? (keyboardFrame?.height)! : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].fromTo == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toMessageChat") as? ChatMessageViewCell
            
            cell?.messageText.text = messages[indexPath.row].getMessage()
            
            cell?.bubleView.backgroundColor = UIColor.blue
            
            cell?.bubleView.layer.cornerRadius = 8
            
            cell?.bubleView.layer.masksToBounds = true
            
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fromMessageChat") as? ChatFromMessageViewCell
            
            cell?.messageText.text = messages[indexPath.row].getMessage()
            
            cell?.bubleView.backgroundColor = UIColor.black
            
            cell?.bubleView.layer.cornerRadius = 8
            
            cell?.bubleView.layer.masksToBounds = true
            
            return cell!
        }
        
    
        

    }
}
