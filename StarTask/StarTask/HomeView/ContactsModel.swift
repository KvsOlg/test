//
//  ContactsModel.swift
//  StarTask
//
//  Created by Oleh Kvasha on 12/28/19.
//  Copyright © 2019 Kvasha Oleh. All rights reserved.
//

import Foundation

class Contact {
    var name : String
    var surname : String?
    var phoneNumber : String
    var phoneType : String
    
    
    init(name: String, surname : String?, phoneNumber : String, phoneType : String) {
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.phoneType = phoneType
    }
}
