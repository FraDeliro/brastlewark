//
//  FilterTableViewCell.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

class FilterAgeTableViewCell: UITableViewCell {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var labelRange: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(gnomes: [Gnome]) {
        slider.minimumValue = 0
        slider.maximumValue = 100
        let youngerGnome = gnomes.sorted(by: self.sortedForValue).first
        let olderGnome = gnomes.sorted(by: self.sortedForValue).last
        
        if let youngerAge = youngerGnome?.age {
            slider.minimumValue = Float(youngerAge)
        }
        
        if let olderAge = olderGnome?.age {
          slider.maximumValue = Float(olderAge)
        }
        
        if !preference.bool(forKey: "FirstAgeFilterLunch") {
            preference.set(true, forKey: "FirstAgeFilterLunch")
            let average = ((slider.maximumValue-slider.minimumValue)/2+slider.minimumValue)
            slider.value = average
        } else {
            slider.value = preference.float(forKey: "AgeValue")
        }
       
        self.labelRange.text = self.getStringFromSliderValue(slider)
    }
    
    func sortedForValue(this:Gnome, that:Gnome) -> Bool {
        return this.age ?? 0 <= that.age ?? 0
    }
    
    func getValues() -> [Int] {
        preference.set(slider.value, forKey: "AgeValue")
        return [Int(slider.minimumValue), Int(slider.value)]
    }
    
    func getStringFromSliderValue(_ sender: UISlider) -> String {
        return "\(Int(Double(slider.minimumValue))) - \(Int(Double(slider.value))) \("years")"
    }
    
    // MARK: - IBActions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.labelRange.text = self.getStringFromSliderValue(sender)
    }

    
}
