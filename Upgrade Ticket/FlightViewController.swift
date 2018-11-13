//
//  FlightViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/16/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit
import CoreData

class FlightViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate {
    
    //MARK : General Property
    var screen:CGRect!
    var isSearching = false
    var isDisconnected = false
    @IBOutlet var tapListener: UITapGestureRecognizer!
    @IBOutlet weak var leftOffsetNavTitle: NSLayoutConstraint!
    @IBOutlet weak var backFlight: UIButton!
    
    // MARK: - Slider Property
    @IBOutlet weak var sliderView: UIView!
    var buttonWidth = CGFloat()
    var selectView = UIView()
    var menus = ["Bisnis","First"]
    var idMenus = ["B","F"]
    var buttons = Array<UIButton>()
    var indexMenu = 0
    
    // MARK: - Settings Property
    var isSettingShow = false
    var mask = Mask()
    var emptyResult = false
    @IBOutlet weak var settingView: UIView!
    
    // MARK: - Input Form Property
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateFlightInput: UITextField!
    @IBOutlet weak var passengerInput: UITextField!
    var datePicker = UIDatePicker()
    var today = Date()
    
    // MARK: - Table Property
    @IBOutlet var flightTableView: UITableView!
    var postParameter = ""
    var flightResults = Array<Flight>()
    var flightDisplay = Array<Flight>()
    var displayCell = Array<Bool>()
    var selectedCell = IndexPath(row: -1, section: -1)
    
    
    
