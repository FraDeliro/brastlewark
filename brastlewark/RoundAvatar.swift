//
//  RoundAvatar.swift
//  CharityStarsV2
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import UIKit

@IBDesignable class RoundAvatar: UIImageView {
    
    @IBInspectable var borderColor: UIColor? = UIColor.lightGray {
        didSet {
            self.commonInit()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            self.commonInit()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commonInit()
    }
    
    func commonInit() {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderColor != nil ? borderWidth : 0
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.commonInit()
    }

}
