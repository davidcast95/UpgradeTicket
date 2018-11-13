//
//  SignupViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/28/16.
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


class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var fullnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var phoneTextfield:UITextField!
    @IBOutlet weak var cancelButton: DefaultUIButton!
    var usernameInvalid = false
    var emailInvalid = false
    var keyboardHeight:CGFloat = 300
    var offsetScrollY:CGFloat = 0
    var isKeyboardShow = false
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        fullnameTextfield.delegate = self
        emailTextfield.delegate = self
        phoneTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmTextfield.delegate = self
        
//        if view.frame.width < 500 {
//            headerTitle.constant = 30
//            fieldHeaderTitle.constant = 0
//        } else {
//            headerTitle.constant = 58
//            fieldHeaderTitle.constant = 38
//            
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func UsernameDidEnd(_ sender: UITextField) {
        usernameInvalid = false
        if let username = usernameTextfield.text {
            let postParameter = "username=\(username)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekUsername.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseData)
                    if responseData == "1" {
                        DispatchQueue.main.async(execute: {
                            self.usernameTextfield.Invalid("Username has been used")
                        })
                        
                    }
                }
            })
        }
    }
    @IBAction func EmailDidEnd(_ sender: AnyObject) {
        if let email = emailTextfield.text {
            if email.IsValidEmail() {
                let postParameter = "email=\(email)"
                let link = "http://rico.webmurahbagus.com/admin/API/CekEmail.php"
                AjaxPost(link, parameter: postParameter, done: { (data) in
                    if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                        print(responseData)
                        if responseData == "1" {
                            DispatchQueue.main.async(execute: {
                                self.emailTextfield.Invalid("Email has been registered")
                            })
                            
                        }
                    }
                })
            } else {
                emailTextfield.Invalid("Invalid email")
            }
        }

    }
    @IBAction func PhoneDidEnd(_ sender:UITextField) {
        if var phone = phoneTextfield.text {
            if phone.characters.first == "0" {
                phone.characters.popFirst()
                phone = "62\(phone)"
            }
            print("phone : \(phone)") 
            let postParameter = "phone=\(phone)"
            let link = "http://rico.webmurahbagus.com/admin/API/CekPhone.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    print(responseData)
                    if responseData == "1" {
                        DispatchQueue.main.async(execute: {
                            self.phoneTextfield.Invalid("Phone number has been registered")
                        })
                        
                    }
                }
            })
        }
    }
    @IBAction func SIgnUpTapped(_ sender: AnyObject) {
        if (Validation()) {
            let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sit amet pharetra eros, eget varius ex. Etiam vestibulum mi ipsum, eget euismod est sollicitudin eu. Quisque vulputate est ut pharetra molestie. In sit amet consequat enim. Praesent dignissim tincidunt congue. Sed ex arcu, interdum pellentesque urna quis, tincidunt tempus lectus. Nullam pulvinar massa quis sodales cursus. Sed in odio varius, iaculis magna vitae, consectetur ligula. Nunc in elit dolor.\nEtiam sit amet nisl vel odio eleifend venenatis. In et nulla non sem molestie luctus. Vestibulum varius, magna vel pellentesque sagittis, dui lacus auctor dolor, quis malesuada diam nibh et enim. In non arcu non massa lobortis porttitor. Curabitur eleifend consectetur nisl quis facilisis. Etiam feugiat rhoncus rutrum. Ut sit amet mi id diam consequat congue eget id dolor. Maecenas pharetra, leo et euismod aliquam, velit augue congue sapien, lacinia venenatis justo elit vitae lorem. Nam accumsan dignissim condimentum.\nSuspendisse augue urna, congue rutrum tortor ac, convallis efficitur felis. Maecenas at nisl eget nunc tristique sagittis. Praesent ultrices turpis eu nulla venenatis luctus. Phasellus semper ullamcorper risus, vehicula imperdiet arcu vestibulum eget. Vivamus placerat quis magna id pulvinar. Curabitur purus ex, pharetra in semper vitae, sollicitudin commodo leo. Sed et iaculis mi. Fusce facilisis, velit quis fermentum mollis, tortor arcu laoreet quam, sit amet iaculis velit turpis quis lorem. Aliquam bibendum magna eu sagittis vehicula. Duis aliquam diam cursus faucibus interdum. Nam a lectus et nisl fringilla lobortis ut vitae ex. Curabitur non iaculis ante. Nullam aliquam ex ac consequat accumsan. Praesent ac quam massa. Maecenas vestibulum, nibh id pellentesque ornare, erat nisi semper justo, sit amet porta magna augue a massa.\nNullam ultricies urna et odio luctus imperdiet. Nunc id lorem a nulla lobortis commodo. Aliquam ultrices gravida elit vitae auctor. Pellentesque vitae iaculis diam. Integer velit diam, feugiat at finibus quis, vulputate sed risus. Duis nec massa id metus volutpat fermentum a ac eros. Suspendisse tristique tortor vel lectus vestibulum volutpat. In semper placerat mollis. Curabitur bibendum dictum tempus. Nullam eu laoreet augue. Nulla justo velit, rutrum convallis fermentum sit amet, egestas vitae sapien. Aenean eget purus varius, sagittis erat at, lobortis risus. Nam diam dolor, lobortis sed molestie a, convallis at quam. Vivamus id ligula eu sapien congue pellentesque sed sed mi. Nulla varius mattis augue.\nNullam pulvinar nunc eu dictum vulputate. Sed lobortis justo dolor, id iaculis orci ullamcorper a. Sed facilisis faucibus massa quis interdum. Maecenas hendrerit rhoncus ligula, vitae posuere purus. Fusce in elementum massa, vitae laoreet nisl. Phasellus feugiat, nunc et tempor mollis, purus urna tempus purus, in ultricies tortor ipsum in enim. Donec id ultricies odio. Ut eu vestibulum tellus. Mauris tincidunt auctor tempor. Nam sit amet porta mauris."
            let alert = UIAlertController(title: "Agrement Term & Conditions", message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Agree", style: .default, handler: { (action) -> Void in
                self.SignUpAPI()
            })
            let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            }
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func PasswordDidEnd(_ sender: AnyObject) {
        if passwordTextfield.text?.characters.count < 8 {
            passwordTextfield.PasswordInvalid()
        }
    }

    //MARK: Function

    func Validation() -> Bool {
        var valid = true
        
        if usernameTextfield.text == "" || fullnameTextfield.text == "" || emailTextfield.text == "" || passwordTextfield.text == "" || confirmTextfield.text == "" {
            if (usernameTextfield.text == "") {
                usernameTextfield.Required()
            }
            if (fullnameTextfield.text == "") {
                fullnameTextfield.Required()
            }
            if (emailTextfield.text == "") {
                emailTextfield.Required()
            }
            if (phoneTextfield.text == "") {
                phoneTextfield.Required()
            }
            if (passwordTextfield.text == "") {
                passwordTextfield.Required()
            }
            if (confirmTextfield.text == "") {
                confirmTextfield.Required()
            }
            valid = false
        }

        if passwordTextfield.text?.characters.count < 8 {
            passwordTextfield.PasswordInvalid()
            confirmTextfield.text = ""
            valid = false
        }
        else if passwordTextfield.text != confirmTextfield.text {
            passwordTextfield.PasswordDoesntMatch()
            confirmTextfield.PasswordDoesntMatch()
            valid = false
        }
        
        
        
        return valid
    }
    
    //MARK: API
    func SignUpAPI() {
        signupButton.isEnabled = false
        cancelButton.isEnabled = false
        signupButton.alpha = 0.4
        cancelButton.alpha = 0.4
        self.indicator.startAnimating()
        view.endEditing(true)
        if let username = usernameTextfield.text, let password = passwordTextfield.text, let fullname = fullnameTextfield.text, let email = emailTextfield.text, var phone = phoneTextfield.text {
            if phone.characters.first == "0" {
                phone.characters.popFirst()
                phone = "62\(phone)"
            }
            let postParameter = "username=\(username)&fullname=\(fullname)&email=\(email)&password=\(password)&phone=\(phone)"
            let link = "http://rico.webmurahbagus.com/admin/API/InsertmemberAPI.php"
            AjaxPost(link, parameter: postParameter,
                     done: { (data) in
                        if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                            if responseData != "0" {
                                DispatchQueue.main.async(execute: {
                                    if let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "confirmphone") as? ConfirmationPhoneViewController {
                                        destinationVC.idmember = responseData
                                        self.SMSAPI(idmember: responseData)
                                        self.present(destinationVC, animated: true, completion: nil)
                                    }
                                    
                                    
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    self.indicator.stopAnimating()
                                    let alertController = UIAlertController(title: "Sorry, our server cannot be reached!", message:
                                        "", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                    
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                })
                            }
                        }
                    },
                     error: {
                        self.indicator.stopAnimating()
                        self.Alert("Please check your internet connection!")
                    })        }
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
    
    @IBAction func Tapped(_ sender: AnyObject) {
        offsetScrollY = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
        isKeyboardShow = false
        view.endEditing(true)
    }
    
    @IBAction func Scroll(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self.view)
        offsetScrollY -= point.y / 3.0
        if (offsetScrollY > 0 && offsetScrollY < 200) {
            scrollView.contentOffset = CGPoint(x: 0, y: offsetScrollY)
        }
        if (offsetScrollY < 0) {
            offsetScrollY = 0
        }
        if (offsetScrollY > 400) {
            offsetScrollY = 400
        }

    }
    
    
    //MARK: Text Field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isKeyboardShow = true
        let textfieldY = textField.frame.origin.y
        let keyboardY = self.view.frame.height - keyboardHeight
        if keyboardY - textfieldY < 0 {
            let offset = textfieldY - keyboardY
            offsetScrollY = offset
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: offset)
            })
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if nextTag > 5 {
            SIgnUpTapped(signupButton)
            view.endEditing(true)
        }
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}
