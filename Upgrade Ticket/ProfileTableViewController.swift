//
//  ProfileTableViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/13/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var fullNameButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    
    
    var nameTextfield : UITextField!
    var emailTextfield : UITextField!
    var phoneTextfiend : UITextField!
    var passwordTextfield : UITextField!
    var newPasswordTextfield : UITextField!
    var confirmPasswordTextfield : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetMember()
        UpdateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ChangeNameClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "You will change your name", message: "Please input your name and your password!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ChangeName()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
    
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.nameTextfield = textField
            self.nameTextfield?.placeholder = "Your new name"
        }
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.isSecureTextEntry = true
            self.passwordTextfield?.placeholder = "Your password"
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ChangePhoneClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "You will change your phone number", message: "Please input your new phone and your password!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ChangePhone()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.phoneTextfiend = textField
            self.phoneTextfiend?.placeholder = "Your new phone"
        }
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.isSecureTextEntry = true
            self.passwordTextfield?.placeholder = "Your password"
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func EmailClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "You will change your email", message: "Please input your email and password!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ChangeEmail()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.emailTextfield = textField
            self.emailTextfield?.placeholder = "Your new email"
        }
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.isSecureTextEntry = true
            self.passwordTextfield?.placeholder = "Your password"
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func PasswordClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "You will change your password", message: "Please input your old password and new password!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ChangePassword()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.passwordTextfield = textField
            self.passwordTextfield.isSecureTextEntry = true
            self.passwordTextfield?.placeholder = "Your old password"
        }
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.newPasswordTextfield = textField
            self.newPasswordTextfield.isSecureTextEntry = true
            self.newPasswordTextfield?.placeholder = "Your new password"
        }
        
        alert.addTextField{ (textField) -> Void in
            // Enter the textfiled customization code here.
            self.confirmPasswordTextfield = textField
            self.confirmPasswordTextfield.isSecureTextEntry = true
            self.confirmPasswordTextfield?.placeholder = "Your confirm password"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func ChangeName() {
        if nameTextfield.text == "" || passwordTextfield.text == "" {
            Alert("Invalid input!")
        } else {
            ChangeNameAPI()
        }
    }
    
    func ChangeEmail() {
        if emailTextfield.text == "" || passwordTextfield.text == "" {
            Alert("Invalid input!")
        } else {
            ChangeEmailAPI()
        }
    }
    
    func ChangePhone() {
        
        if phoneTextfiend.text == "" || passwordTextfield.text == "" {
            Alert("Invalid input!")
        } else {
            ChangePhoneAPI()
        }
    }
    
    func ChangePassword() {
        if passwordTextfield.text == "" || newPasswordTextfield.text == "" || confirmPasswordTextfield.text == "" {
            Alert("Invalid input!")
        } else if (newPasswordTextfield.text?.characters.count < 8) {
            Alert("Password must be min 8 alphanumeric")
        } else if (newPasswordTextfield.text != confirmPasswordTextfield.text) {
            Alert("New Password doesn't match")
        } else {
            ChangePasswordAPI()
        }
    }
    
    //MARK: - API
    func GetMember() {
        if let id = activeUser.value(forKey: "id") {
            let postParameter = "id=\(id)"
            let link = "http://rico.webmurahbagus.com/admin/API/GetMemberAPI.php"
            AjaxPost(link, parameter: postParameter, done: { data in
                do {
                    let user = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                    if let fullname = user![0]["fullname"] as? String {
                        activeUser.setValue(fullname, forKey: "name")
                    }
                    if let email = user![0]["email"] as? String {
                        activeUser.setValue(email, forKey: "email")
                    }
                    if let phone = user![0]["phone"] as? String {
                        activeUser.setValue(phone, forKey: "phone")
                    }
                    if let status = user![0]["status"] as? String {
                        activeUser.setValue(status, forKey: "status")
                    }
                    DispatchQueue.main.async(execute: {
                        self.UpdateData()
                    })
                } catch {
                    print("error")
                }
            })
        }
        
    }
    
    func ChangePasswordAPI() {
        if let id = activeUser.value(forKey: "id") {
            let processingAlert = self.ProcessingAlert("Processing . . .")
            let postParameter = "id=\(id)&old=\(passwordTextfield.text!)&new=\(newPasswordTextfield.text!)&confirm=\(confirmPasswordTextfield.text!)"
            print(postParameter)
            let link = "http://rico.webmurahbagus.com/admin/API/ChangePasswordAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                self.EndProcessingAlert(processingAlert, complete: {
                    if let result = String(data: data,encoding: String.Encoding.utf8) {
                        print(result)
                        if result == "1" {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Your new password has been saved!")
                                self.GetMember()
                                self.UpdateData()
                            })
                            
                        } else if result == "-1" {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Authorization Error")
                            })
                            
                        } else {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Server is not responding, please try again later!")
                            })
                            
                        }
                    }
                })
            })
        }
    }

    
    func ChangeNameAPI() {
        if let id = activeUser.value(forKey: "id") {
            let processingAlert = self.ProcessingAlert("Processing . . .")
            let postParameter = "id=\(id)&confirm=\(passwordTextfield.text!)&fullname=\(nameTextfield.text!)"
            let link = "http://rico.webmurahbagus.com/admin/API/ChangeFullnameAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                self.EndProcessingAlert(processingAlert, complete: {
                    if let result = String(data: data,encoding: String.Encoding.utf8) {
                        print(result)
                        if result == "1" {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Your new fullname has been saved!")
                                self.GetMember()
                                self.UpdateData()
                            })
                            
                        } else if result == "-1" {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Authorization Error")
                            })
                            
                        } else {
                            DispatchQueue.main.async(execute: {
                                self.Alert("Server is not responding, please try again later!")
                            })
                            
                        }
                    }

                })
            })
        }
    }
    
    func ChangeEmailAPI() {
        if let email = emailTextfield.text {
            let postParameter = "email=\(email)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekEmail.php"
            let processingAlert = self.ProcessingAlert("Processing . . .")
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseData)
                    if responseData == "1" {
                        DispatchQueue.main.async(execute: {
                            self.EndProcessingAlert(processingAlert, complete: {
                                self.Alert("Sorry, your email has been registered!")
                            })
                        })
                    } else {
                        if let id = activeUser.value(forKey: "id") {
                            let postParameter = "id=\(id)&confirm=\(self.passwordTextfield.text!)&email=\(email)"
                            let link = "http://rico.webmurahbagus.com/admin/API/ChangeEmailAPI.php"
                            self.AjaxPost(link, parameter: postParameter, done: { (data) in
                                self.EndProcessingAlert(processingAlert, complete: {
                                    if let result = String(data: data,encoding: String.Encoding.utf8) {
                                    print(result)
                                    if result == "1" {
                                        DispatchQueue.main.async(execute: {
                                            self.Alert("Your new email has been saved! Please check your inbox / spam for verification!")
                                            self.GetMember()
                                            self.UpdateData()
                                        })
                                    } else if result == "-1" {
                                        DispatchQueue.main.async(execute: {
                                            self.Alert("Authorization Error")
                                        })
                                        
                                    } else {
                                        DispatchQueue.main.async(execute: {
                                            self.Alert("Server is not responding, please try again later!")
                                        })
                                        
                                    }
                                }
                                })
                                
                            })
                        }
                    }
                }
            })
        }
    }
    
    func SMSAPI(idmember:String) {
        let postParameter = "id_member=\(idmember)"
        let link = "http://rico.webmurahbagus.com/admin/API/SMSAPI.php"
        
        AjaxPost(link, parameter: postParameter, done: { data in
            if let responseData = String(bytes: data, encoding: .utf8) {
                print(responseData)
                if responseData == "-600" {
                    
                }
            }
        })
    }
    
    func ChangePhoneAPI() {
        if let phone = phoneTextfiend.text {
            let postParameter = "phone=\(phone)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekPhone.php"
            let processingAlert = self.ProcessingAlert("Processing . . .")
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseData)
                    if responseData == "1" {
                        DispatchQueue.main.async(execute: {
                            self.EndProcessingAlert(processingAlert, complete: {
                                self.Alert("Sorry, your phone number has been registered!")
                            })
                        })
                    } else {
                        if let id = activeUser.value(forKey: "id") {
                            let postParameter = "id=\(id)&confirm=\(self.passwordTextfield.text!)&phone=\(phone)"
                            let link = "http://rico.webmurahbagus.com/admin/API/ChangePhoneAPI.php"
                            self.AjaxPost(link, parameter: postParameter, done: { (data) in
                                self.EndProcessingAlert(processingAlert, complete: {
                                    if let result = String(data: data,encoding: String.Encoding.utf8) {
                                        print(result)
                                        if result == "1" {
                                            DispatchQueue.main.async(execute: {
                                                if let destVC = self.storyboard?.instantiateViewController(withIdentifier: "confirmphone") as? ConfirmationPhoneViewController {
                                                    destVC.idmember = "\(id)"
                                                    self.SMSAPI(idmember: "\(id)")
                                                    self.show(destVC, sender: nil)
                                                }
                                                self.GetMember()
                                                self.UpdateData()
                                            })
                                        } else if result == "-1" {
                                            DispatchQueue.main.async(execute: {
                                                self.Alert("Authorization Error")
                                            })
                                            
                                        } else {
                                            DispatchQueue.main.async(execute: {
                                                self.Alert("Server is not responding, please try again later!")
                                            })
                                            
                                        }
                                    }
                                })
                                
                            })
                        }
                    }
                }
            })
        }
    }
    
    func UpdateData() {
        if let name = activeUser.value(forKey: "name") as? String {
            fullNameButton.setTitle(name, for: UIControlState())
        }
        if let status = activeUser.value(forKey: "status") as? String {
            var emailText = ""
            if let email = activeUser.value(forKey: "email") as? String {
                emailText += email
                
                if status == "-1" {
                    emailText += "(Not Verified)"
                }
            }
            emailButton.setTitle(emailText, for: UIControlState())
        }
        if let phone = activeUser.value(forKey: "phone") as? String {
            phoneButton.setTitle("+\(phone)", for: .normal)
        }
    }
    
}
