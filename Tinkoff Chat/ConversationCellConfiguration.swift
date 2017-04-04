//
//  ConversationCellConfiguration.swift
//  Tinkoff Chat
//
//  Created by Admin on 02.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration {

    var name: String? {get set}
    var message: String? {get set}
    var date: String? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
