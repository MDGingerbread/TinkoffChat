//
//  Communicator.swift
//  Tinkoff Chat
//
//  Created by Admin on 11.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

protocol Communicator {
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    
    weak var delegate : CommunicatorDelegate? {get set}
    
    var online: Bool {get set}
}

