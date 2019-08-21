//
//  APIResults.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
    
    init(page: Int, total_results: Int,  total_pages: Int, results: [Movie]) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
}
