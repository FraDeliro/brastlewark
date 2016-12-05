//
//  FilterTableViewCell.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

class FilterWeightTableViewCell: UITableViewCell {
    
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
        let skinnierGnome = gnomes.sorted(by: self.sortedForValue).first
        let fatterGnome = gnomes.sorted(by: self.sortedForValue).last
        
        if let skinnier = skinnierGnome?.weight {
            slider.minimumValue = Float(skinnier)
        }
        
        if let fatter = fatterGnome?.height {
          slider.maximumValue = Float(fatter)
        }
        
        if !preference.bool(forKey: "FirstWeightFilterLunch") {
            preference.set(true, forKey: "FirstWeightFilterLunch")
            let average = ((slider.maximumValue-slider.minimumValue)/2+slider.minimumValue)
            slider.value = average
        } else {
            slider.value = preference.float(forKey: "WeightValue")
        }
        
        self.labelRange.text = self.getStringFromSliderValue(slider)
    }
    
    func sortedForValue(this:Gnome, that:Gnome) -> Bool {
        return this.weight ?? 0 <= that.weight ?? 0
    }
    
    func getValues() -> [Int] {
        preference.set(slider.value, forKey: "WeightValue")
        return [Int(slider.minimumValue), Int(slider.value)]
    }
    
    func getStringFromSliderValue(_ sender: UISlider) -> String {
        return "\(Int(Double(slider.minimumValue))) - \(Int(Double(slider.value))) \("kg")"
    }
    
    // MARK: - IBActions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.labelRange.text = self.getStringFromSliderValue(sender)
    }

    
}
