//
//  Movie.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import Foundation

struct Movie:Decodable {
    var id: Int
    var name: String
    var rating: Double
    var url: String
    var releaseDate: String
//    I don't need the following attributes for this APP
//    let overview: String
//    let vote_count:Int!
    
//    I cannot find any attributes related to rating like PG as in Lab4.pdf
    
    init(name: String, url: String,  releaseDate: String, rating: Double, id: Int) {
        self.name = name
        self.url = url
        self.releaseDate = releaseDate
        self.rating = rating
        self.id = id
    }
}
