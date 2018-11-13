//
//  PaymentViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UIPickerViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var paymentButton: UIButton!
//    var paymentMethodPicker = UIPickerView()
//    var paymentMethod = ["Transfer Bank","Use My Own Milespoints"]
    
    //MARK: Setting Properties
    
    @IBOutlet weak var settingView: UIView!
    var isSettingShow = false
    var mask = Mask()
    var screen = CGRect()
    var processAlert = UIAlertController()
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen = view.frame
        CreateMask()
        RespositioningSettingView()
//        paymentMethodPicker.delegate = self
//        paymentMethodTextField.text = paymentMethod[0]
        if let nav = self.navigationController {
            nav.interactivePopGestureRecognizer?.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        thankyou = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setting Extension
    
    func CreateMask() {
        mask.FitToScreen(screen)
        let tap = UITapGestureRecognizer(target: self, action: #selector(MaskClicked))
        tap.delegate = self
        mask.addGestureRecognizer(tap)
        view.addSubview(mask)
        self.view.sendSubview(toBack: self.mask)
    }
    
    func RespositioningSettingView() {
        if !isSettingShow {
            var frame = settingView.frame
            frame.origin.y = screen.height
            frame.origin.x = 0
            frame.size = CGSize(width: screen.width, height: 100)
            settingView.frame = frame
        }
    }
    
    //Actions
    func MaskClicked(_ sender: UITapGestureRecognizer) {
        if isSettingShow {
            UIView.animate(withDuration: 0.5, animations: {
                self.mask.Hide()
                var frame = self.settingView.frame
                frame.origin.y = self.screen.height
                self.settingView.frame = frame
                }, completion: { finished in
                    self.isSettingShow = false
                    self.view.sendSubview(toBack: self.mask)
            })
        }
    }
    @IBAction func SettingClicked(_ sender: AnyObject) {
        if activeUser.value(forKey: "id") != nil {
            if !isSettingShow {
                self.view.bringSubview(toFront: self.mask)
                self.view.bringSubview(toFront: self.settingView)
                UIView.animate(withDuration: 0.5, animations: {
                    self.mask.Show()
                    var frame = self.settingView.frame
                    frame.origin.y = self.screen.height - 100
                    self.settingView.frame = frame
                    }, completion: { finished in
                        self.isSettingShow = true
                })
            }
        } else {
            let VC = storyboard?.instantiateViewController(withIdentifier: "login")
            self.show(VC!, sender: self)
        }

    }
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return paymentMethod.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return paymentMethod[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        paymentMethodTextField.text = paymentMethod[row]
//    }
//
//    @IBAction func paymentMethodBeginEditing(_ sender: UITextField) {
//        sender.inputView = paymentMethodPicker
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        view.endEditing(true)
    }
    
    @IBAction func ConfirmPressed(_ sender: UIButton) {
        if (cardHolderTextField.text != "" && cardNumberTextField.text != "") {
            let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla sit amet pharetra eros, eget varius ex. Etiam vestibulum mi ipsum, eget euismod est sollicitudin eu. Quisque vulputate est ut pharetra molestie. In sit amet consequat enim. Praesent dignissim tincidunt congue. Sed ex arcu, interdum pellentesque urna quis, tincidunt tempus lectus. Nullam pulvinar massa quis sodales cursus. Sed in odio varius, iaculis magna vitae, consectetur ligula. Nunc in elit dolor.\nEtiam sit amet nisl vel odio eleifend venenatis. In et nulla non sem molestie luctus. Vestibulum varius, magna vel pellentesque sagittis, dui lacus auctor dolor, quis malesuada diam nibh et enim. In non arcu non massa lobortis porttitor. Curabitur eleifend consectetur nisl quis facilisis. Etiam feugiat rhoncus rutrum. Ut sit amet mi id diam consequat congue eget id dolor. Maecenas pharetra, leo et euismod aliquam, velit augue congue sapien, lacinia venenatis justo elit vitae lorem. Nam accumsan dignissim condimentum.\nSuspendisse augue urna, congue rutrum tortor ac, convallis efficitur felis. Maecenas at nisl eget nunc tristique sagittis. Praesent ultrices turpis eu nulla venenatis luctus. Phasellus semper ullamcorper risus, vehicula imperdiet arcu vestibulum eget. Vivamus placerat quis magna id pulvinar. Curabitur purus ex, pharetra in semper vitae, sollicitudin commodo leo. Sed et iaculis mi. Fusce facilisis, velit quis fermentum mollis, tortor arcu laoreet quam, sit amet iaculis velit turpis quis lorem. Aliquam bibendum magna eu sagittis vehicula. Duis aliquam diam cursus faucibus interdum. Nam a lectus et nisl fringilla lobortis ut vitae ex. Curabitur non iaculis ante. Nullam aliquam ex ac consequat accumsan. Praesent ac quam massa. Maecenas vestibulum, nibh id pellentesque ornare, erat nisi semper justo, sit amet porta magna augue a massa.\nNullam ultricies urna et odio luctus imperdiet. Nunc id lorem a nulla lobortis commodo. Aliquam ultrices gravida elit vitae auctor. Pellentesque vitae iaculis diam. Integer velit diam, feugiat at finibus quis, vulputate sed risus. Duis nec massa id metus volutpat fermentum a ac eros. Suspendisse tristique tortor vel lectus vestibulum volutpat. In semper placerat mollis. Curabitur bibendum dictum tempus. Nullam eu laoreet augue. Nulla justo velit, rutrum convallis fermentum sit amet, egestas vitae sapien. Aenean eget purus varius, sagittis erat at, lobortis risus. Nam diam dolor, lobortis sed molestie a, convallis at quam. Vivamus id ligula eu sapien congue pellentesque sed sed mi. Nulla varius mattis augue.\nNullam pulvinar nunc eu dictum vulputate. Sed lobortis justo dolor, id iaculis orci ullamcorper a. Sed facilisis faucibus massa quis interdum. Maecenas hendrerit rhoncus ligula, vitae posuere purus. Fusce in elementum massa, vitae laoreet nisl. Phasellus feugiat, nunc et tempor mollis, purus urna tempus purus, in ultricies tortor ipsum in enim. Donec id ultricies odio. Ut eu vestibulum tellus. Mauris tincidunt auctor tempor. Nam sit amet porta mauris."
            let agreement = UIAlertController(title: "Agreement Term & Conditions", message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Agree", style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async(execute: {
                    self.processAlert = self.ProcessingAlert("Reserve your flight...")
                    self.CreateReservation(reservation.flight)
                    if (reservation.back.id != "0") {
                        self.CreateReservation(reservation.back)
                    }
                })
            })
            let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            }
            
            agreement.addAction(ok)
            agreement.addAction(cancel)
            
            present(agreement, animated: true, completion: nil)
            
        } else {
//            if (paymentMethodTextField.text == "") {
//                paymentMethodTextField.layer.borderColor = UIColor.red.cgColor
//                paymentMethodTextField.layer.borderWidth = 1.0;
//                paymentMethodTextField.layer.cornerRadius = 5.0;
//            }
            
            if (cardHolderTextField.text == "") {
                cardHolderTextField.layer.borderColor = UIColor.red.cgColor
                cardHolderTextField.layer.borderWidth = 1.0;
                cardHolderTextField.layer.cornerRadius = 5.0;
            }
            
            if (cardNumberTextField.text == "") {
                cardNumberTextField.layer.borderColor = UIColor.red.cgColor
                cardNumberTextField.layer.borderWidth = 1.0;
                cardNumberTextField.layer.cornerRadius = 5.0;
            }
        }
    }
    
    func CreateReservation(_ flight:Flight) {
        if let id = activeUser.value(forKey: "id") as? String {
            payment_method = "Transfer Bank"
            self.indicator.startAnimating()
            let postParameter = "id_jadwal=\(flight.id)&flight_number=\(flight.airlines.airlines) \(flight.number)&id_member=\(id)&person=\(searchFlight.passenger)&total=\(Int(flight.price * Double(reservation.passengers.count)) + Int(flight.tax))&payment_method=\(payment_method)&card_holder=\(cardHolderTextField.text!)&card_number=\(cardNumberTextField.text!)&tipe=\(flight.type)"
            let link = "http://rico.webmurahbagus.com/admin/API/InserttransactionAPI.php"
            AjaxPost(link, parameter: postParameter, done: { (data) in
                DispatchQueue.main.async(execute: {
                    if let result = String(data: data,encoding: String.Encoding.utf8) {
                        self.CreateDetailReservation(result)
                    }
                })
            })
        }
    }
    
    func CreateDetailReservation(_ id:String) {
        var success = true
        var i = 0
        for passenger in reservation.passengers {
            let postParameter = "id_transaksi=\(id)&fullname=\(passenger.fullname)&birthdate=\(passenger.birthdate)"
            let link = "http://rico.webmurahbagus.com/admin/API/InsertdetailAPI.php"
            print(postParameter)
            AjaxPost(link, parameter: postParameter, done: { (data) in
                if let responseData = String(data: data, encoding: String.Encoding.utf8) {
                    if responseData != "1" {
                        success = false
                    }
                    else if (success && i + 1 == reservation.passengers.count) {
                        DispatchQueue.main.async(execute: {
                            self.indicator.stopAnimating()
                            self.processAlert.dismiss(animated: true, completion: {
                                self.Thankyou(id)
                            })
                        })
                    } else {
                        i += 1
                    }
                }
            })
            
        }
    }
    
    func Thankyou(_ id:String) {
        let postParameter = "idtransaksi=\(id)"
        var link = "http://rico.webmurahbagus.com/admin/API/MailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: String.Encoding.utf8) {
                print("mailapi = \(result)")
            }
        })
        link = "http://rico.webmurahbagus.com/admin/API/NotifMailAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            if let result = String(data: data, encoding: String.Encoding.utf8) {
                print("notif api = \(result)")
            }
        })
        if (!thankyou) {
            thankyou = true
            let thanyouVC = self.storyboard?.instantiateViewController(withIdentifier: "thankyou")
            self.show(thanyouVC!, sender: self)
        }
    }
}
