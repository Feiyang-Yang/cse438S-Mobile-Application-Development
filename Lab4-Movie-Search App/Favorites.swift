//
//  Favorites.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import Foundation

//chache and demonstrate the movie names
class Favorites: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let UserDefault = UserDefaults.standard
    var movieNames: [String] = []
    var favoritesCheck:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchView()
//        var favoritesCheck = UserDefault.array(forKey: "favorites") as? [String]
//        favoritesCheck = checkEmpty( array: favoritesCheck)
        view()
        tableView.reloadData()
    }
    
    func launchView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func checkEmpty( array:[String]?) -> [String]{
        //if it contains no key, then it is set as a empty string array
        var arr = array
        if arr == nil{
         arr = []
        }
        return arr as! [String];
    }
    
    func view(){
        let userDefault = UserDefaults.standard
        let favorites = userDefault.array(forKey: "favorites") as? [String]
        if favorites == nil {
            self.movieNames = [" "]
        } else{
            self.movieNames = (favorites)!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view()
        tableView.reloadData()
    }
    
   
    // cells in table view get names, fixed code from demonstration code in class
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = movieNames[indexPath.row]
        return cell
    }
    
    //delete row
    // fixed code come from & inspired by demonstration code in class and the Video in Piazza by professor https://piazza.com/class/jlcqgg09j34df?cid=184
    // and https://stackoverflow.com/questions/24103069/add-swipe-to-delete-uitableviewcell/30136948
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //delete in String Array
        let UserDefault = UserDefaults.standard
        var favorites = UserDefault.array(forKey: "favorites") as! [String]
        favorites.remove(at: indexPath.row)
        UserDefaults.standard.set(favorites, forKey: "favorites")
        //delete in UI table
        self.movieNames.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        tableView.reloadData()
    }
    
    // fixed code from demonstration code in class and the Video in Piazza by professor https://piazza.com/class/jlcqgg09j34df?cid=184
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieNames.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func clearAll(_ sender: UIButton) {
        movieNames.removeAll()
        tableView.reloadData()
        removeRemain()
    }
    
    // code inspired by and come from https://stackoverflow.com/questions/43402032/how-to-remove-all-userdefaults-data-swift
    func removeRemain(){
        let bundle = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: bundle)
    }

}
