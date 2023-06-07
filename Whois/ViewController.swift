//
//  ViewController.swift
//  Whois
//
//  Created by Peresvet Sobolev on 26/09/2019.
//  Copyright © 2019 Peresvet Sobolev. All rights reserved.
//

import UIKit
import SwiftPhoneNumberFormatter

class ViewController: UIViewController {
    @IBOutlet weak var phoneField: PhoneFormattedTextField!
    @IBOutlet weak var receiveReviews: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.prefix = "+7 "
        phoneField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "(###) ###-##-##")
        receiveReviews.isEnabled = false
        receiveReviews.alpha = 0.5
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reviewVC: ReviewsVC = segue.destination as! ReviewsVC
        if var phoneNumber = phoneField.phoneNumber() {
            phoneNumber.remove(at: phoneNumber.startIndex)
            reviewVC.callerNumber = phoneNumber
        }
    }

    @IBAction func phoneFieldValueChanged(_ sender: PhoneFormattedTextField) {
        if sender.phoneNumber()!.count != 11 {
            receiveReviews.isEnabled = false
            receiveReviews.alpha = 0.5
        }
        else {
            receiveReviews.isEnabled = true
            receiveReviews.alpha = 1.0
        }
    }
    
    
}
