//
//  DestFlightViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/5/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DestFlightViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var cities = Array<City>()
    var filteredCities = Array<City>()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchFlight.activeResult = .flight
        self.cities = searchFlight.cities
    }

    override func viewWillAppear(_ animated: Bool) {
        self.cities.RemoveByCityAlias(search: searchFlight.origin)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table
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
            searchFlight.dest = cities[(indexPath as NSIndexPath).row]
        } else {
            searchFlight.dest = filteredCities[(indexPath as NSIndexPath).row]
        }
    }
    
    //MARK: SearchBar
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
    
    //MARK: Method
    func CloseInputView() {
        self.view.endEditing(true)
    }
    func FillterCity(_ search:String) {
        filteredCities = cities.filter({
            city in
            return city.cityAlias.lowercased().contains(search.lowercased())
        })
        tableView.reloadData()
    }
}
