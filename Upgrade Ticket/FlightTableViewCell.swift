//
//  FlightTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {

    @IBOutlet weak var airlinesLogo: UIImageView!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var transitFlag: UILabel!
    @IBOutlet weak var originFlight: UILabel!
    @IBOutlet weak var destFlight: UILabel!
    @IBOutlet weak var originCity: UILabel!
    @IBOutlet weak var destCity: UILabel!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var arrivalDate: UILabel!
    @IBOutlet weak var departAirport: UITextView!
    @IBOutlet weak var arrivalAirport: UITextView!
    @IBOutlet weak var transitDescription: UITextView!
    @IBOutlet weak var flightNumber: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        transitFlag.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
