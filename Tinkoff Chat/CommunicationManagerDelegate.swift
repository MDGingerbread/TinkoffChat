//
//  CommunicationManagerDelegate.swift
//  Tinkoff Chat
//
//  Created by Admin on 11.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

protocol CommunicationManagerDelegate: class {
    
    func communicationManager(foundUser userID: String, withUserName: String?)
    func communicationManager(lostUser userID: String)
    func communicationManager(receiveMessage message: String, fromUser userId: String)
}


