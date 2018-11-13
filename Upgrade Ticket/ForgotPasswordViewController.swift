//
//  ForgotPasswordViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: DefaultUITextField!
    var validEmail = false
    var sessionID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func EmailDidEnd(_ sender: AnyObject) {
        if let emailval = email.text {
            if emailval.IsValidEmail() {
                let postParameter = "email=\(emailval)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekVerifiedEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseData)
                        if responseData == "0" {
                            DispatchQueue.main.async(execute: {
                                self.email.Invalid("Email is not registered")
                                self.validEmail = false
                            })
                            
                        } else {
                            self.validEmail = true
                            self.sessionID = responseData
                        }
                    }
                })
            } else {
                self.validEmail = false
                email.Invalid("Invalid email")
            }
        }
    }
    
    @IBAction func ResetPasswordTap(_ sender: AnyObject) {
        if let emailval = email.text {
            if emailval.IsValidEmail() {
                let postParameter = "email=\(emailval)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekVerifiedEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseData)
                        if responseData == "0" {
                            DispatchQueue.main.async(execute: {
                                self.email.Invalid("Email is not registered")
                                self.validEmail = false
                            })
                            
                        } else {
                            var sending = UIAlertController()
                            DispatchQueue.main.async(execute: {
                                sending = self.ProcessingAlert("Sending request...")
                            })
                            self.validEmail = true
                            self.sessionID = responseData
                            self.AjaxPost("http://rico.webmurahbagus.com/admin/API/ResetPasswordMailAPI.php", parameter: "id=\(self.sessionID)", done: { (data) in
                                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                                    DispatchQueue.main.async(execute: {
                                        self.EndProcessingAlert(sending, complete: {
                                            if responseData == "1" {
                                                if let successVC = self.storyboard?.instantiateViewController(withIdentifier: "forgotpasswordsuccess") {
                                                    self.show(successVC, sender: nil)
                                                }
                                            } else {
                                                self.Alert("Error occured!")
                                            }
                                        })
                                        
                                    })
                                }
                                
                            })
                        }
                    }
                })
            } else {
                self.validEmail = false
                email.Invalid("Invalid email")
            }
        }

    }

    @IBAction func CancelTap(_ sender: AnyObject) {
        if let nav = self.navigationController {
                nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
