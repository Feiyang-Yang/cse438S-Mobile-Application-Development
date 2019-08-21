//
//  WebPage.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import WebKit
import Foundation

//demonstrate the webpage
//Code similar to demonstration code in course
class Webpage: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var pageView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pageView)
        self.navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        pageView.load(URLRequest(url: URL(string: "https://themoviedb.org/")!))
    }
    //Code from demonstration code in course
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
