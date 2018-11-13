//
//  SearchViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var roundTripImage: UIImageView!
    @IBOutlet weak var originButton:UIButton!
    @IBOutlet weak var destButton:UIButton!
    @IBOutlet weak var dateFlightTextField: UITextField!
    @IBOutlet weak var dateReturnTextField: UITextField!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var switchMode: UISwitch!
    var today = Date()
    var datepickerFlight = true
    var datepicker = UIDatePicker()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check cities in core data
        
        
        
        UpdateCity()
        ReadCityData()
        table.reloadData()
        //default date
        today = UIDatePicker().date
        searchFlight.dateFlight = today
        searchFlight.dateReturn = today.AddDays(1)
        dateFlightTextField.text = searchFlight.dateFlight.longFormat
        dateReturnTextField.text = searchFlight.dateReturn.longFormat
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchCityViewController {
            destination.identifier = segue.identifier!
            searchFlight.origin = searchFlight.FindCityByCityAlias((originButton.titleLabel?.text)!)
            searchFlight.dest = searchFlight.FindCityByCityAlias((destButton.titleLabel?.text)!)
        }
        if ((segue.identifier) == "result")  {
            searchFlight.activeResult = .flight
            if let destination = segue.destination as? FlightViewController {
                destination.postParameter = "from=\(searchFlight.origin.id)&to=\(searchFlight.dest.id)&date=\(searchFlight.dateFlight.sqlDate)&passenger=\(searchFlight.passenger)"
            }
            
        }
        
        CloseInputView()
    }
    
    //Functions
    func UpdateCity() {
        originButton.titleLabel?.text = searchFlight.origin.cityAlias
        destButton.titleLabel?.text = searchFlight.dest.cityAlias
        
    }
    
    //Action
    @IBAction func SwitchMode(_ sender: UISwitch) {
        searchFlight.oneWay = !switchMode.isOn
        if switchMode.isOn {
            roundTripImage.image = UIImage(named: "arrows")
        } else {
            
            roundTripImage.image = UIImage(named: "one-arrow")
        }
        table.reloadData()
    }
    @IBAction func PersonDidBegin(_ sender: UITextField) {
        sender.text = ""
    }
    @IBAction func PersonChange(_ sender:UITextField) {
        if (sender.text == "") {
            searchFlight.passenger = 1
        } else {
            searchFlight.passenger = Int(sender.text!)!
        }
    }
    @IBAction func PersonDidEnd(_ sender: UITextField) {
        sender.text = searchFlight.passenger.passengerFormat
    }
    @IBAction func DateFlightBegin(_ sender: UITextField) {
        datepickerFlight = true
        sender.inputView = datepicker
        datepicker.minimumDate = today
        datepicker.datePickerMode = UIDatePickerMode.date
        datepicker.addTarget(self, action: #selector(SearchViewController.DatePickerChange(_:)), for: .valueChanged)
    }
    @IBAction func DateReturnBegin(_ sender: UITextField) {
        datepickerFlight = false
        sender.inputView = datepicker
        datepicker.minimumDate = searchFlight.dateFlight as Date
        datepicker.datePickerMode = UIDatePickerMode.date
        datepicker.addTarget(self, action: #selector(SearchViewController.DatePickerChange(_:)), for: .valueChanged)
    }
    @IBAction func BackToSearch(_ segue:UIStoryboardSegue) {
    }
    
    func DatePickerChange(_ sender: UIDatePicker) {
        if (datepickerFlight) {
            searchFlight.dateFlight = sender.date
            searchFlight.dateReturn = sender.date.AddDays(1)
            dateFlightTextField.text = searchFlight.dateFlight.longFormat
            dateReturnTextField.text = searchFlight.dateReturn.longFormat
        } else {
            searchFlight.dateReturn = sender.date
            dateReturnTextField.text = searchFlight.dateReturn.longFormat
        }
    }
    
    //Table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CloseInputView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath as NSIndexPath).row == 4) {
            if (searchFlight.oneWay) {
                return 0
                
            }
            else {
                return 80
            }
        }
        
        return 80
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CloseInputView()
    }
    
    func ReadCityData() {
        //check in core data
        let citiesContext = FecthFromCoreData("Cities")
        
        for cityContext in citiesContext {
            let tempCity = City()
            tempCity.id = (cityContext.value(forKey: "id") as? Int)!
            tempCity.city = (cityContext.value(forKey: "city") as? String)!
            tempCity.alias = (cityContext.value(forKey: "alias") as? String)!
            
            searchFlight.cities.append(tempCity)
            print(tempCity.cityAlias)
        }
        
        let link = "http://rico.webmurahbagus.com/admin/API/GetDestinationAPI.php"
        if let requestURL = URL(string: link) {
            let urlRequest = URLRequest(url: requestURL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data,response,error ) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse {
                    let statuscode = httpResponse.statusCode
                    if (statuscode == 200) {
                        do {
                            let cities = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String : AnyObject]]
                            print(cities?.count)
                            for city in cities! {
                                let tempCity = City()
                                if let name = city["city"] as? String {
                                    tempCity.city = name
                                }
                                if let alias = city["alias"] as? String {
                                    tempCity.alias = alias
                                }
                                if let id = city["id_destination"] as? String {
                                    tempCity.id = Int(id)!
                                }
                                if !searchFlight.IsCityExist(tempCity) {
                                    searchFlight.cities.append(tempCity)
                                    tempCity.SaveToCoreData()
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        searchFlight.Default()
                                        self.table.reloadData()
                                        
                                    })
                                }
                            }
                            
                        } catch {
                            print("error")
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Please check your internet connection!", message:
                        "", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }) 
            
            task.resume()
        }
        
        DispatchQueue.main.async(execute: {
            
            searchFlight.Default()
            self.table.reloadData()
            
        })
        
    }
    
    

}
