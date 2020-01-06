//
//  ViewController.swift
//  StarTask
//
//  Created by Oleh Kvasha on 12/28/19.
//  Copyright © 2019 Kvasha Oleh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts : [Contact] = []
    
    var newContact : ContactDetailsViewController?

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateContact(_:)), name: NSNotification.Name(rawValue: "newContact"), object: nil)
        
    }
    
    @objc func updateContact(_ notification: NSNotification) {
        if let contact = notification.userInfo?["newCont"] as? Contact {
            
            self.contacts.append(contact)
            tableView.reloadData()
        }
    }
    
 

    @IBAction func addNewContact(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createContactViewController = storyboard.instantiateViewController(withIdentifier: "CreateContactViewController") as! CreateContactViewController
        createContactViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        createContactViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        createContactViewController.delegateUpdate = self
        self.present(createContactViewController, animated: true, completion: nil)
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let item = contacts[indexPath.row]
        cell.nameAndSurname.text = "\(item.name)" + " " + "\(item.surname ?? "")"
        cell.phoneNumber.text = item.phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ContactDetailsViewController") as! ContactDetailsViewController
        nextViewController.contact = contacts[indexPath.row]
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 12
    }
}

extension ViewController: UpdateContactListDelegate {
    func updateContactList(with contact: Contact) {
        contacts.append(contact)
        tableView.reloadData()
    }
}


