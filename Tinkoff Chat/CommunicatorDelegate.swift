//
//  CommunicatorDelegate.swift
//  Tinkoff Chat
//
//  Created by Admin on 11.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

protocol CommunicatorDelegate: class {
    
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
