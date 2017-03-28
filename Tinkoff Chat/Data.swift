//
//  Data.swift
//  Tinkoff Chat
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

extension Date {
    
    func timeAgoDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        
        let hour = 60 * minute
        
        let day = 24 * hour
        
        let week = 7 * day
        
        if secondsAgo < minute {
            
            return "\(secondsAgo) секунд назад"
            
        } else if secondsAgo < hour {
            
            return "\(secondsAgo / minute) минут назад"
            
        } else if secondsAgo < day {
            
            return "\(secondsAgo / hour) часов назад"
            
        } else if secondsAgo < week {
            
            return "\(secondsAgo / day) дней назад"
        }
        
        return "\(secondsAgo / week) недель назад"
    }
}

