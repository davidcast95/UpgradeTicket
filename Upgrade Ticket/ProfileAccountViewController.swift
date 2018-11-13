//
//  ProfileAccountViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/27/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import CoreData

class ProfileAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Color Code
    var colors = [UIColor(red: 249/255, green: 86/255, blue: 37/255, alpha: 1),UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1),UIColor(red: 36/255, green: 171/255, blue: 87/255, alpha: 1)]
    
    //MARK: Slider Properties
    @IBOutlet weak var sliderButton: UIButton!
    @IBOutlet weak var sliderOffset: NSLayoutConstraint!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var slider: UIView!
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var badgeProccess: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    
    var loading = true
    var indexSlider = 0
    var status = 2
    var processCount = 0
    
    //MARK: Table Properties
    @IBOutlet weak var historyTableView: UITableView!
    var filteredHistory = Array<Transaction>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        badgeProccess.layer.cornerRadius = 10
        if processCount > 0 {
            badgeProccess.isHidden = false
            badgeLabel.text = "\(processCount)"
        } else {
            badgeProccess.isHidden = true
        }
        GetHistory()
        UpdateSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        } else if filteredHistory.count == 0 {
            return 1
        }
        return filteredHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading-transaction", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else if filteredHistory.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "no-transaction", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "history-cell", for: indexPath) as! HistoryTableViewCell
        
        let transaction = filteredHistory[(indexPath as NSIndexPath).row]
        let depart = "Depart at \(transaction.departure.dateFormat) \(transaction.departure.timeOnly)"
        var mutableAttrString = NSMutableAttributedString(string: depart)
        
        mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:10))
        mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:10,length:depart.characters.count - 10))
        mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location:10,length:depart.characters.count - 10))
        
        cell.depart.attributedText = mutableAttrString
        let arrive = "Arrive at \(transaction.arrival.dateFormat) \(transaction.arrival.timeOnly)"
        mutableAttrString = NSMutableAttributedString(string: arrive)
        
        mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:10))
        mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:10,length:arrive.characters.count - 10))
        mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location:10,length:arrive.characters.count - 10))
        cell.arrive.attributedText = mutableAttrString
        cell.destinationFlight.text = "\(transaction.from) → \(transaction.to)"
        cell.flightDetail.text = transaction.flight_number
        cell.passenger.text = transaction.passenger.passengerFormat
        cell.subtotal.text = transaction.total.currency
        cell.confirmed.isHidden = (transaction.status != 4)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loading && filteredHistory.count > 0 {
            let index = (indexPath as NSIndexPath).row
            viewTransaction = filteredHistory[index]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if loading || filteredHistory.count == 0 {
            return tableView.frame.height
        } else {
            return 118
        }
    }
    
    //MARK: Actions
    @IBAction func ProcessedClick(_ sender: UIButton) {
        indexSlider = 0
        status = 2
        UpdateSlider()
        if !loading {
            FilterStatus()
        }
    }
    @IBAction func DoneClick(_ sender: UIButton) {
        indexSlider = 1
        status = 3
        UpdateSlider()
        if !loading {
            FilterStatus()
        }
    }
    @IBAction func CanceledClick(_ sender: UIButton) {
        indexSlider = 2
        status = 1
        UpdateSlider()
        if !loading {
            FilterStatus()
        }
    }
    @IBAction func BackToProfile(_ sender: UIStoryboardSegue) {
        
        
    }
    
    //MARK: Functions
    func UpdateSlider() {
        let offset = CGFloat(indexSlider) * sliderButton.frame.width
        UIView.animate(withDuration: 0.25, animations: {
            self.slider.frame.origin.x = offset
            self.slider.backgroundColor = self.colors[self.status-1]
        })
    }
    
    func UpdateSession() {
        if history.count > 0 {
            loading = false
            FilterStatus()
        }
    }
    
    func FilterStatus() {
        if status == 2 {
            filteredHistory = history.filter({
                history in
                return history.status == status || history.status == 4
            })
            
        } else {
            filteredHistory = history.filter({
                history in
                return history.status == status
            })
        }
        self.historyTableView.reloadData()
    }
    func FindTransactionInSession(_ transaction:Transaction) -> Bool {
        for hist in history {
            if hist.id == transaction.id {
                return true
            }
        }
        return false
    }
    func UpdateStatus(_ transaction:Transaction) {
        for hist in history {
            if hist.id == transaction.id {
                hist.status = transaction.status
            }
        }
        if processCount > 0 {
            badgeProccess.isHidden = false
            badgeLabel.text = "\(processCount)"
        } else {
            badgeProccess.isHidden = true
        }
    }
    

    //MARK: Connectivity
    func GetHistory() {
        processCount = 0
        loading = true
        if let userId = activeUser.value(forKey: "id") {
            let postParameter = "iduser=\(userId)"
            AjaxPost("http://rico.webmurahbagus.com/admin/API/GetTransactionAPI.php", parameter: postParameter, done: { data in
                do {
                    let transactions = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                    for transaction in transactions! {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let tempTransaction = Transaction()
                        if let arrival = transaction["arrival"] as? String {
                            tempTransaction.arrival = arrival.dateTime
                        }
                        if let departure = transaction["departure"] as? String {
                            tempTransaction.departure = departure.dateTime
                        }
                        if let flight_number = transaction["flight_number"] as? String {
                            tempTransaction.flight_number = flight_number
                        }
                        if let payment_method = transaction["payment_method"] as? String {
                            tempTransaction.payment_method = payment_method
                        }
                        if let card_holder = transaction["card_holder"] as? String {
                            tempTransaction.card_holder = card_holder
                        }
                        if let card_number = transaction["card_number"] as? String {
                            tempTransaction.card_number = card_number
                        }
                        if let total = transaction["total"] as? String {
                            tempTransaction.total = Double(total)!
                        }
                        if let from = transaction["destination_from"] as? String {
                            tempTransaction.from = searchFlight.FindCityById(Int(from)!).cityAlias
                        }
                        if let to = transaction["destination_to"] as? String {
                            tempTransaction.to = searchFlight.FindCityById(Int(to)!).cityAlias
                        }
                        if let passenger = transaction["person"] as? String {
                            tempTransaction.passenger = Int(passenger)!
                        }
                        if let status = transaction["status"] as? String {
                            tempTransaction.status = Int(status)!
                            if tempTransaction.status == 2 {
                                self.processCount+=1
                            }
                        }
                        if let id = transaction["id_transaksi"] as? String {
                            tempTransaction.id = Int(id)!
                        }
                        
                        if !self.FindTransactionInSession(tempTransaction) {
                            history.append(tempTransaction)
                        }
                        
                        DispatchQueue.main.async {
                            self.UpdateStatus(tempTransaction)
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.loading = false
                        self.FilterStatus()
                    })
                } catch {
                    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print(string)
                    print("error")
                }
            })
        } else {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "home")
            present(homeVC!, animated: true, completion: nil)
        }
    }
    
    
}
