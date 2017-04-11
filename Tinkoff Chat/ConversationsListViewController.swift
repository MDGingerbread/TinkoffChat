//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 27.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit


class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CommunicationManagerDelegate, ConversationViewControllerDelegate {

    let cellId = "CellId"
    
    var dataChat = [Chat]()
    
    var dataHistory = [Chat]()
    
    var arrayUsers = [String: Chat]()
    
    var arrayUsersAtIndexPath = [String]()
    
    let communicationManager = CommunicationManager.getInstance()
    
    var userIDName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        communicationManager.delegate = self
    }

    private func deleteUserFromTable(byUserID:String) {
        if let _ = self.arrayUsers[byUserID] {
            if let i = self.arrayUsersAtIndexPath.index(where: { $0 == byUserID }) {
                self.arrayUsersAtIndexPath.remove(at: i)
                self.arrayUsers.removeValue(forKey: byUserID)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func conversationViewController(lostUser withID: String) {
        self.deleteUserFromTable(byUserID: withID)
    }
    
    func communicationManager(lostUser userID: String) {
        self.deleteUserFromTable(byUserID: userID)
    }
    
    func communicationManager(foundUser userID: String, withUserName: String?) {
        let user = Chat(name: withUserName!, lastMessage: Message(), isOnline: true, dateLastMessage: Date().timeIntervalSinceNow, isRead: true, userID: userID)
        self.arrayUsers[userID] = user
        self.arrayUsersAtIndexPath.append(userID)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func communicationManager(receiveMessage message: String, fromUser userId: String) {
        if let user = arrayUsers[userId] {
            user.lastMessage = Message(message: message, fromTo: 2)
            user.isRead = false
            arrayUsers[userId] = user
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section % 2 == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return self.arrayUsersAtIndexPath.count
        } else {
            return self.dataHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationsViewController", let destination = segue.destination as? ConversationViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let userID = self.arrayUsersAtIndexPath[indexPath.row]
                destination.userID = userID
                destination.navigationItem.title = self.arrayUsers[userID]?.name
                destination.delegate = self
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section % 2 == 0 {
            let userID = self.arrayUsersAtIndexPath[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ConversationTableViewCell
            
            cell.imageProfile.layer.cornerRadius = 25
            
            cell.imageProfile.layer.masksToBounds = true
            
            cell.name.text = self.arrayUsers[userID]?.name
            
            cell.lastMessage.text = self.arrayUsers[userID]?.lastMessage.getMessage()
            
            cell.dateOfLastMessage.text = self.arrayUsers[userID]?.dateLastMessage?.timeAgoDisplay()
            
            if (self.arrayUsers[userID]?.isOnline)! {
                cell.backgroundColor = UIColor.yellow
            }
            
            if (self.arrayUsers[userID]?.isRead)! {
                cell.lastMessage.font =  UIFont.boldSystemFont(ofSize: 16.0)
            }
            
            return cell

        }  else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ConversationTableViewCell
            
            cell.imageProfile.layer.cornerRadius = 25
            
            cell.imageProfile.layer.masksToBounds = true
            
            cell.name.text = self.dataHistory[indexPath.row].name
            
            cell.lastMessage.text = self.dataHistory[indexPath.row].lastMessage.getMessage()
            
            cell.dateOfLastMessage.text = self.dataHistory[indexPath.row].dateLastMessage?.timeAgoDisplay()
            
            if self.dataHistory[indexPath.row].isOnline {
                cell.backgroundColor = UIColor.yellow
            }
            
            if self.dataHistory[indexPath.row].isRead {
                cell.lastMessage.font =  UIFont.boldSystemFont(ofSize: 16.0)
            }
            
            cell.isSelected = false
            
            cell.isUserInteractionEnabled = false 
            
            return cell
        }
    }
}
 
