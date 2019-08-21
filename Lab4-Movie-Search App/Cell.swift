//
//  Cell.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import Foundation

// fixed code come from & inspired by the Video in Piazza by professor https://piazza.com/class/jlcqgg09j34df?cid=184

class Cell: UICollectionViewCell {
    //Every cell should show movie name and image
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var image: UIImage! {
        didSet {
            movieImage.image = image
        }
    }
    var movieName: String!{
        didSet {
            textLabel.accessibilityValue = movieName
        }
    }
}
