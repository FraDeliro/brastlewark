//
//  GnomeDetailController.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit
import AlamofireImage

class GnomeDetailController: UIViewController {

    //MARK: - Outlets & Variables
    @IBOutlet var imagePicture: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelAge: UILabel!
    @IBOutlet var labelHairColor: UILabel!
    @IBOutlet var labelGender: UILabel!
    @IBOutlet var labelHeight: UILabel!
    @IBOutlet var labelWeight: UILabel!
    @IBOutlet var labelFriends: UILabel!
    @IBOutlet var labelProfessions: UILabel!

    var gnome: Gnome?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let cachedAvatar = ApiEngine.shared.cachedImage(urlString: gnome?.thumbnail ?? "") {
            imagePicture.image = cachedAvatar.af_imageAspectScaled(toFill: CGSize(width: UIScreen.main.bounds.width, height: 125))
        } else {
            ApiEngine.shared.getGnomeImage(imageURL: gnome?.thumbnail ?? "", succedeedBlock: { (response) in
                let image = response as! UIImage
                self.imagePicture.image = image.af_imageAspectScaled(toFill: CGSize(width: 43, height: 43))
            }, andErrorBlock: { (error) in
                print("image error",error)
            })
        }
        labelName.text = gnome?.name ?? ""
        labelAge.text = "\(gnome?.age ?? 0) years"
        labelHairColor.text = gnome?.hair_color ?? ""
        let gender = gnome?.gender == Gender.man ? "Male" : "Female"
        labelGender.text = gender
        labelHeight.text = String(format: "%d cm", gnome?.height ?? 0)
        labelWeight.text = String(format: "%d kg", gnome?.weight ?? 0)
        var gnomeFriends = ""
        var gnomeProfessions = ""
        if let friends = gnome?.friends, let professions = gnome?.professions {
            gnomeFriends = friends.count > 0 ? "" : "\(gnome?.name ?? "Gnome") doesn't have friends"
            gnomeProfessions = professions.count > 0 ? "" : "\(gnome?.name ?? "Gnome") doesn't have a job"
            for index in 0..<friends.count {
                let friend = friends[index]
                gnomeFriends = gnomeFriends.appending(friend)
                if index != friends.count - 1 {
                   gnomeFriends = gnomeFriends.appending(" - ")
                }
            }
            for index in 0..<professions.count {
                let profession = professions[index]
                gnomeProfessions = gnomeProfessions.appending(profession)
                if index != professions.count - 1 {
                    gnomeProfessions = gnomeProfessions.appending(" - ")
                }
            }
        }
        
        labelFriends.text = gnomeFriends
        labelProfessions.text = gnomeProfessions
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
