//
//  DetailTransactionTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/26/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DetailTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var field: UILabel!
    @IBOutlet weak var value: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
