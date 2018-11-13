//
//  HistoryTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/11/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var destinationFlight: UILabel!
    @IBOutlet weak var flightDetail: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var arrive: UILabel!
    @IBOutlet weak var passenger: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var confirmed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
