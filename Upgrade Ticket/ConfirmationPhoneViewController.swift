//
//  ConfirmationPhoneViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 9/17/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class ConfirmationPhoneViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var codeLine: UIStackView!
    @IBOutlet weak var resendCode: UIButton!
    var idmember = "0"
    var timer = Timer()
    var timeRemainInSeconds = 300
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemaining.text = "\(self.timeRemainInSeconds.timerFormat) to resend code"
        resendCode.isHidden = true
        resendCode.isEnabled = false
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                self.UpdateTimer()
            })
        } else {
            // Fallback on earlier versions
            
        }
        var tagCount = 0
        for subview in codeLine.subviews {
            if let textview = subview as? UITextField {
                textview.tag = tagCount
                textview.delegate = self
                tagCount += 1
                textview.addTarget(self, action: #selector(CodeInput(sender:)), for: .editingDidBegin)
                textview.addTarget(self, action: #selector(CodeChange(sender:)), for: .editingChanged)
                textview.addTarget(self, action: #selector(CodeEnd(sender:)), for: .editingDidEnd)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : Function
    func CodeInput(sender: UITextField) {
        sender.text = ""
    }
    func CodeChange(sender: UITextField) {
        let nextTag = sender.tag + 1
        if nextTag >= 6 {
            var code = ""
            for subview in codeLine.subviews {
                if let textview = subview as? UITextField {
                    code += textview.text!
                }
            }
            CheckCode(code: code)
        }
        if let nextResponder = sender.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            sender.resignFirstResponder()
        }

    }
    func CodeEnd(sender: UITextField) {
        if sender.text == "" {
            sender.text = "0"
        }
    }
    
    func UpdateTimer() {
        if (timeRemainInSeconds > 0) {
            resendCode.isHidden = true
            resendCode.isEnabled = false
            timeRemainInSeconds -= 1
            timeRemaining.text = "\(self.timeRemainInSeconds.timerFormat) to resend code"
        } else {
            
            resendCode.isHidden = false
            resendCode.isEnabled = true
        }
    }
    

    //MARK : Action
    @IBAction func ResendCodeClick(_ sender: AnyObject) {
        tryattemp += 1
        timeRemainInSeconds = 100 * tryattemp
        resendCode.isHidden = true
        resendCode.isEnabled = false
        ResendUniqueCodeAPI()
    }
    
    //MARK : Connectivity
    func SMSAPI() {
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
    
    func ResendUniqueCodeAPI() {
        let postParameter = "id_member=\(idmember)"
        let link = "http://rico.webmurahbagus.com/admin/API/ResendUniqueCodeAPI.php"
        
        AjaxPost(link, parameter: postParameter, done: { data in
            if let responseData = String(bytes: data, encoding: .utf8) {
                print(responseData)
                if responseData == "1" {
                    self.SMSAPI()
                }
            }
        })
    }
    
    func CheckCode(code:String) {
        
        let processingAlert = self.ProcessingAlert("Processing . . .")
        let postParameter = "id_member=\(idmember)&unique_code=\(code)"
        print(postParameter)
        let link = "http://rico.webmurahbagus.com/admin/API/CheckUniqueCodeAPI.php"
        AjaxPost(link, parameter: postParameter, done: { data in
            self.EndProcessingAlert(processingAlert, complete: {
                if let responseData = String(bytes: data, encoding: .utf8) {
                    if responseData != "0"  {
                        if activeUser.value(forKey: "id") == nil {
                            if let destVC = self.storyboard?.instantiateViewController(withIdentifier: "confirmationemail") as? ConfirmationEmailViewController {
                                destVC.username = responseData
                                self.present(destVC, animated: true, completion: nil)
                            }
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                }
                else {
                    self.Alert("Code is invalid!")
                }
            })
            
        })

    }
}
