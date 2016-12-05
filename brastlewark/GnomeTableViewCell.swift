//
//  GnomeTableViewCell.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GnomeTableViewCell: UITableViewCell {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelAge: UILabel!
    @IBOutlet var roundAvatar: RoundAvatar!
    var downloadedImage: UIImage?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.labelName.text = ""
        self.roundAvatar.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(gnome: Gnome) {
        if let imageURL = gnome.thumbnail, let name = gnome.name, let age = gnome.age {
            labelName.text = name
            labelAge.text = "\("Age: ")\(age) years"
            if let cachedAvatar = ApiEngine.shared.cachedImage(urlString: imageURL) {
                roundAvatar.image = cachedAvatar.af_imageAspectScaled(toFill: CGSize(width: 43, height: 43))
            } else {
                ApiEngine.shared.getGnomeImage(imageURL: imageURL, succedeedBlock: { (response) in
                    self.downloadedImage = response as? UIImage
                    self.roundAvatar.image = self.downloadedImage?.af_imageAspectScaled(toFill: CGSize(width: 43, height: 43))
                }, andErrorBlock: { (error) in
                    print("image error",error)
                   self.roundAvatar.af_setImage(withURL: URL(string: imageURL) ?? URL(string: "www.google.com")!)
                })
            }
        }
    }

}
