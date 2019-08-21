//
//  ColorButton.swift
//  FeiyangYang-Lab3
//
//  Created by 杨飞扬 on 10/2/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        //make it smooth, part of the code comes from and is inspired by
//        https://stackoverflow.com/questions/22316836/uilabel-layer-cornerradius-not-working-in-ios-7-1
//        round corner code from https://blog.csdn.net/wanglixin1999/article/details/48024115
        if (self.layer.frame.width <= self.layer.frame.height){
            self.layer.cornerRadius = self.layer.frame.width/2
        } else {
            self.layer.cornerRadius = self.layer.frame.height/2
        }
    }

}
