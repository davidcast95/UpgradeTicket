//
//  System.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/6/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum State : Int {
    case flight
    case login
    case proceed
    case payment
}

func FecthFromCoreData(_ entity:String) -> [NSManagedObject] {
    var returnResult = Array<NSManagedObject>()
    
    let appDelegate =
    UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    
    do {
        let results = try managedContext.fetch(fetchRequest)
        returnResult = results as! [NSManagedObject]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
    
    return returnResult
}

func SelectFromID(_ entity:String,id:Int) -> [NSManagedObject] {
    var returnResult = Array<NSManagedObject>()
    
    let appDelegate =
        UIApplication.shared.delegate as! AppDelegate
    
    let managedContext = appDelegate.managedObjectContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.predicate = NSPredicate(format: "id = \(id)", id)
    
    do {
        let results = try managedContext.fetch(fetchRequest)
        returnResult = results as! [NSManagedObject]
    } catch let error as NSError {
        print("Could not fetch \(error), \(error.userInfo)")
    }
    
    return returnResult
}

class Admin {
    var phone = ""
    var rekening = ""
    var conversion_points = ""
}

class City {
    var id = 0
    var city = ""
    var alias = ""
    var airport = ""
    var image = Data()
    
    func isSame(_ other:City) -> Bool {
        return self.id == other.id
    }
    
    func SaveToCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Destinations",in:managedContext)
        let cityContext = NSManagedObject(entity: entity!,insertInto: managedContext)
        cityContext.setValue(id, forKey: "id")
        cityContext.setValue(city, forKey: "city")
        cityContext.setValue(alias, forKey: "alias")
        cityContext.setValue(image, forKey: "image")
        cityContext.setValue(airport, forKey: "airport")
        do {
            try managedContext.save()
            print("\(airport) has been saved to core data")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    var cityAlias : String {
        return "\(city)  (\(alias)))"
    }
    
}

class Airlines {
    var id = 0
    var airlines = ""
    var image = Data()
    
    func isSame(_ other:Airlines) -> Bool {
        return self.id == other.id && self.airlines == other.airlines
    }
    
    func SaveToCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Airlines",in:managedContext)
        let cityContext = NSManagedObject(entity: entity!,insertInto: managedContext)
        cityContext.setValue(id, forKey: "id")
        cityContext.setValue(airlines, forKey: "airline")
        cityContext.setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
            print("\(airlines) has been saved to core data")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

}

class SearchFlight {
    var isRoundTrip = false
    var cities = Array<City>()
    var airlines = Array<Airlines>()
    var origin = City()
    var dest = City()
    var oneWay = true
    var passenger = 1
    var dateFlight = Date()
    var dateReturn = Date()
    var activeResult:State = .flight
    func Default() {
        if cities.count > 1 {
            origin = cities[0]
            dest = cities[1]
        }
        oneWay = true
        passenger = 1
    }
    
    func Print() {
        print("Flight from \(origin.city) to \(dest.city) for " + passenger.passengerFormat + " at \(dateFlight) and will return at \(dateReturn)")
    }
    
    func FindCityByCityAlias(_ text:String) -> City {
        let cityAlias = text.characters.split{$0 == " "}.map(String.init)
        for city in cities {
            if (cityAlias[0].lowercased() == city.city.lowercased() && cityAlias[1].lowercased() == "(\(city.alias.lowercased()))") {
                return city
            }
        }
        return City()
    }
    
    func FindCityById(_ id:Int) -> City {
        for city in cities {
            if city.id == id {
                return city
            }
        }
        return City()
    }
    
    func FindAirlinesById(_ id:Int) -> Airlines {
        for airline in airlines {
            if airline.id == id {
                return airline
            }
        }
        return Airlines()
    }
    
    func IsCityExist(_ predicate:City) -> Bool {
        var exist = false
        for city in cities {
            if city.id == predicate.id {
                exist = true
            }
        }
        return exist
    }
    func IsAirlinesExist(_ predicate:Airlines) -> Bool {
        var exist = false
        for airline in airlines {
            if airline.id == predicate.id {
                exist = true
            }
        }
        return exist
    }
    func Swap() {
        let temp = origin
        origin = dest
        dest = temp
    }
}


class Passenger {
    var fullname = ""
    var birthdate = ""
    init(fullname:String,birthdate:String) {
        self.fullname = fullname
        self.birthdate = birthdate
    }
    func Set(_ fullname:String,birthdate:String) {
        self.fullname = fullname
        self.birthdate = birthdate
    }
    func IsValid() -> Bool {
        return fullname != "" && birthdate != ""
    }
}
class Flight {
    var airlines = Airlines()
    var id = "0"
    var number = ""
    var from = City()
    var to = City()
    var departure = Date()
    var arrival = Date()
    var price = 0.0
    var points = 0
    var type = ""
    var tax = 0.0
    var transit = ""
    func Print() {
        print("\(number) " + "from \(from.cityAlias) to \(to.cityAlias)" + " depart at \(departure) arrive at \(arrival)" + " with price \(price)")
    }
}


class Reservation {
    var passengers = Array<Passenger>()
    var flight = Flight()
    var back = Flight()
    init() {
    }
    func Flush() {
        passengers.removeAll()
        flight = Flight()
    }
}

class Transaction {
    var id = 0
    var status = -1
    var passenger = 0
    var from = ""
    var to = ""
    var flight_number = ""
    var arrival = Date()
    var departure = Date()
    var passengers = Array<Passenger>()
    var payment_method = ""
    var card_number = ""
    var card_holder = ""
    var total:Double = 0
    
    func SaveToCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Transactions",in:managedContext)
        let transactionContext = NSManagedObject(entity: entity!,insertInto: managedContext)
        transactionContext.setValue(id, forKey: "id")
        transactionContext.setValue(status, forKey: "status")
        transactionContext.setValue(passenger, forKey: "passenger")
        transactionContext.setValue(from, forKey: "from")
        transactionContext.setValue(to, forKey: "to")
        transactionContext.setValue(flight_number, forKey: "flight_number")
        transactionContext.setValue(arrival, forKey: "arrival")
        transactionContext.setValue(departure, forKey: "departure")
        transactionContext.setValue(payment_method, forKey: "payment_method")
        transactionContext.setValue(card_holder, forKey: "card_holder")
        transactionContext.setValue(card_number, forKey: "card_number")
        transactionContext.setValue(total, forKey: "total")
        
        do {
            try managedContext.save()
            print("\(id) has been saved to core data")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

var admin = Admin()
var searchFlight = SearchFlight()
var reservation = Reservation()
var activeUser = UserDefaults()
var history = Array<Transaction>()
var viewTransaction = Transaction()
var tryattemp = 1
var thankyou = false
var payment_method = ""

func SystemReset() {
    searchFlight = SearchFlight()
    reservation = Reservation()
    history.removeAll()
    viewTransaction = Transaction()
}
