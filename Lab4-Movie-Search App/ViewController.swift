//
//  ViewController.swift
//  FeiyangYang-Lab4
//
//  Created by 杨飞扬 on 10/17/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var webView: WKWebView!
    var movies = [Movie]()
    var theImageCache: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.navigationDelegate = self
        searchBar.delegate = self
        spinner.isHidden = true
        
        // Add creative openPage Button, code from demonstration code in class
        self.navBarItem.leftBarButtonItem = UIBarButtonItem(title: "Open Page", style: .plain, target: self, action: #selector(openWebTapped))
        
        launchStored()
        loadLaunchData()
        doneCollectionView()
        cacheImages()
    }
    
   
    
    //load the data when lauching APP
    func loadLaunchData() {
        
        let imageURL = "https://image.tmdb.org/t/p/w500/"
        let json = getJSON(path: "https://api.themoviedb.org/3/search/movie?api_key=d633377fdb90ec2003a71fdff722c87c&query=A&page=1")
        var posterURL = ""
        
        for fetchedData in json["results"].arrayValue {
            //For picture, if no poster in the database, use the Null picture instead
            if(fetchedData["poster_path"].stringValue == "") {
                posterURL = "Null.png"
            }
            if(fetchedData["poster_path"].stringValue != ""){
                posterURL = imageURL + fetchedData["poster_path"].stringValue
            }
            let id = fetchedData["id"].intValue
            let name = fetchedData["original_title"].stringValue
            let vote_average = fetchedData["vote_average"].doubleValue
            let releaseDate = fetchedData["release_date"].stringValue
            
            movies.append(Movie(name: name, url: posterURL, releaseDate: releaseDate, rating: vote_average, id: id))
        }
    }
    
    // load favorites already stored
    func launchStored() {
        let launchStore = UserDefaults.standard
        var launchFavorites = launchStore.array(forKey: "favorites") as? [String]
        if launchFavorites == nil { launchFavorites = [] }
    }
    
    //code very similar to demonstration code in class 8
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return movies.count
    }
    
    //load data to collection view, code very similar to demonstration code in class 8
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieIcon", for: indexPath) as! Cell
        
        myCell.textLabel.text! = movies[indexPath.row].name
        myCell.movieImage.image = theImageCache[indexPath.row]
        
        return myCell
    }
    
    // get into details by click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Details", sender: indexPath.row)
    }
    
    func doneCollectionView() {
        movieCollectionView.dataSource = self as UICollectionViewDataSource
        movieCollectionView.delegate = self as UICollectionViewDelegate
    }
    
    @IBAction func searchMovie(_ sender: UIButton) {
        searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMovie()
    }
    
    //show tv shows
    @IBOutlet weak var searchPlayButton: UIButton!
    @IBAction func searchTVPlays(_ sender: UIButton) {
        searchTV()
    }
    
    func searchMovie(){
     ensureInput()
     let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "+")
     if (searchBar.text != ""){
      self.spinner.startAnimating()
      self.spinner.isHidden = false
      DispatchQueue.global(qos: .userInteractive).async {
        self.fetchMovieData(name: searchText!)
        self.cacheImages()
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.movieCollectionView.reloadData()
        }
       }
     }
   }
    func searchTV(){
     ensureInput()
     let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "+")
     if (searchBar.text != ""){
        self.spinner.startAnimating()
        self.spinner.isHidden = false
        DispatchQueue.global(qos: .userInitiated).async {
            self.demoTV(name: searchText!)
            self.cacheImages()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.movieCollectionView.reloadData()
            }
        }
    }
   }
    func ensureInput(){
        if (searchBar.text == "") {
            let ac = UIAlertController(title: "Wow Empty Input", message: "You must input something for search" , preferredStyle: .alert)
            ac.addAction(UIAlertAction(title:"Get it", style: .default, handler:nil))
            present(ac, animated:true, completion:nil)
        }
    }
    //fetch data
    func fetchMovieData(name: String) {
        movies.removeAll()
        theImageCache.removeAll()
        movieCollectionView.reloadData()
        
        let json = getJSON(path: "https://api.themoviedb.org/3/search/movie?api_key=d633377fdb90ec2003a71fdff722c87c&query=\(name)&page=1")
        let imageURL = "https://image.tmdb.org/t/p/w500/"
        for result in json["results"].arrayValue {
            let name = result["original_title"].stringValue
            let rating = result["vote_average"].doubleValue
            let releaseDate = result["release_date"].stringValue
            let id = result["id"].intValue
            //if poster path doesn't exist
            if(result["poster_path"].stringValue == ""){
                let url = "Null.png"
                movies.append(Movie(name: name, url: url, releaseDate: releaseDate, rating: rating, id: id))
            }else{
                let url = imageURL + result["poster_path"].stringValue
                movies.append(Movie(name: name, url: url, releaseDate: releaseDate, rating: rating, id: id))
            }
        }
    }
    
   
    //fetch tv show data
    func demoTV(name: String) {
        // prepare for data from database
        let TVjson = getJSON(path: "https://api.themoviedb.org/3/search/tv?api_key=d633377fdb90ec2003a71fdff722c87c&query=\(name)&page=1")
        let posterURL = "https://image.tmdb.org/t/p/w500/"
        var url: String
        //remove the movie views and reload the screen
        theImageCache.removeAll()
        movies.removeAll()
        movieCollectionView.reloadData()
        
        for result in TVjson["results"].arrayValue {
            if(result["poster_path"].stringValue == "") {url = "Null.png" }
            else {url = posterURL + result["poster_path"].stringValue}
            let id = result["id"].intValue
            let title = result["original_name"].stringValue
            let rating = result["vote_average"].doubleValue
            let releaseDate = result["first_air_date"].stringValue
            movies.append(Movie(name: title, url: url, releaseDate: releaseDate, rating: rating, id: id))
        }
    }
    
    func cacheImages() {
        for movie in movies {
            let movieURL = URL(string: movie.url)
            let imageData = try? Data(contentsOf: movieURL!)
            if (imageData == nil){
                theImageCache.append(#imageLiteral(resourceName: "Null"))
            } else {
                let image = UIImage(data: imageData!)
                theImageCache.append(image!)
            }
        }
    }
    
    
 
    private func getJSON(path: String) -> JSON {
        guard let url = URL(string: path) else { return JSON.null }
        if let dataFetched = try? Data(contentsOf: url) {
            // Seems no need to decode here，just return Json-Styped data is enough
            //movies = try! JSONDecoder().decode([Movie].self, from: dataFetched)
            return JSON(data: dataFetched)
        } else {
                return JSON.null
        }
    }
    
    
    //Fixed code come from and inspired by https://stackoverflow.com/questions/24040692/prepare-for-segue-in-swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            let destination = segue.destination as? MovieDetails
            let movieIndex = sender as! Int
            destination!.theMovie = movies[movieIndex]
        }
    }

    
    // Creative - show webpage.  The code come from the demonstration code in class
    @objc func openWebTapped() {
        let webUrl = URL(string: "https://themoviedb.org/")!
        let myWebURLRequest = URLRequest(url: webUrl)
        webView.load(myWebURLRequest)
        
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "themoviedb.org", style: .default, handler: openPages))
        //ac.addAction(UIAlertAction(title: "google.com", style: .default, handler: openPages))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction!) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func openPages(action: UIAlertAction!) {
        performSegue(withIdentifier: "webpage", sender: AnyIndex.self)
    }
    
   
    //creative - filter those who has no poster
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only movies with posters
//        let ifPoster = defaults.bool(forKey: "withPoster")
//        posterSwitch.setOn(withPoster, animated: false)
//        withPosterArray = defaults.stringArray(forKey: "withPoster") [String]()
        self.movieCollectionView.reloadData()
    }
    
    // creative - user set the number of rows or colums
    // Number of columns
    // Number per row
    func userSttedCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cellPerRow
        return -1
    }
//    var theAPIResults: APIResults
    func numberOfColumns( _ collectionView: UICollectionView) -> Int {
//        return theAPIResults.total_results/cellPerRow
//        if movies.count > indexPath.row {
//            cell.titleLabel.text! = movies[indexPath.row].title
//        }
        return -1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
