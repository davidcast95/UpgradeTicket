//
//  PersonTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var titleTextField: DefaultUITextField!
    @IBOutlet weak var personLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
