//
//  SearchCityViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController,UISearchBarDelegate , UITableViewDataSource, UITableViewDelegate {
    
    var identifier = ""
    var cities = Array<City>()
    var filteredCities = Array<City>()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //searchFlight.activeResult = .Search
        
        self.cities = searchFlight.cities
        if identifier == "search_origin" {
            cities.RemoveByCityAlias(search: searchFlight.dest)
        }
        else if identifier == "search_destination" {
            cities.RemoveByCityAlias(search: searchFlight.origin)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tables
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "city_cell", for: indexPath)
        if searchBar.text != "" {
            if (filteredCities.count == 0) {
                cell.textLabel?.text = "No Result Found"
            } else {
                cell.textLabel?.text = filteredCities[(indexPath as NSIndexPath).row].cityAlias
            }
        } else {
            cell.textLabel?.text = cities[(indexPath as NSIndexPath).row].cityAlias
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text == "" {
            if identifier == "search_origin" {
                searchFlight.origin = cities[(indexPath as NSIndexPath).row]
            }
            else if identifier == "search_destination" {
                searchFlight.dest = cities[(indexPath as NSIndexPath).row]
            }
            self.performSegue(withIdentifier: "back_to_search", sender: self.closeButton)
        } else if (filteredCities.count > 0) {
            
            if identifier == "search_origin" {
                searchFlight.origin = filteredCities[(indexPath as NSIndexPath).row]
            }
            else if identifier == "search_destination" {
                searchFlight.dest = filteredCities[(indexPath as NSIndexPath).row]
            }
            self.performSegue(withIdentifier: "back_to_search", sender: self.closeButton)
        }
    }
    
    
    //SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        FillterCity(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        CloseInputView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchViewController {
            destination.UpdateCity()
        }
    }
    
    func CloseInputView() {
        self.view.endEditing(true)
    }
    
    //Method
    func FillterCity(_ search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercased().contains(search.lowercased())
        })
        tableView.reloadData()
    }

}
