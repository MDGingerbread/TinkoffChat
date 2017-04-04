//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

class SettingsUser {
    
    let defaults = UserDefaults.standard
    
    var oldValue = [String: Any]()

}

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var gcdButton: UIButton!
    
    @IBOutlet weak var operationButton: UIButton!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var colorText: UILabel!
    
    @IBOutlet weak var userDescription: UITextView!
   
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBAction func changeColorAction(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        colorText.textColor = button.backgroundColor
        self._changeEnabled(state: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.check = true
        self._saveData()
    }
    
    @IBAction func saveDataWithOpeation(_ sender: Any) {
        self.check = false
        self._saveDataWithOperation()
    }
    
    var isChangeProfileImageView = false
    
    let imagePicker = UIImagePickerController()
    
    let defaults = UserDefaults.standard
    
    var check: Bool?
    
    var oldValue = [String: Any]()
    
    var settingsUser: SettingsUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        userName.delegate = self
        
        userName.returnKeyType = .done
        
        userDescription.delegate = self
        
        userDescription.returnKeyType = .done
        
        self._changeEnabled(state: false)
        
        userProfileImageView.isUserInteractionEnabled = true
        
        let chooseImage = UITapGestureRecognizer(target: self, action: #selector(self.chooseImage))
        
        userProfileImageView.addGestureRecognizer(chooseImage)
        
        imagePicker.delegate = self
        
        let manager = GCDDataManager()
        
        manager.readData { (data, userSetting) in
            self.activityIndicator.stopAnimating()
            self.userName.text = data["userName"] as? String
            self.userDescription.text = data["userDescription"] as? String
            
            if let userProfileImage = data["userProfileImage"] as? Data {
                self.userProfileImageView.image = UIImage(data: userProfileImage)
            }
            
            if let color = data["colorText"] as? Data {
                self.colorText.textColor = NSKeyedUnarchiver.unarchiveObject(with: color) as? UIColor
            }
            
            self.settingsUser = userSetting
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var  chosenImage = UIImage()
        
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        userProfileImageView.contentMode = .scaleAspectFit
        
        userProfileImageView.image = chosenImage
        
        isChangeProfileImageView = true
        
        self._changeEnabled(state: true)
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.settingsUser?.oldValue["userName"] as? String != textField.text {
            self._changeEnabled(state: true)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if self.settingsUser?.oldValue["userName"] as? String != textView.text {
                self._changeEnabled(state: true)
            }

            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func chooseImage() {
        let choseAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let actionChooseFromLibrary = UIAlertAction(title: "Выбрать из галлереи", style: .default, handler: { action in
            self._chooseFromLibrary()
        })
        
        choseAlertController.addAction(actionChooseFromLibrary)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let actionTakePhoto = UIAlertAction(title: "Сделать фото", style: .default, handler: {action in
                self._takePhoto()
            })
            choseAlertController.addAction(actionTakePhoto)
        }
        
        if isChangeProfileImageView {
            let actionDeletePhoto = UIAlertAction(title: "Удалить фото", style: .default, handler: {action in
                self.userProfileImageView.image = UIImage(named: "defaultProfileImageView")
                self.isChangeProfileImageView = false
            })
            choseAlertController.addAction(actionDeletePhoto)
        }
        
        
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        choseAlertController.addAction(actionCancel)
        
        present(choseAlertController, animated: true, completion: nil)
    }
    
    private func _chooseFromLibrary() {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func _takePhoto() {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .camera
        
        imagePicker.cameraCaptureMode = .photo
        
        imagePicker.modalPresentationStyle = .fullScreen
        
        imagePicker.allowsEditing = true

        
        present(imagePicker,animated: true,completion: nil)
    }
    
    private func _showSuccessSaveAlert() {
        
        let alert = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(actionOk)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func _showErrorSaveAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        let action1 = UIAlertAction(title: "Повторить", style: .default) { (action) in
            
            if self.check! {
                self._saveData()
            } else {
                self._saveDataWithOperation()
            }
           
        }
        
        alert.addAction(actionOk)
        
        alert.addAction(action1)
        
        present(alert, animated: true, completion: nil)

    }
    
    private func _saveDataWithOperation() {
        var value = [String:Any]()
        
        let colorData = NSKeyedArchiver.archivedData(withRootObject: colorText.textColor)
        
        if let image = userProfileImageView.image {
            let dataImage = UIImageJPEGRepresentation(image, 1)
            value["userProfileImage"] = dataImage
        }
        
        value["userName"] = userName.text
        
        value["userDescription"] = userDescription.text
        
        value["colorText"] = colorData
        
        self._changeEnabled(state: false)
        
        self.activityIndicator.startAnimating()
        
        let operation = OperationSaveDataManager(value: value, settingsUser: self.settingsUser!, successCompletionHandler: {
            self.activityIndicator.stopAnimating()
            self._showSuccessSaveAlert()
                    }) {
            self._showErrorSaveAlert()
            self.activityIndicator.stopAnimating()
        }
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInteractive
        operationQueue.addOperation(operation)

    }
    
    private func _saveData() {
        let manager = GCDDataManager()
        
        self.activityIndicator.startAnimating()
        
        var value = [String:Any]()
        
        let colorData = NSKeyedArchiver.archivedData(withRootObject: colorText.textColor)
        
        if let image = userProfileImageView.image {
            let dataImage = UIImageJPEGRepresentation(image, 1)
            value["userProfileImage"] = dataImage
        }
        
        value["userName"] = userName.text
        
        value["userDescription"] = userDescription.text
        
        value["colorText"] = colorData
        
        self._changeEnabled(state: false)
        
        manager.saveData(value: value, successCompletionHandler: {
            self.activityIndicator.stopAnimating()
            self._showSuccessSaveAlert()
        }) {
            self.activityIndicator.stopAnimating()
            self._showErrorSaveAlert()
        }

    }
    
    private func _changeEnabled(state: Bool) {
        gcdButton.isUserInteractionEnabled = state
        operationButton.isUserInteractionEnabled = state
    }
}
