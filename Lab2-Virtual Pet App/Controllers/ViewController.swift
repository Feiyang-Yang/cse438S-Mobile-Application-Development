//
//  ViewController.swift
//  FeiyangYang-Lab2
//
//  Created by 杨飞扬 on 2018/9/20.
//  Copyright © 2018年 Feiyang Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Set outlets
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var feedButton: UIButton!
    
    @IBOutlet weak var happyLevelBar: DisplayView!
    @IBOutlet weak var foodLevelBar: DisplayView!
    
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
  
    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var birdButton: UIButton!
    @IBOutlet weak var bunnyButton: UIButton!
    @IBOutlet weak var fishButton: UIButton!
    
    //All the animals
    let petList: [Pet] = [Pet(_name: "dog", _type: .dog),
                          Pet(_name: "cat", _type: .cat),
                          Pet(_name: "bird", _type: .bird),
                          Pet(_name: "bunny", _type: .bunny),
                          Pet(_name: "fish", _type: .fish) ]
    
    // Set colors linked with animals in a dictionary
    let colorDictions: [Pet.animalType: UIColor] = [
        .dog: UIColor(red: 255/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1),
        .cat: UIColor(red: 180/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1),
        .bird: UIColor(red: 255/255.0, green: 172/255.0, blue: 97/255.0, alpha: 1),
        .bunny: UIColor(red: 190/255.0, green: 250/255.0, blue: 190/255.0, alpha: 1),
        .fish: UIColor(red: 240/255.0, green: 190/255.0, blue: 240/255.0, alpha: 1)]
    
    //Set pictures linked with pets in a dictionary
    let imageDictions: [Pet.animalType: UIImage?] = [
        .dog: UIImage(named: "dog"),
        .cat: UIImage(named: "cat"),
        .bird: UIImage(named: "bird"),
        .bunny: UIImage(named: "bunny"),
        .fish: UIImage(named: "fish")]
    
    // Pet who is on the screen
    var currentPet: Pet!{
        didSet{
            updateBars(animated:false)
        }
    }
    
    //Functions
    //Play
    @IBAction func petPlay(_ sender: Any) {
        currentPet.play()
         updateBars(animated: true)
        
        updatePets(pet: currentPet)
    }
    //Feed
    @IBAction func petFeed(_ sender: Any) {
        currentPet.feed()
        updateBars(animated: true)

        updatePets(pet: currentPet)
    }
    
    //Update values of the bar, if change pet type-static, else with dynamic effect
    func updateBars(animated: Bool){
        let happinessValue = CGFloat(currentPet.happyLevel / 10)
        let foodLevelValue = CGFloat(currentPet.foodLevel / 10)
        if (animated == false) {
            happyLevelBar.value = happinessValue
            foodLevelBar.value = foodLevelValue
        }else{
            happyLevelBar.animateValue(to: happinessValue)
            foodLevelBar.animateValue(to: foodLevelValue)
        }
        happyLabel.text = String(currentPet.happyLevel)
        foodLabel.text = String(currentPet.foodLevel)
    }
    
    @IBAction func youngAgain(_ sender: Any) {
        currentPet.youngAgain()
        updatePets(pet: currentPet)
    }
    
    
    // Change to corresponding pets when pressing button
    @IBAction func changeToDog(_ sender: Any) {
         updatePets(pet: petList[0])
    }
    
    @IBAction func changeToCat(_ sender: Any) {
         updatePets(pet: petList[1])
    }
    @IBAction func changeToBird(_ sender: Any) {
        updatePets(pet: petList[2])
    }
    @IBAction func changToBunny(_ sender: Any) {
         updatePets(pet: petList[3])
    }
    @IBAction func changeToFish(_ sender: Any) {
        updatePets(pet: petList[4])
    }
    
    // Switch to chosen pet and update display，incluidng color and picture
    func updatePets(pet: Pet) {
        var color:UIColor
        currentPet = pet
        let theColor = colorDictions[currentPet.type]
        color = theColor!
       
        
        
        //check if old
        if (pet.age >= 15) {
            bgImageView.backgroundColor = UIColor.gray
            happyLevelBar.color = UIColor.gray
            foodLevelBar.color = UIColor.gray
        } else {
            bgImageView.backgroundColor = color
            happyLevelBar.color = color
            foodLevelBar.color = color
        }
        
        petImageView.image = imageDictions[currentPet.type]!
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updatePets(pet: petList[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