    // MARK: - Core
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        UpdateSlider()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Refresh), for: .valueChanged)
        flightTableView.addSubview(refreshControl)
        tapListener.cancelsTouchesInView = false
        
        screen = self.view.frame
        
        ReadCityData()
        self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", for: UIControlState())
        dateFlightInput.text = today.dateFormat
        CreateMask()
        RespositioningSettingView()
        self.TableLoad()
        
        if let nav = self.navigationController {
            nav.interactivePopGestureRecognizer?.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateSlider()
        self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", for: UIControlState())
        if searchFlight.isRoundTrip {
            self.cityButton.isEnabled = false
            self.backFlight.isEnabled = true
            self.backFlight.isHidden = false
        } else {
            self.cityButton.isEnabled = true
            self.backFlight.isEnabled = false
            self.backFlight.isHidden = true
        }
        DispatchQueue.main.async(execute: {
            self.GetResult()
        })
        
    }
    override func viewDidLayoutSubviews() {
        self.leftOffsetNavTitle.constant = searchFlight.isRoundTrip ? 16 : 36
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSlider()
    }
    
    //MARK: Function
    func layoutSlider() {
        let frame = sliderView.frame
        buttonWidth = frame.width / CGFloat(menus.count)
        var i:CGFloat = 0
        let buttonHeight:CGFloat = frame.height
        for button in buttons {
            button.frame = CGRect(x: i * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
            i+=1
        }
        let offset:CGFloat = buttonWidth * 0.1
        selectView.frame = CGRect(x: (CGFloat(indexMenu) * buttonWidth) + offset/2, y: buttonHeight - CGFloat(5), width: buttonWidth - offset, height: 5)
    }
    
    
    func setupSlider() {
        selectView.backgroundColor = UIColor.init(red: 21/255, green: 170/255, blue: 244/255, alpha: 1)
        sliderView.addSubview(selectView)
        for menu in menus {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.gray, NSFontAttributeName : UIFont(name: "Futura", size: 18)!]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont(name: "Futura", size: 18)!]), for: .highlighted)
            button.setAttributedTitle(NSAttributedString(string: menu, attributes: [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont(name: "Futura", size: 18)!]), for: .selected)
            button.addTarget(self, action: #selector(sliderChange), for: .touchUpInside)
            
            sliderView.addSubview(button)
            buttons.append(button)
        }
        for button in buttons {
            button.isSelected = false
        }
        buttons[indexMenu].isSelected = true
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftSlideOver))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightSlideOver))
        rightSwipe.direction = .right
        leftSwipe.delegate = self
        rightSwipe.delegate = self
        flightTableView.addGestureRecognizer(leftSwipe)
        flightTableView.addGestureRecognizer(rightSwipe)
    }
    
    func LeftSlideOver(_ sender: UISwipeGestureRecognizer) {
        if indexMenu + 1 < menus.count {
            indexMenu+=1
            UpdateSlider()
            GetResult()
        }
    }
    func RightSlideOver(_ sender: UISwipeGestureRecognizer) {
        if indexMenu - 1 >= 0 {
            indexMenu-=1
            UpdateSlider()
            GetResult()
        }
    }
    func sliderChange(_ sender: UIButton) {
        let index = Int(sender.frame.origin.x / sender.frame.width)
        if indexMenu != index {
            indexMenu = index
            
            UpdateSlider()
        }
        GetResult()
    }
    
    func UpdateSlider() {
        UIView.animate(withDuration: 0.25, animations: {
            let offset:CGFloat = self.buttonWidth * 0.1
            self.selectView.frame.origin.x = self.buttons[self.indexMenu].frame.origin.x + offset/2
        })
        for button in buttons {
            button.isSelected = false
        }
        buttons[indexMenu].isSelected = true
    }
    
    func Refresh(_ refreshControl: UIRefreshControl) {
        GetResult()
        // Do your job, when done:
        refreshControl.endRefreshing()
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
    func NoFlight() {
        self.emptyResult = true
        self.isSearching = false
        self.TableLoad()
    }
    
    func TableLoad() {
        DispatchQueue.main.async(execute: {
            self.indicator.stopAnimating()
            self.flightTableView.reloadData()
        })
    }
    func Default() {
        if searchFlight.cities.count >= 2 {
            
            DispatchQueue.main.async(execute: {
                searchFlight.Default()
                self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", for: UIControlState())
                self.GetResult()
            })
        }
    }
    func FindPrice(_ flight:Flight) -> (Double,Double) {
        var prices:[Double] = []
        for _flight in flightResults {
            if _flight.number == flight.number && _flight.departure == flight.departure && _flight.arrival == flight.arrival {
                prices.append(_flight.price)
            }
        }
        
        return (prices.max()!,prices.min()!)
    }
//    func GroupFlight() {
//        var result = Array<Flight>()
//        for i in 0 ..< flightResults.count {
//            print("......................\(flightResults[i].number)")
//            if flightResults[i].number != "" {
//                var max = flightResults[i].price,min = flightResults[i].price
//                var maxIndex = i, minIndex = i
//                for j in 0 ..< flightResults.count {
//                    if (flightResults[j].number != "" && flightResults[i].number == flightResults[j].number && flightResults[i].departure == flightResults[j].departure && flightResults[i].arrival == flightResults[j].arrival) {
//                        if flightResults[j].price > max {
//                            max = flightResults[j].price
//                            maxIndex = j
//                        }
//                        if flightResults[j].price < min {
//                            min = flightResults[j].price
//                            minIndex = j
//                        }
//                    }
//                }
//                if maxIndex == minIndex {
//                    flightResults[i].new = flightResults[i].price
//                    result.append(flightResults[i])
//                } else {
//                    flightResults[i].old = flightResults[maxIndex].price
//                    flightResults[i].new = flightResults[minIndex].price
//                    flightResults[i].id = flightResults[minIndex].id
//                    result.append(flightResults[i])
//                }
//                flightResults[maxIndex] = Flight()
//                flightResults[minIndex] = Flight()
//            }
//        }
//        flightResults = result
//    }
    func ShowRoundTripConfirmation() {
        let alert = UIAlertController(title: "Do you want to round trip ?", message: "You will choose for your returning flight", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            searchFlight.Swap()
            searchFlight.isRoundTrip = true
            DispatchQueue.main.async(execute: {
                self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", for: UIControlState())
                self.cityButton.isEnabled = false
                self.backFlight.isEnabled = true
                self.backFlight.isHidden = false
                self.leftOffsetNavTitle.constant = 16
            })
            self.GetResult()
        })
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            searchFlight.isRoundTrip = false
            searchFlight.activeResult = .proceed
            let returnViewController = self.storyboard?.instantiateViewController(withIdentifier: "proceed")
            self.show(returnViewController!, sender: self)
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Segue
    
    @IBAction func BackToFlight(_ segue:UIStoryboardSegue) {
        if searchFlight.isRoundTrip {
            searchFlight.Swap()
        }
        searchFlight.isRoundTrip = false
        searchFlight.activeResult = .flight
    }
    
    //MARK: - Action
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
    @IBAction func SettingClicked(_ sender: UIButton) {
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
            self.navigationController?.pushViewController(VC!, animated: true)
        }
    }
    
    
    @IBAction func Tapped(_ sender: AnyObject) {
        view.endEditing(true)
        tapListener.cancelsTouchesInView = false
    }
    
    @IBAction func BackReturnFlight(_ sender: AnyObject) {
        searchFlight.Swap()
        searchFlight.isRoundTrip = false
        DispatchQueue.main.async(execute: {
            self.cityButton.setTitle("\(searchFlight.origin.city) → \(searchFlight.dest.city)", for: UIControlState())
            self.cityButton.isEnabled = true
            self.backFlight.isEnabled = false
            self.backFlight.isHidden = true
            self.leftOffsetNavTitle.constant = 36
        })
        self.GetResult()
    }
    
    //MARK: - Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDisconnected || isSearching || emptyResult {
            return 1
        }
        return flightResults.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if emptyResult || isSearching || isDisconnected {
            return tableView.frame.height
        }
        if (indexPath == selectedCell) {
            return 403
        } else {
            return 243
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDisconnected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noconnectivity", for: indexPath)
            return cell
        }
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searching", for: indexPath)
            return cell
        }
        else if emptyResult {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noflight",for: indexPath)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "flight-cell", for: indexPath) as! FlightTableViewCell
//            cell.selectionStyle = .none
            let i = (indexPath as NSIndexPath).row
            let flight = flightResults[i]
            cell.airlinesLogo.image = UIImage(data: flight.airlines.image as Data)
            cell.airlinesLabel.text = flight.airlines.airlines
            cell.flightNumber.text = flight.number
            cell.destFlight.text = flight.arrival.timeOnly
            cell.originFlight.text = flight.departure.timeOnly
            cell.originCity.text = flight.from.city
            cell.destCity.text = flight.to.city
            cell.departureDate.text = flight.departure.dateFormat
            cell.arrivalDate.text = flight.arrival.dateFormat
            cell.points.text = flight.points.points
            var font = UIFont(name: "Futura-CondensedMedium", size: 12)
            let centerAlignment = NSMutableParagraphStyle()
            centerAlignment.alignment = .center
            cell.departAirport.attributedText = NSAttributedString(string: flight.from.airport, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!, NSParagraphStyleAttributeName : centerAlignment])
            cell.arrivalAirport.attributedText = NSAttributedString(string: flight.to.airport, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!, NSParagraphStyleAttributeName : centerAlignment])
            font = UIFont(name: "Futura-CondensedMedium", size: 15)
            cell.transitFlag.isHidden = flight.transit == ""
            cell.transitDescription.attributedText = NSAttributedString(string: flight.transit, attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName : font!])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!isSearching && !emptyResult && !isDisconnected) {
            view.endEditing(true)
            let reservedFlight = flightResults[(indexPath as NSIndexPath).row]
            //transit
            if reservedFlight.transit != "" && selectedCell == indexPath {
                
                //create reservation
                if searchFlight.isRoundTrip {
                    reservation.back = reservedFlight
                } else {
                    reservation.flight = reservedFlight
                }
                
                //push navigation
                if activeUser.value(forKey: "id") != nil {
                    if searchFlight.isRoundTrip {
                        searchFlight.activeResult = .proceed
                        let returnViewController = self.storyboard?.instantiateViewController(withIdentifier: "proceed")
                        self.show(returnViewController!, sender: self)
                    } else {
                        ShowRoundTripConfirmation()
                    }
                    
                } else {
                    let loginViewController = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                    loginViewController.lastVC = self
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
            else if reservedFlight.transit != "" {
                selectedCell = indexPath
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            else if (indexPath as NSIndexPath).row < flightResults.count {
                
                //create reservation
                if searchFlight.isRoundTrip {
                    reservation.back = reservedFlight
                } else {
                    reservation.flight = reservedFlight
                }
                
                //push navigation
                if activeUser.value(forKey: "id") != nil {
                    if searchFlight.isRoundTrip {
                        searchFlight.activeResult = .proceed
                        let returnViewController = self.storyboard?.instantiateViewController(withIdentifier: "proceed")
                        self.show(returnViewController!, sender: self)
                    } else {
                        ShowRoundTripConfirmation()
                    }
                    
                } else {
                    let loginViewController = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
                    loginViewController.lastVC = self
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let i = (indexPath as NSIndexPath).row
        if i < displayCell.count {
            if displayCell[i] {
                displayCell[i] = false
                cell.alpha = 0
                let translate = CGAffineTransform(translationX: 50, y: 0)
                cell.transform = translate
                UIView.animate(withDuration: 0.5, delay: 0.1 * Double(i), options: .curveEaseInOut, animations: {
                    cell.alpha = 1
                    cell.transform = CGAffineTransform.identity
                    }, completion: nil)
            }
        }

    }
//    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if selectedCell.row != -1 {
//            tableView.cellForRow(at: selectedCell)?.transform = CGAffineTransform.identity
//        }
//        tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.75)
//        return indexPath
//    }
    
    
    //MARK: Input
    
    @IBAction func DateEditBegin(_ sender: UITextField) {
        tapListener.cancelsTouchesInView = true
        sender.inputView = datePicker
        datePicker.minimumDate = today
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(DatePickerChange), for: .valueChanged)
    }
    
    func DatePickerChange(_ sender: UIDatePicker) {
        tapListener.cancelsTouchesInView = true
        searchFlight.dateFlight = sender.date
        dateFlightInput.text = searchFlight.dateFlight.dateFormat
    }
    
    @IBAction func DateFlightEditEnd(_ sender: UITextField) {
        GetResult()
    }
    
    @IBAction func PassengerEditBegin(_ sender: UITextField) {
        sender.text = ""
    }
    @IBAction func PassengerChange(_ sender: UITextField) {
        if sender.text == "" {
            searchFlight.passenger = 1
        } else if let person = Int(sender.text!) {
            searchFlight.passenger = person
        }
    }
    
    @IBAction func PassengerEditEnd(_ sender: UITextField) {
        passengerInput.text = searchFlight.passenger.passengerFormat
        GetResult()
    }
    
    //MARK: - Connectivity
    
    func GetResult() {
        if !isSearching && searchFlight.cities.count > 2 {
            print("getting result")
            searchFlight.Print()
            isSearching = true
            self.view.bringSubview(toFront: indicator)
            self.indicator.startAnimating()
            flightResults.removeAll()
            displayCell.removeAll()
            postParameter = "from=\(searchFlight.origin.id)&to=\(searchFlight.dest.id)&date=\(searchFlight.dateFlight.sqlDate)&passenger=\(searchFlight.passenger)&tipe=\(idMenus[indexMenu])"
            let link = "http://rico.webmurahbagus.com/admin/API/GetJadwalAPI.php"
            AjaxPost(link, parameter: postParameter,
                     done: { (data) in
                        do {
                            
                            self.isSearching = false
                            let flights = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                            print(flights)
                            if flights?.count == 0 {
                                self.NoFlight()
                            } else {
                                self.emptyResult = false
                                for flight in flights! {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let tempFlight = Flight()
                                    if let id = flight["id_jadwal"] as? String {
                                        tempFlight.id = id
                                    }
                                    if let number = flight["flight_number"] as? String {
                                        tempFlight.number = number
                                    }
                                    if let from = flight["origin"] as? String {
                                        tempFlight.from = searchFlight.FindCityById(Int(from)!)
                                    }
                                    if let to = flight["dest"] as? String {
                                        tempFlight.to = searchFlight.FindCityById(Int(to)!)
                                    }
                                    if let departure = flight["departure"] as? String {
                                        tempFlight.departure = formatter.date(from: departure)!
                                    }
                                    if let arrival = flight["arrival"] as? String {
                                        tempFlight.arrival = formatter.date(from: arrival)!
                                    }
                                    if let price = flight["price"] as? String {
                                        tempFlight.price = Double(price)!
                                    }
                                    if let points = flight["points"] as? String {
                                        tempFlight.points = Int(points)!
                                    }
                                    if let type = flight["tipe"] as? String {
                                        tempFlight.type = type
                                    }
                                    if let tax = flight["tax"] as? String {
                                        tempFlight.tax = Double(tax)!
                                    }
                                    if let id_airplane = flight["id_airplane"] as? String {
                                        tempFlight.airlines = searchFlight.FindAirlinesById(Int(id_airplane)!)
                                    }
                                    if let transit = flight["transit"] as? String {
                                        tempFlight.transit = transit
                                    }
                                    self.flightResults.append(tempFlight)
                                }
                                
                                for _ in self.flightResults {
                                    self.displayCell.append(true)
                                }
                                self.TableLoad()
                            }
                            
                        } catch {
                            print("error")
                        }

                    },
                     error: {
                        self.isSearching = false
                        self.isDisconnected = true
                        DispatchQueue.main.async(execute: {
                            self.flightTableView.reloadData()
                        })
                        self.Alert("Please check your internet connection!")
                    },
                     completion: {
                        self.TableLoad()
                    })
        }
    }
    
    
    func ReadAirlinesData() {
        //  check in core data
        let citiesContext = FecthFromCoreData("Airlines")
        searchFlight.airlines.removeAll()
        for cityContext in citiesContext {
            let tempAirline = Airlines()
            tempAirline.id = (cityContext.value(forKey: "id") as? Int)!
            tempAirline.airlines = (cityContext.value(forKey: "airline") as? String)!
            tempAirline.image = (cityContext.value(forKey: "image") as? Data)!
            searchFlight.airlines.append(tempAirline)
        }
        
        
        let link = "http://rico.webmurahbagus.com/admin/API/GetAirplanesAPI.php"
        AjaxPost(link, parameter: "", done: { (data) in
            do {
                let airplanes = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                for airplane in airplanes! {
                    let tempAirline = Airlines()
                    if let airline = airplane["airplane"] as? String {
                        tempAirline.airlines = airline
                    }
                    if let id = airplane["id_airplane"] as? String {
                        tempAirline.id = Int(id)!
                    }
                    if let image = airplane["image"] as? String {
                        if let url = URL(string: "http://rico.webmurahbagus.com/admin/images/\(image)") {
                            if let data = try? Data(contentsOf: url) {
                                tempAirline.image = data
                            }
                        }
                    }
                    if !searchFlight.IsAirlinesExist(tempAirline) {
                        searchFlight.airlines.append(tempAirline)
                        tempAirline.SaveToCoreData()
                    }
                }
            } catch {
                print("error")
            }
        })
        
        
    }

    
    func ReadCityData() {
//        check in core data
        print("reading city data")
        let citiesContext = FecthFromCoreData("Destinations")
        searchFlight.cities.removeAll()
        for cityContext in citiesContext {
            let tempCity = City()
            tempCity.id = (cityContext.value(forKey: "id") as? Int)!
            tempCity.city = (cityContext.value(forKey: "city") as? String)!
            tempCity.alias = (cityContext.value(forKey: "alias") as? String)!
            tempCity.image = (cityContext.value(forKey: "image") as? Data)!
            tempCity.airport = (cityContext.value(forKey: "airport") as? String)!
            searchFlight.cities.append(tempCity)
        }
        self.Default()
        let link = "http://rico.webmurahbagus.com/admin/API/GetDestinationAPI.php"
        AjaxPost(link, parameter: "", done: { (data) in
            do {
                let cities = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : AnyObject]]
                for city in cities! {
                    let tempCity = City()
                    if let id = city["id_destination"] as? String {
                        tempCity.id = Int(id)!
                    }
                    if !searchFlight.IsCityExist(tempCity) {
                        print("ga masuk")
                        if let name = city["city"] as? String {
                            tempCity.city = name
                        }
                        if let alias = city["alias"] as? String {
                            tempCity.alias = alias
                        }
                        if let airport = city["airport"] as? String {
                            tempCity.airport = airport
                        }
                        if let image = city["image"] as? String {
                            if let url = URL(string: "http://rico.webmurahbagus.com/admin/images/\(image)") {
                                if let data = try? Data(contentsOf: url) {
                                    tempCity.image = data
                                }
                            }
                        }
                        
                        searchFlight.cities.append(tempCity)
                        tempCity.SaveToCoreData()
                        self.Default()
                    }
                }
                self.ReadAirlinesData()
                
            } catch {
                print("error")
            }
        })
        
    }
    
    
}
