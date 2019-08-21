//
//  ViewController.swift
//  FeiyangYang-Lab1
//
//  Created by 杨飞扬 on 2018/9/10.
//  Copyright © 2018年 Feiyang Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originalPrice: UITextField!
    @IBOutlet weak var discountLabel: UITextField!
    @IBOutlet weak var taxLabel: UITextField!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    @IBOutlet weak var exchange: UILabel!
    @IBOutlet weak var ChinaButton: UIButton!
    @IBOutlet weak var EUButton: UIButton!

    var oriPriceDouble:Double = 0
    var discountDouble:Double = 0
    var taxDouble:Double = 0
    var finalPriceDouble:Double = 0.0
    var finalPriceEU : Double = 0
    var finalPriceChina:Double = 0
    
    var flag:Int = 0
    
    @IBAction func updateFinalPrice(_ sender: UITextField){
        oriPriceDouble = convertInputToDouble(originalPrice)
        discountDouble = convertInputToDouble(discountLabel)
        taxDouble = convertInputToDouble(taxLabel)
        
        if (oriPriceDouble >= 0 && discountDouble >= 0 && discountDouble <= 100 && taxDouble >= 0){
            finalPriceDouble = oriPriceDouble * (1.0 - discountDouble/100.0) * (1.0 + taxDouble/100.0)
            let displayText = "$\(String(format: "%.2f", finalPriceDouble))"
            finalPriceLabel.text = displayText
        } else {
            finalPriceLabel.text = "Invalid Input!"
        }
    }
    @IBAction func EUExchange(_ sender: UIButton) {
        flag = 1
    }
    
    @IBAction func ChinaExchange(_ sender: UIButton) {
        flag = 2
    }
    
    @IBAction func updateExchange(_ sender: UITextField) {
        oriPriceDouble = convertInputToDouble(originalPrice)
        discountDouble = convertInputToDouble(discountLabel)
        taxDouble = convertInputToDouble(taxLabel)
        
        if (oriPriceDouble >= 0 && discountDouble >= 0 && discountDouble <= 100 && taxDouble >= 0 && flag == 0){
            exchange.text = "No Foreign Selected"
        } else if (oriPriceDouble >= 0 && discountDouble >= 0 && discountDouble <= 100 && taxDouble >= 0 && flag == 1){
            finalPriceEU = oriPriceDouble * (1-discountDouble/100) * (1+taxDouble/100) * 0.86
            let displayText = "€\(String(format: "%.2f", finalPriceEU))"
             exchange.text = displayText
        } else if (oriPriceDouble >= 0 && discountDouble >= 0 && discountDouble <= 100 && taxDouble >= 0 && flag == 2){
            finalPriceChina = oriPriceDouble * (1-discountDouble/100) * (1+taxDouble/100) * 6.87
            let displayText = "¥\(String(format: "%.2f", finalPriceChina))"
             exchange.text = displayText
        } else {
             exchange.text = "Invalid Input!"
        }
       
    }
    
    //Convert input to double
    //If there is no input yet, return 0
    //If the input cannot be change to double, like it is a name, return -1
    func convertInputToDouble (_ sender: UITextField)->Double {
        let inputString:String? = sender.text
        if (inputString == ""){
            return 0
        } else if (Double(inputString! ) == nil){
            // if there exists input,check if it is in right style
            return -1
        } else {
            let inputDouble:Double = Double(inputString!)!
            return inputDouble
        }
    }
    /*
    func getFinalPrice ()->Double{
        let oriPriceDouble = convertInputToDouble(originalPrice)
        let discountDouble = convertInputToDouble(discountLabel)
        let taxDouble = convertInputToDouble(taxLabel)
        
        var finalP: Double = 0.0
        if (oriPriceDouble >= 0 && discountDouble >= 0 && discountDouble <= 100 && taxDouble >= 0){
            let finalPrice:Double = oriPriceDouble * (1-discountDouble/100) * (1+taxDouble/100)
            return finalPrice
            finalP = finalPrice
        }
        
        return finalP
    }
 */
    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

