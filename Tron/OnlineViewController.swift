//
//  OnlineViewController.swift
//  Tron
//
//  Created by Alex Dao on 8/11/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class OnlineViewController: UIViewController {

    @IBOutlet weak var background: UIView!
	@IBOutlet weak var player1Slider: UISlider!

	//var currentPlayer: Player = Data.currentOnlinePlayer
	
	
	@IBOutlet weak var AfterGameView: UIView!
	@IBOutlet weak var endingMessage: UILabel!
	
	var gameOver = false
	
	var onlineKey: String = ""
	
	var height: CGFloat = 0
	var width: CGFloat = 0
	
	
	var topView: UIView!
	
	var occupied: [(CGFloat, CGFloat)] = []
	var onlinePlayer = Data.player1
	
	var timer1:Timer!
	
	var size: CGFloat = 6
	
	var speed = 0.1
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		onlinePlayer.slider = player1Slider
		topView = background
		AfterGameView.isHidden = true
		
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		listenForOppPlayers()
		if Data.playingWithDifferentSizedPlayers {
			FirebaseHelper.getSizeOfTrail(onlineKey) { [unowned self] size in
				self.size = size
				self.set()
				FirebaseHelper.startGame(self.onlineKey)
			}
		} else {
			set()
			FirebaseHelper.startGame(self.onlineKey)
		}
		
		
	}
	
	func listenForOppPlayers(){
		FirebaseHelper.getLocationAndBoostInGame(onlineKey, withPlayerNumber: Data.currentOpponentPlayer) { [unowned self] x, y in
			
			Data.opponentOnlinePlayer.x = x
			Data.opponentOnlinePlayer.y = y
			self.addView(Data.opponentOnlinePlayer)
		
		}
		
		FirebaseHelper.listenForGameover(onlineKey) { [unowned self] playerNum in
			self.timer1.invalidate()
			self.gameOver = true
			print(playerNum)
			self.AfterGameView.isHidden = false
			self.view.bringSubview(toFront: self.AfterGameView)
			if playerNum == "\(Data.currentOnlinePlayer.rawValue)" {
				self.endingMessage.text = "You Lose! Keep at it, I know you can do this..."
			} else {
				self.endingMessage.text = "Congraulations! You WIN"
			}
			print("GAMEOVER")
		}
	}
	

 
	func set() {
		height = background.bounds.height// - bottomControlView.bounds.height // 2
		width = background.bounds.width
		occupied = []
		gameOver = false
		
		onlinePlayer.x = (width / 2) - (size / 2)
		
		if Data.currentOnlinePlayer == PlayerNumber.one {
			onlinePlayer.y = ((4 * height) / 5) - (size / 2) - ((((4 * height) / 5) - (size / 2)).truncatingRemainder(dividingBy: size))
			onlinePlayer.direction = .up
		} else {
			onlinePlayer.y = ((height) / 5) - (size / 2) - ((((height) / 5) - (size / 2)).truncatingRemainder(dividingBy: size))
			onlinePlayer.direction = .down
		}
		
		onlinePlayer.boostLev = 2
		
		
		FirebaseHelper.observeStartGame(onlineKey) { [unowned self] in
				self.addView(self.onlinePlayer)
				self.timer1 = Timer.scheduledTimer(timeInterval: self.speed, target: self, selector: #selector(self.makeView(_:)), userInfo: self.onlinePlayer, repeats: true)
				
				self.onlinePlayer.timer = self.timer1
			
			}
		
		
		
	}
	
	
	func contains(_ a:[(CGFloat, CGFloat)], v:(CGFloat, CGFloat)) -> Bool {
		let (c1, c2) = v
		for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
		return false
	}
	
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
	
	
	
	func checkCollide(_ player: Player) -> Bool {
		
		switch player.direction {
		case .up:
			let x: CGFloat = player.x
			let y: CGFloat = player.y - size
			
			return contains(occupied, v: (x,y))
			
			
			
		case .down:
			let x: CGFloat = player.x
			let y: CGFloat = player.y + size
			
			return contains(occupied, v: (x,y))
			
		case .left:
			let x: CGFloat = player.x - size
			let y: CGFloat = player.y
			
			return contains(occupied, v: (x,y))
			
		case .right:
			
			let x: CGFloat = player.x + size
			let y: CGFloat = player.y
			
			return contains(occupied, v: (x,y))
		}
	}
	
	func makeView(_ timer: Timer) {
		let player = timer.userInfo as! Player
		
		// BOOSTING PART ADDED!!
		if player.boostOn {
			if player.boostLev > 0 {
				player.boostLev = player.boostLev - (Float(speed) / 2.0)
				player.slider.setValue(Float(player.boostLev), animated: true)
			} else {
				turnBoostStateForPlayer(player)
			}
			
		} else {
			if player.boostLev < 2 {
				player.boostLev = player.boostLev + Float(speed) / 10.0
				player.slider.setValue(player.boostLev, animated: true)
			}
			
		}
		
		
		if checkCollide(player) {
			addDeathView(player)
			//            background.bringSubviewToFront(restartButton)
		} else {
			switch player.direction {
			case .up:
				if player.y <= size {
					//die function
					addDeathView(player)
				} else {
					player.y = player.y - size
					addView(player)
				}
				
				
				
			case .down:
				if player.y >= height - size {
					//die function
					addDeathView(player)
				} else {
					player.y = player.y + size
					addView(player)
				}
				
			case .left:
				if player.x <= size {
					//die function
					addDeathView(player)
				} else {
					player.x = player.x - size
					addView(player)
				}
				
				
			case .right:
				
				if player.x >= width - size {
					//die function
					addDeathView(player)
				} else {
					player.x = player.x + size
					addView(player)
				}
				
			}
		}
	}
	
	
	func addView(_ player: Player) {
		
		print("currentOnlinePlayer: \(Data.currentOnlinePlayer)")
		
		let rect = CGRect(x: player.x, y: player.y, width: size, height: size)
		let spot = UIView(frame: rect)
		
		if player != Data.opponentOnlinePlayer {FirebaseHelper.addLocationAndBoostInGame(onlineKey, xcor: player.x, ycor: player.y, withPlayerNumber: Data.currentOnlinePlayer)}

		spot.backgroundColor = player.color
		occupied.append((player.x,player.y))
		background.addSubview(spot)
	}
	
	func addDeathView(_ player: Player) {
		player.timer.invalidate()
		FirebaseHelper.endGame(onlineKey, num: Data.currentOnlinePlayer)
		print("i died!!")
		player.status = "dead"
		gameOver = true
		let rect = CGRect(x: player.x, y: player.y, width: size, height: size)
		let spot = UIView(frame: rect)
		spot.backgroundColor = UIColor.orange
		background.addSubview(spot)
	}
	
	
	@IBAction func player1UpButtonPressed(_ sender: AnyObject) {
		if onlinePlayer.direction != .down {
			onlinePlayer.direction = .up
		}
	}
	
	
	@IBAction func player1DownButtonPressed(_ sender: AnyObject) {
		if onlinePlayer.direction != .up {
			onlinePlayer.direction = .down
		}
	}
	
	// BOOSTING PART CHANGED!!
	@IBAction func player1BoostButtonPressed(_ sender: AnyObject) {
		turnBoostStateForPlayer(onlinePlayer)
	}
	
	
	// BOOSTING PART ADDED!!
	func turnBoostStateForPlayer(_ player: Player) {
		if !gameOver {
			if !player.boostOn {
				//LETS BOOST
				player.timer.invalidate()
				player.timer = Timer.scheduledTimer(timeInterval: speed/2, target: self, selector: #selector(makeView(_:)), userInfo: player, repeats: true)
				player.boostOn = !player.boostOn
			} else {
				//STOP BOOST
				player.timer.invalidate()
				player.timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(makeView(_:)), userInfo: player, repeats: true)
				player.boostOn = !player.boostOn
			}
		}
		
	}
	
	@IBAction func player1LeftButtonPressed(_ sender: AnyObject) {
		if onlinePlayer.direction == .right {
			onlinePlayer.direction = .up
		} else if onlinePlayer.direction == .down {
			if onlinePlayer.inverted {
				onlinePlayer.direction = .left
			} else {
				onlinePlayer.direction = .right
			}
		} else if onlinePlayer.direction == .left {
			onlinePlayer.direction = .down
		} else if onlinePlayer.direction == .up {
			onlinePlayer.direction = .left
		}
	}
	
	@IBAction func player1RightButtonPressed(_ sender: AnyObject) {
		if onlinePlayer.direction == .right {
			onlinePlayer.direction = .down
		} else if onlinePlayer.direction == .down {
			if onlinePlayer.inverted {
				onlinePlayer.direction = .right
			} else {
				onlinePlayer.direction = .left
			}
		} else if onlinePlayer.direction == .left {
			onlinePlayer.direction = .up
		} else if onlinePlayer.direction == .up {
			onlinePlayer.direction = .right
		}
	}
	
	
}







