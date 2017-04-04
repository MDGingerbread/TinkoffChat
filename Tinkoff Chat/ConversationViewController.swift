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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedRowHeight = 150
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toMessageChat") as? ChatMessageViewCell
            cell?.messageText.text = messages[indexPath.row].getMessage()
        
            cell?.bubleView.backgroundColor = UIColor.blue
        
            cell?.bubleView.layer.cornerRadius = 8
        
            cell?.bubleView.layer.masksToBounds = true
                
        
        return cell!

    }
}
