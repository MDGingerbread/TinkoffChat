//
//  Communicator.swift
//  Tinkoff Chat
//
//  Created by Admin on 07.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CommunicationManager: CommunicatorDelegate{
    
    private let _multipeerCommunicator = MultipeerCommunicator.getInstance()
    
    weak var delegate : CommunicationManagerDelegate?
    
    private static let instance =  CommunicationManager()
    
    static func getInstance() -> CommunicationManager {

        return instance
        
    }
    
    private init() {
        self._multipeerCommunicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        delegate?.communicationManager(foundUser: userID,  withUserName: userName)
    }
    
    func didLostUser(userID: String) {
        delegate?.communicationManager(lostUser: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
    }
    
    func failedToStartAdvertising(error: Error) {
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.communicationManager(receiveMessage: text, fromUser: fromUser)
    }
    
}

