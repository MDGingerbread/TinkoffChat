//
//  OperationDataManager..swift
//  Tinkoff Chat
//
//  Created by Admin on 02.04.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit


class OperationSaveDataManager: Operation {
    
    private var settingsUser = SettingsUser()
    
    private var value: [String:Any]
    
    private var successCompletionHandler: () -> Void
    
    private var errorCompletionHandler: () -> Void
    
    init(value: [String: Any], settingsUser: SettingsUser, successCompletionHandler: @escaping () -> Void, errorCompletionHandler: @escaping () -> Void) {
        
        self.successCompletionHandler = successCompletionHandler
    
        self.errorCompletionHandler = errorCompletionHandler
        
        self.value = value
        
        self.settingsUser = settingsUser
    }
    
    override func main() {
    
        if self.isCancelled {
            return
        }
        
        self.saveData(value: self.value, successCompletionHandler: self.successCompletionHandler, errorCompletionHandler: self.errorCompletionHandler)
        
    }
    
    private func saveData(value:[String: Any], successCompletionHandler: @escaping () -> Void, errorCompletionHandler: @escaping () -> Void) {
            
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
            OperationQueue.main.addOperation {
                self.completionBlock = self.successCompletionHandler
            }
        } else {
            OperationQueue.main.addOperation {
                self.completionBlock = self.errorCompletionHandler
            }
        }
        
    }

}
