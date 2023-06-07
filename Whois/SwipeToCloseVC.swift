//
//  SwipeToCloseVC.swift
//  Whois
//
//  Created by Peresvet Sobolev on 25.11.2019.
//  Copyright © 2019 Peresvet Sobolev. All rights reserved.
//

import UIKit

class SwipeToCloseVC: UIViewController {
    
    @IBOutlet weak var arrowLabel: UILabel!
    
    var queue = DispatchQueue(label: "animation", qos: .utility)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.async { self.animateArrow() }
    }
    
    @IBAction func closeTutorial(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateArrow() {
        let options = UIView.AnimationOptions.repeat
                
        UIView.animate(withDuration: 1.0, delay: 0.0, options: options, animations: {
            
            self.arrowLabel.frame = CGRect(x: self.arrowLabel.frame.midX, y: self.arrowLabel.frame.midY - 20, width: self.arrowLabel.frame.width, height: self.arrowLabel.frame.height)
            
            self.arrowLabel.frame = CGRect(x: self.arrowLabel.frame.midX, y: self.arrowLabel.frame.midY + 20, width: self.arrowLabel.frame.width, height: self.arrowLabel.frame.height)

        }, completion: nil)
    }
    
    
    }
