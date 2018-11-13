//
//  RoundTripTicketTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/19/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class RoundTripTicketTableViewCell: UITableViewCell {

    //MARK: destination properties
    @IBOutlet weak var destinationFlight: UILabel!
    @IBOutlet weak var airlinesDestination: UILabel!
    @IBOutlet weak var flightNumberDestination: UILabel!
    @IBOutlet weak var departureDestination: UILabel!
    @IBOutlet weak var arrivalDestination: UILabel!
    @IBOutlet weak var passengerDestination: UILabel!
    @IBOutlet weak var priceDestination: UILabel!
    @IBOutlet weak var taxDestination: UILabel!
    @IBOutlet weak var transitDestination: UITextView!
    @IBOutlet weak var airportDestination: UILabel!
    
    //MARK: returning properties
    @IBOutlet weak var returningFlight: UILabel!
    @IBOutlet weak var airlinesReturning: UILabel!
    @IBOutlet weak var flightNumberReturning: UILabel!
    @IBOutlet weak var departureReturning: UILabel!
    @IBOutlet weak var arrivalReturning: UILabel!
    @IBOutlet weak var passengerReturning: UILabel!
    @IBOutlet weak var priceReturning: UILabel!
    @IBOutlet weak var taxReturning: UILabel!
    @IBOutlet weak var transitReturning: UITextView!
    @IBOutlet weak var airportReturning: UILabel!
    
    @IBOutlet weak var subtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
