//
//  DefaultUISearchBar.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/26/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DefaultUISearchBar: UISearchBar {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let textfield = self.subviews[1] as! UITextField
        textfield.font = UIFont(name: "Futura", size: 14)
        textfield.textColor = UIColor.black
        
    }

}
