//
//  EmptyReviews.swift
//  Whois
//
//  Created by Peresvet Sobolev on 31.10.2019.
//  Copyright © 2019 Peresvet Sobolev. All rights reserved.
//

import UIKit

class EmptyReviewsView: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
