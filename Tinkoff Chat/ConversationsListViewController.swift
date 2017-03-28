//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 27.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit


class ConversationsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellId = "CellId"
    
    var dataChat = [Chat]()
    
    var dataHistory = [Chat]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        self.dataChat.append(Chat(name:"Vlad", date: "", lastMessage: Message(message:"Hello World"), isOnline: true, dateLastMessage: 1000, isRead: false ))
        
        self.dataChat.append(Chat(name:"Vlad", date: "", lastMessage: Message(message:"I am student"), isOnline: false, dateLastMessage: 30, isRead: false ))
        
        self.dataChat.append(Chat(name:"Vlad", date: "", lastMessage: Message(message:"I am from Russia"), isOnline: false, dateLastMessage: 20, isRead: true ))
        
        self.dataChat.append(Chat(name:"Vlad", date: "", lastMessage: Message(message: "Gread Britan is the capital of Great Britania"), isOnline: true, dateLastMessage: 10 , isRead: true ))
        
        self.dataChat.append(Chat(name:"Vlad", date: "", lastMessage: Message(), isOnline: true, dateLastMessage: 400, isRead: true ) )
        
        self.dataChat.append(Chat(name:"Vlad Denis", date: "", lastMessage: Message(message:"I am from Russia"), isOnline: false, dateLastMessage: 20, isRead: false ))
        
        self.dataChat.append(Chat(name:"Vlad Igor", date: "", lastMessage: Message(message: "Gread Britan is the capital of Great Britania"), isOnline: true, dateLastMessage: 10 , isRead: true ))
        
        self.dataChat.append(Chat(name:"Vlad Ivanov", date: "", lastMessage: Message(), isOnline: true, dateLastMessage: 400, isRead: true ) )
        
        self.dataChat.append(Chat(name:"Vlad Petrov", date: "", lastMessage: Message(message:"I am from Russia"), isOnline: false, dateLastMessage: 20, isRead: true ))
        
        self.dataChat.append(Chat(name:"Vlad Maximov", date: "", lastMessage: Message(message: "Gread Britan is the capital of Great Britania"), isOnline: false, dateLastMessage: 10 , isRead: true ))
        
        self.dataChat.append(Chat(name:"Julian Vladimirov", date: "", lastMessage: Message(), isOnline: true, dateLastMessage: 400, isRead: true ) )
        
        self.dataHistory.append(Chat(name:"Julian Vladimirov", date: "", lastMessage: Message(message: "Maxim Maxim"), isOnline: false, dateLastMessage: 400, isRead: true ) )
        self.dataHistory.append(Chat(name:"Julian Vladimirov", date: "", lastMessage: Message(message:"Maxim Danko"), isOnline: true, dateLastMessage: 400, isRead: true ) )
        self.dataHistory.append(Chat(name:"Julian Vladimirov", date: "", lastMessage: Message(message:"Maxim Maxim Maxim"), isOnline: false, dateLastMessage: 400, isRead: true ) )
        
        
    }
    
    
    func prepareData() {
        


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
            return self.dataChat.count
        } else {
            return self.dataHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ConversationsViewController", let destination = segue.destination as? ConversationViewController {
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                
                destination.messages.append(Message(message: "1"))
                destination.messages.append(Message(message: "ghbdtn fkgdjkfs lkdfksdl  kfjdk"))
                destination.messages.append(Message(message: "ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfksdl  kfjdk ghbdtn fkgdjkfs lkdfk"))
                
                destination.navigationItem.title = self.dataChat[indexPath.row].name
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ConversationTableViewCell
            
            cell.imageProfile.layer.cornerRadius = 25
            
            cell.imageProfile.layer.masksToBounds = true
            
            cell.name.text = self.dataChat[indexPath.row].name
            
            cell.lastMessage.text = self.dataChat[indexPath.row].lastMessage.getMessage()
            
            cell.dateOfLastMessage.text = self.dataChat[indexPath.row].dateLastMessage?.timeAgoDisplay()
            
            if self.dataChat[indexPath.row].isOnline {
                cell.backgroundColor = UIColor.yellow
            }
            
            if self.dataChat[indexPath.row].isRead {
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
