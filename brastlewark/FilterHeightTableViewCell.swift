//
//  FilterTableViewCell.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

class FilterHeightTableViewCell: UITableViewCell {
    
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
        let shorterGnome = gnomes.sorted(by: self.sortedForValue).first
        let tallerGnome = gnomes.sorted(by: self.sortedForValue).last
        
        if let shorter = shorterGnome?.height {
            slider.minimumValue = Float(shorter)
        }
        
        if let taller = tallerGnome?.height {
          slider.maximumValue = Float(taller)
        }
        
        if !preference.bool(forKey: "FirstHeightFilterLunch") {
            preference.set(true, forKey: "FirstHeightFilterLunch")
            let average = ((slider.maximumValue-slider.minimumValue)/2+slider.minimumValue)
            slider.value = average
        } else {
            slider.value = preference.float(forKey: "HeightValue")
        }
        
        self.labelRange.text = self.getStringFromSliderValue(slider)
    }
    
    func sortedForValue(this:Gnome, that:Gnome) -> Bool {
        return this.height ?? 0 <= that.height ?? 0
    }
    
    func getValues() -> [Int] {
        preference.set(slider.value, forKey: "HeightValue")
        return [Int(slider.minimumValue), Int(slider.value)]
    }
    
    func getStringFromSliderValue(_ sender: UISlider) -> String {
        return "\(Int(Double(slider.minimumValue))) - \(Int(Double(slider.value))) \("cm")"
    }
    
    // MARK: - IBActions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.labelRange.text = self.getStringFromSliderValue(sender)
    }

    
}
