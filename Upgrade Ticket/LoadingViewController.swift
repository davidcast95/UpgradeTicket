//
//  LoadingViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 7/26/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
