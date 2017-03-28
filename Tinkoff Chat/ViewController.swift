//
//  ViewController.swift
//  Tinkoff Chat
//
//  Created by Admin on 07.03.17.
//  Copyright © 2017 Maxim Danko Dark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    
    var isChangeProfileImageView = false
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var colorText: UILabel!
    
    @IBOutlet weak var userDescription: UITextView!
   
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBAction func changeColorAction(_ sender: Any) {
        
        guard let button = sender as? UIButton else {
            return
        }
        
        colorText.textColor = button.backgroundColor
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        print("Сохранение данных профиля")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        
        userName.returnKeyType = .done
        
        userDescription.delegate = self
        
        userDescription.returnKeyType = .done
        
        userProfileImageView.isUserInteractionEnabled = true
        
        let chooseImage = UITapGestureRecognizer(target: self, action: #selector(self.chooseImage))
        
        userProfileImageView.addGestureRecognizer(chooseImage)
        
        imagePicker.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func chooseFromLibrary() {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        
        imagePicker.allowsEditing = false
        
        imagePicker.sourceType = .camera
        
        imagePicker.cameraCaptureMode = .photo
        
        imagePicker.modalPresentationStyle = .fullScreen
        
        imagePicker.allowsEditing = true

        
        present(imagePicker,animated: true,completion: nil)
    }
    
    func chooseImage() {
        let choseAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let actionChooseFromLibrary = UIAlertAction(title: "Выбрать из галлереи", style: .default, handler: { action in
            self.chooseFromLibrary()
        })
        
        choseAlertController.addAction(actionChooseFromLibrary)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let actionTakePhoto = UIAlertAction(title: "Сделать фото", style: .default, handler: {action in
                self.takePhoto()
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var  chosenImage = UIImage()
        
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        userProfileImageView.contentMode = .scaleAspectFit
        
        userProfileImageView.image = chosenImage
        
        isChangeProfileImageView = true
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

