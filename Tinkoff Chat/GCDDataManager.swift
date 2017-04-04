//
//  GCDDataManager.swift
//  Tinkoff Chat
//
//  Created by Admin on 02.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

class GCDDataManager {
    
    let settingsUser = SettingsUser()
    
    func readData(completionHandler: @escaping (_ oldValue: [String:Any], _ settingsUser:SettingsUser) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            
            if let userNameText = self.settingsUser.defaults.object(forKey: "userName") as? String {
                self.settingsUser.oldValue["userName"] = userNameText
            }
            
            if let userDescriptionText = self.settingsUser.defaults.object(forKey: "userDescription") as? String {
                self.settingsUser.oldValue["userDescription"] = userDescriptionText
            }
            
            if let userProfileImage = self.settingsUser.defaults.object(forKey: "userProfileImage") as? Data {
                self.settingsUser.oldValue["userProfileImage"] = userProfileImage
            } else {
                self.settingsUser.oldValue["userProfileImage"] = UIImageJPEGRepresentation(UIImage(named:"defaultProfileImageView")!, 1)
            }
            
            if let color = self.settingsUser.defaults.object(forKey: "colorText") as? Data {
                self.settingsUser.oldValue["colorText"] = color
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                completionHandler(self.settingsUser.oldValue, self.settingsUser)
                
            })
        }
        
    }
    
    func saveData(value:[String: Any], successCompletionHandler: @escaping () -> Void, errorCompletionHandler: @escaping () -> Void) {
        
        let queue = DispatchQueue.global(qos: .background)
        
        queue.async {
            
            if self.settingsUser.oldValue["userName"] as? String != value["userName"] as? String {
                self.settingsUser.defaults.set(value["userName"], forKey: "userName")
            }
            
            if self.settingsUser.oldValue["userDescription"] as? String != value["userDescription"] as? String {
                self.settingsUser.defaults.set(value["userDescription"], forKey: "userDescription")
            }
            
            if self.settingsUser.oldValue["userProfileImage"] as? Data != value["userProfileImage"] as? Data {
                self.settingsUser.defaults.set(value["userProfileImage"] as? Data, forKey: "userProfileImage")
            }
            
            if self.settingsUser.oldValue["colorText"] as? Data != value["colorText"] as? Data {
                self.settingsUser.defaults.set(value["colorText"] as? Data, forKey: "colorText")
            }
            
            if self.settingsUser.defaults.synchronize() {
                DispatchQueue.main.async {
                    successCompletionHandler()
                }
            } else {
                DispatchQueue.main.async {
                    errorCompletionHandler()
                }
            }
            
        }
    }
    
}
