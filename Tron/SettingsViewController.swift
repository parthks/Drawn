//
//  SettingsViewController.swift
//  test
//
//  Created by Parth Shah on 10/08/16.
//  Copyright © 2016 Parth Shah. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var player1: Player = Data.player1
    var player2: Player = Data.player2

    var currentColorButtonOne: UIButton!
    var currentColorButtonTwo: UIButton!
    
    
    @IBOutlet weak var invertedButton: UIButton!
    
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var blue: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var currentPlayer: Player! {
        didSet {
            nametextField.text = currentPlayer.name
        }
    }
    
    @IBAction func invertedButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentPlayer.inverted = sender.isSelected
    }
    
	@IBAction func doneButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SettingsToStartGameSegue", sender: self)
        currentPlayer.name = nametextField.text
    }
	
	
    @IBAction func segmentControlPressed(_ sender: UISegmentedControl) {
        currentPlayer.name = nametextField.text
        
        if sender.selectedSegmentIndex == 0 {
            currentPlayer = player1
            invertedButton.isSelected = currentPlayer.inverted
            currentColorButtonTwo.layer.borderWidth = 0
            currentColorButtonTwo.layer.borderColor = UIColor.clear.cgColor
            currentColorButtonOne.layer.borderColor = UIColor.darkGray.cgColor
            currentColorButtonOne.layer.borderWidth = 7
            
        } else {
            currentPlayer = player2
            invertedButton.isSelected = currentPlayer.inverted
            currentColorButtonOne.layer.borderWidth = 0
            currentColorButtonOne.layer.borderColor = UIColor.clear.cgColor
            currentColorButtonTwo.layer.borderColor = UIColor.darkGray.cgColor
            currentColorButtonTwo.layer.borderWidth = 7
            
        }
    }
	
	@IBOutlet weak var nametextField: UITextField!
	
	@IBAction func ColorButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if segment.selectedSegmentIndex == 0 {
            currentColorButtonOne.layer.borderWidth = 0
            currentColorButtonOne.layer.borderColor = UIColor.clear.cgColor
            
            currentPlayer.color = sender.backgroundColor!
            
            currentColorButtonOne = sender
            currentColorButtonOne.layer.borderColor = UIColor.darkGray.cgColor
            currentColorButtonOne.layer.borderWidth = 7
            
        } else {
            currentColorButtonTwo.layer.borderWidth = 0
            currentColorButtonTwo.layer.borderColor = UIColor.clear.cgColor
            
            currentPlayer.color = sender.backgroundColor!
            
            currentColorButtonTwo = sender
            currentColorButtonTwo.layer.borderColor = UIColor.darkGray.cgColor
            currentColorButtonTwo.layer.borderWidth = 7
        }
        
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        player1.name = "Player One"
        player2.name = "Player Two"
        
        currentPlayer = player1
        
        player1.color = UIColor.red
        player2.color = UIColor.blue
        
        nametextField.text = player1.name
        
        currentColorButtonOne = red
        currentColorButtonTwo = blue
        
        currentColorButtonOne.layer.borderColor = UIColor.darkGray.cgColor
        currentColorButtonOne.layer.borderWidth = 7
        
        player1.inverted = false
        player2.inverted = false
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    @IBAction func onlinePlay(sender: UIButton) {
//        performSegueWithIdentifier("online", sender: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
