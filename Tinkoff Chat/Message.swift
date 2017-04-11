//
//  Message.swift
//  Tinkoff Chat
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import Foundation



class Message {
    var message: String? = nil
    var fromTo: Int = 0
    
    init(message:String, fromTo: Int) {
        self.message = message
        self.fromTo = fromTo
    }
    
    init() {}
    
    func getMessage()  -> String {
        if let message = self.message {
            return message
        } else {
            return "No messages yet"
        }
        
    }
    
}


class Chat: NSObject {
    
    var name: String?
    
    var date: String?
    
    var userID: String?
    
    var isOnline: Bool = false
    
    var isRead: Bool = false
    
    var dateLastMessage: Date?
    
    var lastMessage: Message = Message(message: "", fromTo:1)
    
    init(name:String, lastMessage: Message, isOnline: Bool, dateLastMessage: Double, isRead: Bool, userID: String) {
        
        self.name = name
        
        self.lastMessage = lastMessage
        
        self.isOnline = isOnline
        
        self.dateLastMessage = Date(timeIntervalSinceNow:  (-1) * dateLastMessage)
        
        self.isRead = isRead
        
        self.userID = userID
    }

    
}
