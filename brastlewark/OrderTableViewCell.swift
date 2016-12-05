//
//  OrderTableViewCell.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet var segmented: UISegmentedControl!
    var selectedIndex = 0
    var preference = UserDefaults.standard

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.segmented.selectedSegmentIndex = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func getOrder() -> OrderType {
        if selectedIndex == 0 {
            return .Age
        } else {
            return .Name
        }
    }
    
    @IBAction func selectedSegmentedAction(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        preference.set(selectedIndex, forKey: "Order")
    }

}
