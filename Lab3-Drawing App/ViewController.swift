//
//  ViewController.swift
//  FeiyangYang-Lab3
//
//  Created by 杨飞扬 on 10/3/18.
//  Copyright © 2018 Feiyang Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //currentColor = colorButton0.backgroundColor
        changeColor(colorButton0)
        updateButtons()
        isBrush = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var thicknessSlider: UISlider!
    @IBOutlet weak var colorButton0: ColorButton!
    @IBOutlet weak var selectionIndicator: ColorButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var alphaTextField: UITextField!
    // text
    var isBrush : Bool!
    var currTextField : UITextField?
    var currentPath: PathView?
    var currentColor: UIColor?
    var currentAlpha: Int = 100
    var paths: [PathView] = [PathView] () {
        didSet {
            updateButtons()
        }
    }
    var redoPaths: [PathView] = [PathView] () {
        didSet {
            updateButtons()
        }
    }
    func updateButtons () {
        clearButton.isEnabled = (paths.count > 0)
        undoButton.isEnabled = (paths.count > 0)
        redoButton.isEnabled = (redoPaths.count > 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        redoPaths = [PathView] ()
        let thickness = CGFloat(thicknessSlider.value)
        let alpha = CGFloat(Double(currentAlpha)/100.0)
        
        let touchPoint = (touches.first)!.location(in: view) as CGPoint

        if isBrush==false {
            let frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: view.frame.width - touchPoint.x, height: 15 + thickness * 4)
            currTextField = UITextField(frame: frame)
            currTextField!.font = UIFont.systemFont(ofSize: 5 + thickness * 2)
            currTextField!.textColor = currentColor
            currTextField!.tintColor = currentColor
            currTextField!.addTarget(self, action: #selector(fillTextEnd(textField:)), for: UIControlEvents.editingDidEnd)
            currTextField!.becomeFirstResponder()
            view.addSubview(currTextField!)
        } else {
            // Need to minus 70 for the occupation of navigator bar
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 70)
            currentPath = PathView(frame: frame)
            currentPath!.thePath = BoardPath(points: [touchPoint], thickness: thickness, color: currentColor!, alpha: alpha)
            view.addSubview(currentPath!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = (touches.first)!.location(in: view) as CGPoint
        let thickness = CGFloat(thicknessSlider.value)
 
        if isBrush==false {
            for touch in touches {
                let touchPoint = touch.location(in: view)
                currTextField!.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: view.frame.width - touchPoint.x, height: 15 + thickness * 4)
            }
        } else{
            currentPath!.thePath?.points.append(touchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = (touches.first)!.location(in: view) as CGPoint
        let thickness = CGFloat(thicknessSlider.value)
        
        if isBrush==false {
            currTextField!.frame = CGRect(x: touchPoint.x, y: touchPoint.y, width: view.frame.width - touchPoint.x, height: 15 + thickness * 4)
        } else{
            currentPath!.thePath?.points.append(touchPoint)
            paths.append(currentPath!)
            currentPath = nil
        }
    }

    @IBAction func clearBoard(_ sender: Any) {
        for p in paths{
            p.removeFromSuperview()
        }
        paths = [PathView] ()
        redoPaths = [PathView] ()
    }
    
    @IBAction func undoBoard(_ sender: Any) {
        let p: PathView = paths.removeLast()
        p.removeFromSuperview()
        redoPaths.append(p)
    }
    
    @IBAction func redoBoard(_ sender: Any) {
        let p: PathView = redoPaths.removeLast()
        view.addSubview(p)
        paths.append(p)
    }
    
    // part of the code come form and is inspired byhttps://www.jianshu.com/p/7692b94b173d
    @IBAction func changeColor(_ sender: ColorButton) {
        currentColor = sender.backgroundColor
        let pointerX = sender.frame.maxX - selectionIndicator.frame.width/2
        let pointerY = selectionIndicator.frame.origin.y
        selectionIndicator.frame.origin = CGPoint(x:pointerX, y: pointerY)
    }
    
    @IBAction func changeAlpha(_ sender: UITextField) {
        let input: Int? = Int(alphaTextField.text!)
        
        if (input == nil) {
            currentAlpha = 100
            alphaTextField.text = String(currentAlpha)
        } else if (input!<0 || (input)!>100){
            currentAlpha = 100
            alphaTextField.text = String(currentAlpha)
        } else if (input!<=100 && input!>=0){
            currentAlpha = input!
            alphaTextField.text = String(currentAlpha)
        }
    }
    
    //text
    @IBAction func changeToText(_ sender: UIButton) {
         isBrush = false
    }
    
    @IBAction func changeToBrush(_ sender: UIButton) {
        isBrush = true
        if currTextField != nil {
            currTextField!.resignFirstResponder()
        }
    }
    
    //text
    @objc func fillTextEnd(textField: UITextField) {
        if textField.text! == "" {
            textField.removeFromSuperview()
        }
        
        textField.sizeToFit()
        textField.isEnabled = false
    }
    
}

