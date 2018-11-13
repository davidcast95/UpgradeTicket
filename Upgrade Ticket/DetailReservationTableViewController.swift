//
//  DetailReservationTableViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/25/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DetailReservationTableViewController: UITableViewController {

    let sectionsString = ["Tiket Information", "Payment Information","Passenger Information"]
    var numOfRowsInSection = [1,3,4 + 1]
    var loading = true
    @IBOutlet weak var buttonContainer: UIView!
    
    var paymentInformation = Array<String>()
    var passengersInformation = Array<String>()
    let paymentField = ["Card Holder","Payment Method","Rekening"]
    let passengerField = ["Fullname","Birthdate"]
    var indexField = 0
    
    @IBOutlet var detailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GenerateDetail()
        GetDetail()
        if viewTransaction.status != 2 {
            print("asd")
            buttonContainer.isHidden = true
            buttonContainer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsString.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numOfRowsInSection[section]
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsString[section]
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if #available(iOS 8.2, *) {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        } else {
            // Fallback on earlier versions
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 118
        } else {
            if loading {
                return tableView.frame.height - 118
            }
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ticket-information",for: indexPath) as? HistoryTableViewCell {
                let depart = "Depart at \(viewTransaction.departure.dateFormat) \(viewTransaction.departure.timeOnly)"
                var mutableAttrString = NSMutableAttributedString(string: depart)
                
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:10))
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:10,length:depart.characters.count - 10))
                mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location:10,length:depart.characters.count - 10))
                
                cell.depart.attributedText = mutableAttrString
                let arrive = "Arrive at \(viewTransaction.arrival.dateFormat) \(viewTransaction.arrival.timeOnly)"
                mutableAttrString = NSMutableAttributedString(string: arrive)
                
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:10))
                mutableAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:10,length:arrive.characters.count - 10))
                mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 12), range: NSRange(location:10,length:arrive.characters.count - 10))
                cell.arrive.attributedText = mutableAttrString
                cell.destinationFlight.text = "\(viewTransaction.from) → \(viewTransaction.to)"
                cell.flightDetail.text = viewTransaction.flight_number
                cell.passenger.text = viewTransaction.passenger.passengerFormat
                cell.subtotal.text = viewTransaction.total.currency
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "error-detail", for: indexPath)
                return cell
            }
        } else {
            if loading {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loading-detail",for: indexPath)
                return cell
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell-detail", for: indexPath) as? DetailTransactionTableViewCell {
                if (indexPath as NSIndexPath).section == 1 {
                    let index = (indexPath as NSIndexPath).row
                    cell.field.text = paymentField[index]
                    cell.value.text = paymentInformation[index]
                }
                else {
                    let index = (indexPath as NSIndexPath).row
                    if (index < passengersInformation.count) {
                        if (index % 3 == 0) {
                            cell.field.text = passengersInformation[index]
                            cell.value.text = ""
                            
                        } else {
                            cell.field.text = passengerField[indexField % passengerField.count]
                            indexField+=1
                            cell.value.text = passengersInformation[index]
                        }
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "error-detail", for: indexPath)
                return cell
            }
        }
    }
    
    //MARK: Functions
    func GenerateDetail() {
        paymentInformation.append(viewTransaction.card_holder)
        paymentInformation.append(viewTransaction.payment_method)
        paymentInformation.append(viewTransaction.card_number)
    }

    //MARK: Connectivity
    func GetDetail() {
        if let userId = activeUser.value(forKey: "id") {
            let postParameter = "iduser=\(userId)&idtransaksi=\(viewTransaction.id)"
            print(postParameter)
            AjaxPost("http://rico.webmurahbagus.com/admin/API/GetDetailAPI.php", parameter: postParameter, done: { data in
                do {
                    let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print(string)
                    let details = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                    var i = 1
                    for detail in details! {
                        if let fullname = detail["fullname"] as? String, let birthdate = detail["birthdate"] as? String {
                            self.passengersInformation.append("Person \(i)")
                            self.passengersInformation.append(fullname)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            self.passengersInformation.append((formatter.date(from: birthdate)?.dateFormat)!)
                            i+=1
                        }
                    }
                    self.loading = false
                    self.numOfRowsInSection[2] = (self.passengersInformation.count)
                    self.indexField = 0
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        
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
