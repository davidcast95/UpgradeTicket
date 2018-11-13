//
//  OneWayTicketTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/17/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class OneWayTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var destinationFlight: UILabel!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var passengerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var transitDescription: UITextView!
    @IBOutlet weak var transitLabel: UILabel!
    @IBOutlet weak var airport: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
