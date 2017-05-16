//
//  SinglePlayerSettingsViewController.swift
//  Tron
//
//  Created by Alex Dao on 8/13/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class SinglePlayerSettingsViewController: UIViewController {
    
    var player1: Player = Data.player1
    
	@IBOutlet weak var titleOfScreen: UILabel!
	
    var currentColorButtonOne: UIButton!
//    var currentColorButtonTwo: UIButton!

    
    
    @IBOutlet weak var invertedButton: UIButton!
    
    @IBOutlet weak var red: UIButton!
    
//    @IBOutlet weak var segment: UISegmentedControl!
    
    
    @IBOutlet weak var botSegment: UISegmentedControl!
    
    
    //var currentPlayer = player1//: Player! {
//        didSet {
//            nametextField.text = currentPlayer.name
//        }
//    }
    
    @IBAction func invertedButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        player1.inverted = sender.isSelected
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        player1.name = nametextField.text
		
		if titleOfScreen.text == "Online Play" {
			Data.player1 = player1
			performSegue(withIdentifier: "BeginOnlineSegue", sender: nil)
			
		} else {
			if botSegment.selectedSegmentIndex == 0 {
				Data.aiType = "Random"
			} else if botSegment.selectedSegmentIndex == 1 {
				Data.aiType = "Follow"
			} else if botSegment.selectedSegmentIndex == 2 {
				Data.aiType = "Insane"
			}
			
			performSegue(withIdentifier: "BeginAISegue", sender: self)
		}
		
    }
	
	
//    @IBAction func segmentControlPressed(sender: UISegmentedControl) {
//        currentPlayer.name = nametextField.text
//        
//        if sender.selectedSegmentIndex == 0 {
//            currentPlayer = player1
//            invertedButton.selected = currentPlayer.inverted
//            currentColorButtonTwo.layer.borderWidth = 0
//            currentColorButtonTwo.layer.borderColor = UIColor.clearColor().CGColor
//            currentColorButtonOne.layer.borderColor = UIColor.darkGrayColor().CGColor
//            currentColorButtonOne.layer.borderWidth = 7
//            
//        } else {
//            currentPlayer = player2
//            invertedButton.selected = currentPlayer.inverted
//            currentColorButtonOne.layer.borderWidth = 0
//            currentColorButtonOne.layer.borderColor = UIColor.clearColor().CGColor
//            currentColorButtonTwo.layer.borderColor = UIColor.darkGrayColor().CGColor
//            currentColorButtonTwo.layer.borderWidth = 7
//            
//        }
//    }
    
    @IBOutlet weak var nametextField: UITextField!
    
    @IBAction func ColorButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
//        if segment.selectedSegmentIndex == 0 {
//            currentColorButtonOne.layer.borderWidth = 0
//            currentColorButtonOne.layer.borderColor = UIColor.clearColor().CGColor
//            
//            currentPlayer.color = sender.backgroundColor!
//            
//            currentColorButtonOne = sender
//            currentColorButtonOne.layer.borderColor = UIColor.darkGrayColor().CGColor
//            currentColorButtonOne.layer.borderWidth = 7
//            
//        } else {
//            currentColorButtonTwo.layer.borderWidth = 0
//            currentColorButtonTwo.layer.borderColor = UIColor.clearColor().CGColor
//            
//            currentPlayer.color = sender.backgroundColor!
//            
//            currentColorButtonTwo = sender
//            currentColorButtonTwo.layer.borderColor = UIColor.darkGrayColor().CGColor
//            currentColorButtonTwo.layer.borderWidth = 7
//        }
        currentColorButtonOne.layer.borderWidth = 0
        currentColorButtonOne.layer.borderColor = UIColor.clear.cgColor

        player1.color = sender.backgroundColor!

        currentColorButtonOne = sender
        currentColorButtonOne.layer.borderColor = UIColor.darkGray.cgColor
        currentColorButtonOne.layer.borderWidth = 7
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        
        player1.name = "Player One"
//        player2.name = "Player Two"
        
//        currentPlayer = player1
        
        player1.color = UIColor.red
//        player2.color = UIColor.blueColor()
        
        nametextField.text = player1.name
        
        currentColorButtonOne = red
//        currentColorButtonTwo = blue
        
        currentColorButtonOne.layer.borderColor = UIColor.darkGray.cgColor
        currentColorButtonOne.layer.borderWidth = 7
        
        invertedButton.isSelected = false
        player1.inverted = false
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
