//
//  PrepOnlineViewController.swift
//  Tron
//
//  Created by Parth Shah on 11/08/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class PrepOnlineViewController: UIViewController {

	
	@IBOutlet weak var cancelButton: UIButton!
	
	
	
	@IBAction func goHome(_ sender: AnyObject) {
		if let openGameKey = Data.madeOpenGameWithKey {
			FirebaseHelper.deleteOpenGame(openGameKey)
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var countdown: UILabel!
	var countdownNum = 3
	var timer: Timer!
	@IBOutlet weak var infoLabel: UILabel!
	var key: String!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	func cancelCancelButton() {
		
		cancelButton.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		cancelButton.isEnabled = true
		activityIndicator.startAnimating()
		infoLabel.text = "Looking For Games"
		FirebaseHelper.lookForOpenGames(cancelCancelButton) { [unowned self] key in
			self.cancelButton.isEnabled = false
			self.key = key
			self.startCountdown()
			
		}
	}
	
	func startCountdown() {
		activityIndicator.stopAnimating()
		infoLabel.text = "Ready Player One"
		FirebaseHelper.getPlayerInfo(key, num: Data.currentOpponentPlayer) { [unowned self] oppPlayer in
			Data.opponentOnlinePlayer = oppPlayer
			//print(Data.playingWithDifferentSizedPlayers)
			if (Data.playingWithDifferentSizedPlayers) {
				FirebaseHelper.setGameWidthAndHeight(self.key) {
					self.countdown.isHidden = false
					self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
				}
			} else {
				self.countdown.isHidden = false
				self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
			}
			
			
		}
		
		FirebaseHelper.addPlayerInfo(key, num: Data.currentOnlinePlayer)
		
		
		
	}
	
	func updateCountdown(){
		print("\(countdownNum)")
		countdownNum = countdownNum - 1
		countdown.text = "\(countdownNum)"
		if countdownNum == 0 {
			timer.invalidate()
			if Data.dominantScreenSizePlayer {
				performSegue(withIdentifier: "startOnlineGameSameScreen", sender: key)
			} else {
				performSegue(withIdentifier: "startOnlineGameScrollView", sender: key)
			}
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "startOnlineGameSameScreen" {
			let destination = segue.destination as! OnlineViewController
			destination.onlineKey = sender as! String
		} else if segue.identifier == "startOnlineGameScrollView"{
			let destination = segue.destination as! OnlineWithScrollViewController
			destination.onlineKey = sender as! String
			
		}
		
	}
	

}
