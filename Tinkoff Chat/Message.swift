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
 
    init(message:String) {
        
        self.message = message
        
    }
    
    init() {
    
    }
    
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
    
    var isOnline: Bool = false
    
    var isRead: Bool = false
    
    var dateLastMessage: Date?
    
    var lastMessage: Message = Message(message: "")
    
    init(name:String, date: String, lastMessage: Message, isOnline: Bool, dateLastMessage: Double, isRead: Bool) {
        
        self.name = name
        
        self.date = date
        
        self.lastMessage = lastMessage
        
        self.isOnline = isOnline
        
        self.dateLastMessage = Date(timeIntervalSinceNow:  (-1) * dateLastMessage)
        
        self.isRead = isRead
    }

    
}
