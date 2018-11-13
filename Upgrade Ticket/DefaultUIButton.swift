//
//  DefaultUIButton.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/26/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DefaultUIButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.cornerRadius = 2
        
    }

}
