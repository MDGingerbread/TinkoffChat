//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toMessageChat") as? ChatMessageViewCell
            cell?.messageText.text = messages[indexPath.row].getMessage()
            
            if let messageText = messages[indexPath.row].message {
                
                let size = CGSize(width: view.frame.width / 2, height: 1000)
                
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
                let estimatedFrame = NSString(string:messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
                
                cell?.messageText.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width, height: estimatedFrame.height + 120)
                cell?.bubleView.frame = CGRect(x: 0, y: 0, width: estimatedFrame.width + 8, height: estimatedFrame.height + 120)
                
                cell?.bubleView.backgroundColor = UIColor.blue
                cell?.bubleView.layer.cornerRadius = 15
                cell?.bubleView.layer.masksToBounds = true
                
            }
            return cell!

        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "fromMessageChat") as? ChatMessageViewCell
            cell?.messageText.text = messages[indexPath.row].getMessage()
            
            if let messageText = messages[indexPath.row].message {
                
                let size = CGSize(width: view.frame.width / 2, height: 1000)
                
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                
                let estimatedFrame = NSString(string:messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)], context: nil)
                
                cell?.messageText.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width, height: estimatedFrame.height + 120)
                cell?.bubleView.frame = CGRect(x: 0, y: 0, width: estimatedFrame.width + 8, height: estimatedFrame.height + 120)
                
                cell?.bubleView.backgroundColor = UIColor.blue
                cell?.bubleView.layer.cornerRadius = 15
                cell?.bubleView.layer.masksToBounds = true
                
            }
            
            return cell!
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let messageText = messages[indexPath.row].message {
            
            let size = CGSize(width: view.frame.width / 2, height: 1000)
            
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string:messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize:15)], context: nil)
            
            if estimatedFrame.height < 20 {
                
                return estimatedFrame.height + 35
            
            } else if  estimatedFrame.height < 50 {
                
                return estimatedFrame.height + 25
                
            } else if estimatedFrame.height < 300  {
                
                return estimatedFrame.height + 150
                
            }
        }
        
        return 80
    }
    
}
