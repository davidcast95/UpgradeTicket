//
//  TestViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 7/2/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var cities = Array<City>()
    var filteredCities = Array<City>()
    var displayCell = Array<Bool>()
    var destView = UIView()
    var selectedIndex = -1
    var no_result = false
    var viewCount = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchFlight.activeResult = .flight
        if let id = restorationIdentifier {
            self.cities = searchFlight.cities
            print(searchFlight.origin.city)
            if id == "destination" {
                self.cities.RemoveByCityAlias(search: searchFlight.origin)
            }
        }
        
        
        displayCell.removeAll()
        for _ in 0..<cities.count {
            displayCell.append(true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    //MARK : - TableViewCell Animation
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (searchBar.text != "") {
            if (filteredCities.count == 0) {
                no_result = true
                return tableView.frame.height
            }
            no_result = false
            return 135
        } else {
            no_result = false
            return 135
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBar.text != "") {
            if (filteredCities.count == 0) {
                return 1
            }
            return filteredCities.count
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchBar.text != "" {
            if (filteredCities.count == 0) {
                let no_result_cell = tableView.dequeueReusableCell(withIdentifier: "no-result")
                no_result_cell!.selectionStyle = .none
                print("noresult")
                return no_result_cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "city_cell", for: indexPath) as? CityTableViewCell
                let imageData = filteredCities[(indexPath as NSIndexPath).row].image
                cell?.featureImage.image = UIImage(data: imageData as Data)
                cell?.cityLabel.text = filteredCities[(indexPath as NSIndexPath).row].cityAlias
                return cell!
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "city_cell", for: indexPath) as? CityTableViewCell
            let imageData = cities[(indexPath as NSIndexPath).row].image
            if (indexPath as NSIndexPath).row % 2 == 0 {
                cell?.featureImage.image = UIImage(data: imageData as Data)
            } else {
                cell?.featureImage.image = UIImage(data: imageData as Data)
            }
            cell?.cityLabel.text = cities[(indexPath as NSIndexPath).row].cityAlias
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = self.restorationIdentifier {
            if !no_result {
                if id == "origin" {
                    if searchBar.text == "" {
                        searchFlight.origin = cities[(indexPath as NSIndexPath).row]
                    } else {
                        searchFlight.origin = filteredCities[(indexPath as NSIndexPath).row]
                    }
                    if let destVC = storyboard?.instantiateViewController(withIdentifier: "destination") as? TestViewController {
                        self.present(destVC, animated: true, completion: nil)
                    }
                } else {
                    if searchBar.text == "" {
                        searchFlight.dest = cities[(indexPath as NSIndexPath).row]
                    } else {
                        searchFlight.dest = filteredCities[(indexPath as NSIndexPath).row]
                    }
                    
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
                let translate = CGAffineTransform(translationX: 100, y: 0)
                cell.transform = translate
                UIView.animate(withDuration: 0.75, delay: 0.25 * viewCount, options: .curveEaseInOut, animations: {
                    cell.alpha = 1
                    self.viewCount+=0.25
                    cell.transform = CGAffineTransform.identity
                    }, completion: nil)
            }
        }
    }
    
    //SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        FilterCity(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        CloseInputView()
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Method
    func FilterCity(_ search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercased().contains(search.lowercased())
        })
        
        displayCell.removeAll()
        for _ in 0..<filteredCities.count {
            displayCell.append(true)
        }
        tableView.reloadData()
    }
    
    
}
