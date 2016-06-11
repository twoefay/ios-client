//
//  TokenCell.swift
//  Twoefay
//
//  Created by Anthony Nguyen on 5/22/16.
//  Copyright © 2016 Twoefay. All rights reserved.
//

import UIKit

class TokenCell: UITableViewCell {
    
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var issuerLabel: UILabel!

    
    override func prepareForReuse() {
        // clear the text before you reuse a box
        self.tokenLabel?.text = nil
        self.issuerLabel?.text = nil
    }
}
