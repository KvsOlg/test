//
//  CreateContactViewController.swift
//  StarTask
//
//  Created by Oleh Kvasha on 12/28/19.
//  Copyright © 2019 Kvasha Oleh. All rights reserved.
//

import UIKit

protocol UpdateContactListDelegate: AnyObject {
    func updateContactList(with contact: Contact)
}

protocol EditContactListDelegate: AnyObject {
    func editContactList(with contact: Contact)
}

enum TypeViewController {
    case edit
    case create
}

class CreateContactViewController: UIViewController {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectTypePhoneTextField: UITextField!
    
    var type: TypeViewController = .create
    var personContact : Contact?
    
    weak var delegateUpdate : UpdateContactListDelegate?
    weak var delegateEdit : EditContactListDelegate?
    
    var typePhoneNumber = ["home", "work"]
    var selectedPhoneType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = cancelButton.frame.height / 2
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        createTypePhonePicker()
        createToolbar()
        defaultValue()
        setupView()
    }
    
    func setupView() {
        if type == .create {
            titleLable.text = "New contact"
        } else {
            titleLable.text = "Edit contact"
            nameTextField.text = personContact?.name
            surnameTextField.text = personContact?.surname
            phoneNumberTextField.text = personContact?.phoneNumber
            selectTypePhoneTextField.text = personContact?.phoneType
            
        }
    }
    
    func createTypePhonePicker() {
        let typePhone = UIPickerView()
        typePhone.delegate = self
        selectTypePhoneTextField.inputView = typePhone
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        selectTypePhoneTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveAndClose(_ sender: UIButton) {

        if phoneNumberTextField.text?.count != 0, nameTextField.text?.count != 0 {
            guard let name = nameTextField.text else {return}
            guard let number = phoneNumberTextField.text else {return}
            guard let phoneType = selectTypePhoneTextField.text else {return}
            
            let uuid = UUID().uuidString
            print("uuid 1 is \(uuid)")
            
            if personContact == nil {
                personContact = Contact(name: name, surname: surnameTextField.text, phoneNumber: number, phoneType: phoneType, id: uuid)
            } else {
                personContact?.name = name
                personContact?.surname = surnameTextField.text
                personContact?.phoneNumber = number
                personContact?.phoneType = phoneType
            }
            
            guard let contact = personContact else {return}
            delegateEdit?.editContactList(with: contact)
            delegateUpdate?.updateContactList(with: contact)
            self.dismiss(animated: true)
        } else {
            showErrorAlert()
            nameTextField.placeholder = "Enter your name correct"
            phoneNumberTextField.placeholder = "Enter your number correct"
        }
        
        if type == .edit {
            let array : [String : Contact] = ["newCont" : personContact!]
            let notificationName = Notification.Name(rawValue: "newContact")
            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: array)
            
        } else {
            return
        }
    }
    
    // custom alert method (from Ann)
    public func showErrorAlert() {
        let alert = UIAlertController(title: "Fill in the required fields", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                break
            case .cancel:
                break
            case .destructive:
                break
            @unknown default:
                break
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension CreateContactViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePhoneNumber.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typePhoneNumber[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPhoneType = typePhoneNumber[row]
        selectTypePhoneTextField.text = selectedPhoneType
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 17)
        label.text = typePhoneNumber[row]
        return label
    }
    
    func defaultValue() {
        if selectTypePhoneTextField.text!.isEmpty {
            selectTypePhoneTextField.text = typePhoneNumber[0]
        }
    }
    
}
