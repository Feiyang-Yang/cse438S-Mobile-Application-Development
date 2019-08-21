//
//  MovieDetails.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import Foundation
import UIKit

class MovieDetails: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navTop: UINavigationBar!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var idField: UILabel!
    @IBOutlet weak var releasedField: UILabel!
    @IBOutlet weak var voteAverageFiled: UILabel!
    var theMovie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fill movie with the name
        self.navigationItem.title = theMovie.name
        self.navItem.title = theMovie.name
        //Fill fileds
        self.releasedField.text = "\(self.theMovie.releaseDate)"
        self.voteAverageFiled.text = "\(self.theMovie.rating)"
        self.idField.text = "\(self.theMovie.id)"
        
        //Load images -  DispatchQueue fixed structrue come from in-class demonstration code of lecture 10
        //Code inspired from https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        DispatchQueue.global().async {
            let dataFetch = try? Data(contentsOf: URL(string: self.theMovie.url)!)
            DispatchQueue.main.async {
                if dataFetch == nil {
                    self.movieImage.image = #imageLiteral(resourceName: "Null")
                } else {
                    self.movieImage.image = UIImage(data: dataFetch!)
                }
            }
        }
    
    // Code from the demonstration code in class
    self.navItem.leftBarButtonItem = UIBarButtonItem(title: "< Movies", style: .plain, target: self, action: #selector(goBack))
    }
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct StoreStruct:Decodable{
        let array:[String]
    }
    private func getJSON(path: String) -> JSON
    {
        do {
            let url = URL(string: path)
        } catch {
            return JSON.null
        }
        do {
            let url = URL(string: path)
            let data = try Data(contentsOf: url!)
            let json = try JSONDecoder().decode(StoreStruct.self,from: data)
            return JSON(json)
        } catch {
            return JSON.null
        }
    }
    
    
    @IBAction func favoritesButton(_ sender: Any) {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String]
       
        if favorites == nil{ favorites = [ ] }
        //if favorites already contains movie
        if (favorites?.contains(theMovie.name))! {
            sucessAlert1()
        } else { //if favorites have not contain the movie,append to dictionary, and set the key
            sucessAlert2()
            favorites?.append(theMovie.name)
            UserDefaults.standard.set(favorites, forKey: "favorites")
        }
    }
    
    func sucessAlert1() {
        let alert = UIAlertController(title: " Wow !", message: "It has been added in the past! Seems you really like it!" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Get it ", style: .default, handler:nil))
        present(alert, animated:true, completion:nil)
    }
    
    func sucessAlert2() {
        let alert = UIAlertController(title: " Succeed !", message: "It is now in your favorites! " , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Get it ", style: .default, handler:nil))
        present(alert, animated:true, completion:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


