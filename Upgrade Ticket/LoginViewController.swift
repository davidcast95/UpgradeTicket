//
//  LoginViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
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


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton:UIButton!
    var lastVC:UIViewController!
    
    var postParameter = ""
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //SetUpTextField()
        if (activeUser.value(forKey: "id") != nil) {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Textfield
    func SetUpTextField() {
        let frame = CGRect(x: 0, y: usernameTextField.frame.height-4, width: usernameTextField.bounds.width, height: 4)
        let borderdown = UIView(frame: frame)
        borderdown.backgroundColor = UIColor.white
        usernameTextField.addSubview(borderdown)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponded = textField.superview?.viewWithTag(nextTag) {
            nextResponded.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
            CloseInputView()
            self.Login(loginButton)
        }
        return true
    }

    //MARK: Action
    @IBAction func ForgotPasswordTap(_ sender: AnyObject) {
        if let forgotVC = storyboard?.instantiateViewController(withIdentifier: "forgotpassword") {
            if let nav = self.navigationController {
                nav.pushViewController(forgotVC, animated: true)
            } else {
                self.show(forgotVC, sender: nil)
            }
        }
    }
    @IBAction func Login(_ sender: UIButton) {
        var flag = true
        if (usernameTextField.text == "") {
            usernameTextField.Required()
            flag = false
        }
        if (passwordTextField.text == "") {
            passwordTextField.Required()
            flag = false
        }
        if (passwordTextField.text?.characters.count < 8) {
            passwordTextField.PasswordInvalid()
            flag = false
        }
        
        if (flag) {
            LoginAPI()
        }
        
    }
    @IBAction func CancelPressed(_ sender: UIButton) {
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func BackToLogin(_ segue:UIStoryboardSegue) {
    }
    
    //MARK: Input
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }

    
    
    //MARK: Function
    func SetLastVC(_ vc:UIViewController) {
        lastVC = vc
    }
    func InvalidUser() {
        usernameTextField.text = ""
        usernameTextField.Invalid("Invalid username")
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        usernameTextField.layer.borderWidth = 1.0;
        usernameTextField.layer.cornerRadius = 5.0;
        passwordTextField.text = ""
        passwordTextField.Invalid("Invalid password")
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1.0;
        passwordTextField.layer.cornerRadius = 5.0;
    }
    func Dismiss() {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: API
    func LoginAPI() {
        
        self.indicator.startAnimating()
        if let username = usernameTextField.text, let password = passwordTextField.text {
            postParameter = "username=\(username)&password=\(password)"
        
            print(postParameter)
            let link = "http://rico.webmurahbagus.com/admin/API/LoginAPI.php"
            AjaxPost(link, parameter: postParameter,
                done: { (data) in
                    do {
                        let user = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                        if user?.count == 0 {
                            DispatchQueue.main.async(execute: {
                                self.indicator.stopAnimating()
                                self.InvalidUser()
                            })
                        } else {
                            if let id = user![0]["id_member"] as? String {
                                activeUser.setValue(id, forKey: "id")
                            }
                            if let fullname = user![0]["fullname"] as? String {
                                activeUser.setValue(fullname, forKey: "name")
                            }
                            if let email = user![0]["email"] as? String {
                                activeUser.setValue(email, forKey: "email")
                            }
                            if let status = user![0]["status"] as? String {
                                activeUser.setValue(status, forKey: "status")
                            }
                            
                            DispatchQueue.main.async(execute: {
                                self.indicator.stopAnimating()
                                self.Dismiss()
                            })
                            
                        }
                        
                    } catch {
                        print("error")
                    }

                },
                error: {
                    self.indicator.stopAnimating()
                    self.Alert("Please check your internet connection!")
                })
        }

    }
    

}
