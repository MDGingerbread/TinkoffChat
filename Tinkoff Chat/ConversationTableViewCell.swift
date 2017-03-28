//
//  ConversationTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Admin on 27.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit


class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!

    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var dateOfLastMessage: UILabel!
    
}
