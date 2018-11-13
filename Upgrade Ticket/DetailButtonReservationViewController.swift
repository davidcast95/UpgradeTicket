//
//  DetailButtonReservationViewController.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/28/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DetailButtonReservationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConfirmTap(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm Reservation", message: "You will confirm this reservation", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.Confirm()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CancelTap(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Cancel Reservation", message: "Are you sure to cancel this reservation? This action cannot be undo!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.Cancel()
        })
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func FindTransactionById(_ id:Int) -> Transaction {
        for hist in history {
            if hist.id == id {
                return hist
            }
        }
        return Transaction()
    }
    
    func Confirm() {
        let processingAlert = self.ProcessingAlert("Processing . . .")
        let postParameter = "idtransaksi=\(viewTransaction.id)"
        print(postParameter)
        let link = "http://rico.webmurahbagus.com/admin/API/ConfirmTransactionAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            self.EndProcessingAlert(processingAlert, complete: {
                if let result = String(data: data,encoding: String.Encoding.utf8) {
                    if result == "1" {
                        DispatchQueue.main.async(execute: {
                            self.FindTransactionById(viewTransaction.id).status = 4
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }

            })
        })

    }
    
    func Cancel() {
        let processingAlert = self.ProcessingAlert("Processing . . .")
        let postParameter = "idtransaksi=\(viewTransaction.id)"
        print(postParameter)
        let link = "http://rico.webmurahbagus.com/admin/API/CancelTransactionAPI.php"
        AjaxPost(link, parameter: postParameter, done: { (data) in
            self.EndProcessingAlert(processingAlert, complete: {
                if let result = String(data: data,encoding: String.Encoding.utf8) {
                    if result == "1" {
                        DispatchQueue.main.async(execute: {
                            self.FindTransactionById(viewTransaction.id).status = 1
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
                
            })
        })

    }
    
}
