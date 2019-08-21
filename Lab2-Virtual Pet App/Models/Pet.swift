//
//  Pet.swift
//  FeiyangYang-Lab2
//
//  Created by 杨飞扬 on 2018/9/20.
//  Copyright © 2018年 Feiyang Yang. All rights reserved.
//

import Foundation
class Pet{
    
    //<---Data--->
    // food and hapyyniess
    private (set) var happyLevel :Double = 0
    private (set) var foodLevel :Double = 0
    
    var name: String?

    var age:Int = 0
    var oldAge:Int = 15
    
    //Type of the pet
    var type : animalType
    enum animalType {
        case dog
        case cat
        case bird
        case bunny
        case fish
    }
    
    
    //<---Behavior--->
    func feed() {
        foodLevel += 1
        if(foodLevel > 10){
            foodLevel = 10
        }
        getOlder()
    }
    
    func play() {
        if(foodLevel > 0){
            foodLevel -= 1
            happyLevel += 1
            getOlder()
        } else {
            foodLevel = 0
        }
        
        if(happyLevel > 10){
            happyLevel = 10
        }
        
    }
    
    
    func youngAgain() {
        happyLevel = 0
        foodLevel = 0
        age = 0
    }
    
    func getOlder() {
        age = age + 1
    }
    
    //Init
    init(_name: String, _type: animalType){
        name = _name
        type = _type
        age = 0
        oldAge = 15
    }
}
