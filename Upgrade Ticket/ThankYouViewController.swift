//
//  ThankYouViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 9/12/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    @IBOutlet weak var subtitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        subtitle.text = payment_method == "Transfer Bank" ? "Check your email for futher process" : "Call \(admin.phone) for further process"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SMSAPI() {
        let link = "http://mturl?apiusername=123&apipassword=123&mobileno=60121234567&senderid=onewa ysms&languagetype=1&message=hello"
    }

}
