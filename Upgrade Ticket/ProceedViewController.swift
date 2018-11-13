//
//  ProceedViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ProceedViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate {

    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var settingView : UIView!
    @IBOutlet weak var paymentMethodView: UIView!
    var tag = 0
    var textfields = Array<UITextField>()
    var datePicker = UIDatePicker()
    var datePickerToChange = UITextField()
    var isSettingShow = false
    var isPaymentMethodShow = false
    var mask = Mask()
    var screen = CGRect()
    var isKeyboardShow = false
    var titles = ["Mr.","Mrs.","Ms."]
    var titlePickerView = UIPickerView()
    var activeTitle = UITextField()
    var first = true
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen = view.frame
        CreateMask()
        RespositioningSettingView()
        paymentMethodView.isHidden = true
    
        titlePickerView.delegate = self
        if let nav = navigationController {
            nav.interactivePopGestureRecognizer?.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            UIView.animate(withDuration: 0.25, animations: {
                self.mask.Hide()
                var frame = self.settingView.frame
                frame.origin.y = self.screen.height
                self.settingView.frame = frame
                }, completion: { finished in
                    self.isSettingShow = false
                    self.view.sendSubview(toBack: self.mask)
            })
        }
        if isPaymentMethodShow {
            UIView.animate(withDuration: 0.25, animations: {
                self.mask.Hide()
                self.paymentMethodView.alpha = 0
                }, completion: { finished in
                    self.isPaymentMethodShow = false
                    self.paymentMethodView.isHidden = true
                    self.view.sendSubview(toBack: self.mask)
            })
        }
    }
    @IBAction func SettingClicked(_ sender: UIButton) {
        if activeUser.value(forKey: "id") != nil {
            if !isSettingShow {
                self.view.bringSubview(toFront: self.mask)
                self.view.bringSubview(toFront: self.settingView)
                UIView.animate(withDuration: 0.3, animations: {
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFlight.passenger + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row < searchFlight.passenger {
            return 274
        } else {
            if searchFlight.isRoundTrip {
                return 854
            } else {
                return 472
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row < searchFlight.passenger {
            let cell = tableView.dequeueReusableCell(withIdentifier: "person-cell", for: indexPath) as! PersonTableViewCell
            cell.personLabel.text = "Passenger \((indexPath as NSIndexPath).row + 1)"
            cell.selectionStyle = .none
            
            cell.titleTextField.tag = tag
            cell.titleTextField.delegate = self
            if first {
                cell.titleTextField.text = titles[0]
            }
            
            cell.titleTextField.addTarget(self, action: #selector(TitlePickerSelect), for: .editingDidBegin)
            textfields.append(cell.titleTextField)
            tag += 1
            
            cell.fullNameTextfield.tag = tag
            cell.fullNameTextfield.delegate = self
            tag += 1
            textfields.append(cell.fullNameTextfield)
            cell.birthdateTextField.tag = tag
            cell.birthdateTextField.addTarget(self, action: #selector(BirthDateEditBegin), for: .editingDidBegin)
            cell.birthdateTextField.delegate = self
            tag += 1
            
            textfields.append(cell.birthdateTextField)
            if ((indexPath as NSIndexPath).row + 1 == searchFlight.passenger) {
                cell.birthdateTextField.returnKeyType = .go
                first = false
            }
            
            return cell
        } else {
            if searchFlight.isRoundTrip {
                let cell = tableView.dequeueReusableCell(withIdentifier: "roundtrip-ticket-cell", for:  indexPath) as! RoundTripTicketTableViewCell
                
                let font = UIFont(name: "Futura-CondensedMedium", size: 14)
                cell.destinationFlight.text = "\(reservation.flight.from.cityAlias) → \(reservation.flight.to.cityAlias)"
                cell.airportDestination.text = "\(reservation.flight.from.airport) → \(reservation.flight.to.airport)"
                cell.airlinesDestination.text = ": \(reservation.flight.airlines.airlines)"
                cell.flightNumberDestination.text = ": \(reservation.flight.number)"
                cell.departureDestination.text = ": \(reservation.flight.departure.dateFormat) \(reservation.flight.departure.timeOnly)"
                cell.arrivalDestination.text = ": \(reservation.flight.arrival.dateFormat) \(reservation.flight.departure.timeOnly)"
                cell.passengerDestination.text = ": \(searchFlight.passenger.passengerFormat) (\(reservation.flight.type == "B" ? "Bisnis Class" : "First Class"))"
                cell.priceDestination.text = ": \(reservation.flight.price.currency)"
                cell.taxDestination.text = ": \(reservation.flight.tax.currency)"
                cell.transitDestination.attributedText = NSAttributedString(string: (reservation.flight.transit == "") ? "No transit" : reservation.flight.transit, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!])
                
                cell.returningFlight.text = "\(reservation.back.from.cityAlias) → \(reservation.back.to.cityAlias)"
                cell.airportReturning.text = "\(reservation.back.from.airport) → \(reservation.back.to.airport)"
                cell.airlinesReturning.text = ": \(reservation.back.airlines.airlines))"
                cell.flightNumberReturning.text = ": \(reservation.back.number)"
                cell.departureReturning.text = ": \(reservation.back.departure.dateFormat) \(reservation.back.departure.timeOnly)"
                cell.arrivalReturning.text = ": \(reservation.back.arrival.dateFormat) \(reservation.back.arrival.timeOnly)"
                cell.passengerReturning.text = ": \(searchFlight.passenger.passengerFormat) (\(reservation.back.type == "B" ? "Bisnis Class" : "First Class"))"
                cell.priceReturning.text = ": \(reservation.back.price.currency)"
                cell.taxReturning.text = ": \(reservation.back.tax.currency)"
                cell.transitReturning.attributedText = NSAttributedString(string: (reservation.back.transit == "") ? "No transit" : reservation.flight.transit, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!])
                
                let subtotal = (reservation.flight.price * Double(searchFlight.passenger)) + (reservation.back.price * Double(searchFlight.passenger)) + reservation.flight.tax + reservation.back.tax
                cell.subtotal.text = ": \(subtotal.currency)"
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "oneway-ticket-cell", for: indexPath) as! OneWayTicketTableViewCell
                
                cell.destinationFlight.text = "\(reservation.flight.from.cityAlias) → \(reservation.flight.to.cityAlias)"
                cell.airport.text = "\(reservation.flight.from.airport) → \(reservation.flight.to.airport)"
                cell.airlinesLabel.text = ": \(reservation.flight.airlines.airlines)"
                cell.flightNumberLabel.text = ": \(reservation.flight.number)"
                cell.departureLabel.text = ": \(reservation.flight.departure.dateFormat), \(reservation.flight.departure.timeOnly)"
                cell.arrivalLabel.text = ": \(reservation.flight.arrival.dateFormat), \(reservation.flight.arrival.timeOnly)"
                cell.passengerLabel.text = ": \(searchFlight.passenger.passengerFormat) (\(reservation.flight.type == "B" ? "Bisnis Class" : "First Class"))"
                cell.taxLabel.text = ": \(reservation.flight.tax.currency)"
                cell.priceLabel.text = ": \(reservation.flight.price.currency)"
                let subtotal = (reservation.flight.price * Double(searchFlight.passenger)) + reservation.flight.tax
                cell.subtotalLabel.text = ": \(subtotal.currency)"
                
                let font = UIFont(name: "Futura-CondensedMedium", size: 14)
                cell.transitDescription.attributedText = NSAttributedString(string: (reservation.flight.transit == "") ? "No transit" : reservation.flight.transit, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!])
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CloseInputView()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isKeyboardShow = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        textField.backgroundColor = UIColor.white
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
            CloseInputView()
            Validation(proceedButton)
        }
        return false
    }
    
    func BirthDateEditBegin(_ sender: UITextField) {
        sender.inputView = datePicker
        datePicker.datePickerMode = .date
        datePickerToChange = sender
        datePicker.addTarget(self, action: #selector(DatePickerChange), for: .valueChanged)
    }
    func DatePickerChange(_ sender: UIDatePicker) {
        datePickerToChange.text = sender.date.sqlDate
    }
    func TitlePickerSelect(_ sender: UITextField) {
        activeTitle = sender
        sender.inputView = titlePickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeTitle.text = titles[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CloseInputView()
    }
    
    func CloseInputView() {
        isKeyboardShow = false
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    
    @IBAction func Validation(_ sender: UIButton) {
        reservation.passengers.removeAll()
        var valid = true
        var j = 0
        for _ in 0..<searchFlight.passenger {
            j+=1
            if (textfields[j].text == "") {
                textfields[j].layer.borderColor = UIColor.red.cgColor
                textfields[j].layer.borderWidth = 1.0;
                textfields[j].layer.cornerRadius = 5.0;
                valid = false
            }
            j+=1
            if textfields[j].text == "" {
                textfields[j].layer.borderColor = UIColor.red.cgColor
                textfields[j].layer.borderWidth = 1.0;
                textfields[j].layer.cornerRadius = 5.0;
                valid = false
            }
            j+=1
            reservation.passengers.append(Passenger(fullname: "\(textfields[j-3].text!) \(textfields[j-2].text!)", birthdate: textfields[j-1].text!))
        }
        if (valid) {
            self.mask.Hide()
            isPaymentMethodShow = true
            self.paymentMethodView.alpha = 0
            self.paymentMethodView.isHidden = false
            self.view.bringSubview(toFront: self.mask)
            self.view.bringSubview(toFront: self.paymentMethodView)
            UIView.animate(withDuration: 0.3, animations: {
                self.paymentMethodView.alpha = 1
                self.mask.Show()
            })
            
        }
    }
    
    @IBAction func BackToProceed(_ segue: UIStoryboardSegue) {
        
    }

}
