//
//  FirebaseHelper.swift
//  Tron
//
//  Created by Alex Dao on 8/11/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import Foundation
import Firebase
import UIKit


enum PlayerNumber: Int {
	case one = 1
	case two = 2
}


class FirebaseHelper {
    static let databaseRef = FIRDatabase.database().reference()
	static var phoneHeight: Int! //set in the viewDidLoad of HomeViewController
	static var phoneWidth: Int!
	static var foundGame = false
	
	
	static func makeNewGameWithBlock(_ completion: ((_ key: String) -> Void) ) {
		let ref = databaseRef.child("Games").childByAutoId()
		let key = ref.key
		ref.setValue(["key": key, "readyPlayerOne": 1])
		Data.currentOnlinePlayer = PlayerNumber.one
		Data.currentOpponentPlayer = PlayerNumber.two
		completion(key)
		
	}
	
	static func addLocationAndBoostInGame(_ key: String, xcor: CGFloat, ycor: CGFloat/*, boostlev: Float*/,withPlayerNumber num: PlayerNumber) {
		print("adding location!")
		databaseRef.child("Games").child(key).child("\(num.rawValue)").child("realTimeSharing").setValue("\(xcor) \(ycor)")
		//databaseRef.child("Games").child(key).child("\(num.rawValue)").child("realTimeSharing").child("boostLev").setValue(boostlev)
		
	}
	
	//num refers to player you are observing
	static func getLocationAndBoostInGame(_ key: String, withPlayerNumber num: PlayerNumber, withBlock completion: @escaping (_ x: CGFloat, _ y: CGFloat/*, boostlev: Float*/) -> Void) {
		
		databaseRef.child("Games").child(key).child("\(num.rawValue)").child("realTimeSharing").observe(.value) { snap, prevChildKey in
			if snap.exists() {
				let snapInfo = snap.value as! String
				let nums = snapInfo.components(separatedBy: " ")
				let xcoor = CGFloat(Double(nums[0])! )
				let ycoor = CGFloat(Double(nums[1])! )
				completion(xcoor, ycoor/*, boostlev: boostLev*/)
			}
			
		}
		
			//let boostLev = snapInfo["boostLev"] as! Float
		//completion(x: xcoor, y: ycoor/*, boostlev: boostLev*/)
			
			
		//}
	}
	
	static func deleteRoom(_ key: String) {
		databaseRef.child("Games").child(key).removeValue()
	}
	
	static func deleteOpenGame(_ key: String) {
		databaseRef.child("OpenGames").child("\(phoneHeight!)").child(key).removeValue()
	}
	
	static func removeGameObservers(_ key: String, num: PlayerNumber) {
		foundGame = false
		
		databaseRef.child("Games").child(key).child("\(num.rawValue)").child("realTimeSharing").removeAllObservers()
	}
	
	
	
	static func getPlayerInfo(_ key: String, num: PlayerNumber, WithBlock completion:@escaping (_ onlinePlayer: Player) -> Void) {
		databaseRef.child("Games").child(key).child("\(num.rawValue)").observeSingleEvent(of: .childAdded) { snap, prevChildKey in
			
			let playerInfo = snap.value as! [String: AnyObject]
			let colorValues = playerInfo["color"] as! [String: NSNumber]
			let oppPhoneHeight = playerInfo["phoneHeight"] as! Int
			
			if oppPhoneHeight != FirebaseHelper.phoneHeight {
				Data.playingWithDifferentSizedPlayers = true
			} else {
				Data.playingWithDifferentSizedPlayers = false
			}
			
			if oppPhoneHeight <= FirebaseHelper.phoneHeight {
				databaseRef.child("Games").child(key).child("gameWidth").setValue(FirebaseHelper.phoneWidth)
				databaseRef.child("Games").child(key).child("gameHeight").setValue(FirebaseHelper.phoneHeight - 50)
				
				databaseRef.child("Games").child(key).child("playerWithGameHeight").setValue(Data.currentOnlinePlayer.rawValue)
				
				Data.dominantScreenSizePlayer = true
			}
			
			//let lol = colorValues["red"]

			let color = UIColor(
								red: (CGFloat(colorValues["red"]!.doubleValue)),
			                    green: (CGFloat(colorValues["green"]!.doubleValue)),
			                    blue: (CGFloat(colorValues["blue"]!.doubleValue)),
			                    alpha: (CGFloat(colorValues["alpha"]!.doubleValue))
								)
			
			Data.opponentOnlinePlayer.color = color
			Data.opponentOnlinePlayer.name = playerInfo["name"] as! String
			
			completion(Data.opponentOnlinePlayer)
		}
	}
	
	static func addPlayerInfo(_ key: String, num: PlayerNumber) {
		//let arr = CGColorGetComponents(Data.player1.color.CGColor)
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0
		
		Data.player1.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		let playerDict = [
							"name": "LOL",//Data.player1.name,
							"color":
								["red": red, "green": green, "blue": blue, "alpha": alpha],
							"phoneHeight": FirebaseHelper.phoneHeight,
			
							] as [String : Any]
		
		databaseRef.child("Games").child(key).child("\(num.rawValue)").child("playerInfo").setValue(playerDict)
		
	}
	
	
	
//	static func trackCancelForOpenGames(openKey: String, completion: ()) {
//		databaseRef.child("OpenGames").child()
//	}
	
	static func lookForOpenGames(_ cancelGoingBack:@escaping ()->Void, completion: @escaping (_ key: String) -> Void) {
		
		//check if there exists a game from same device
		let refSameDev = databaseRef.child("OpenGames").child(("\(phoneHeight!)"))
		refSameDev.observe(.value) { snap, prevChildKey in
			if snap.exists() && !foundGame{
				let allOpenRooms = snap.value as! [String: [String: AnyObject]]
				var openGameRoomKey = allOpenRooms.first!.0
				
				for (key, info) in allOpenRooms {
					
					if info["busy"] as! String != "1" {
						databaseRef.child("OpenGames").child(("\(phoneHeight!)")).child(openGameRoomKey).child("busy").setValue("1")
						openGameRoomKey = key
						refSameDev.removeAllObservers()
						cancelGoingBack()
						foundGame = true
						FirebaseHelper.makeNewGameWithBlock() {key in
							
							databaseRef.child("OpenGames").child("\(FirebaseHelper.phoneHeight)").child(openGameRoomKey).child("found").setValue(key)
							completion(key)
						}
						break
					}
					
				}
				
				

			} else {
				refSameDev.removeAllObservers()
				//check if there exists a game from other devices
				let refOtherDev = databaseRef.child("OpenGames")
				refOtherDev.observe(.value) { snap, prevChildKey in
					if snap.exists() && !foundGame{
						let allPhoneHeightCategories = snap.value as! [String: AnyObject]
						let tupleWithPhoneCatAndKey = phoneHeightToUse(allPhoneHeightCategories)
						cancelGoingBack()
						foundGame = true
						let usePhoneCat = tupleWithPhoneCatAndKey.0
						let openGameRoomKey: String? = tupleWithPhoneCatAndKey.1
						
						if let openRoomKey = openGameRoomKey {
							refOtherDev.removeAllObservers()
							databaseRef.child("OpenGames").child(usePhoneCat).child(openRoomKey).child("busy").setValue("1")
							
							FirebaseHelper.makeNewGameWithBlock() {key in
								databaseRef.child("OpenGames").child(usePhoneCat).child(openRoomKey).child("found").setValue(key)
								completion(key)
							}
						}
						
						
					} else {
						refOtherDev.removeAllObservers()
						//no current games exists so make a new open game
						if !foundGame {
							FirebaseHelper.makeOpenGame(cancelGoingBack, completion: completion)
						}
						
					}
				
				}
			}
			
		}
	}
	
	//helper function
	static func phoneHeightToUse(_ allPhoneHeightCategoriesAvail: [String: AnyObject]) -> (String, String?) {
		Data.playingWithDifferentSizedPlayers = true
		
		var bestPhoneScreen: String = allPhoneHeightCategoriesAvail.first!.0
		var allOpenRooms: [String: AnyObject] = allPhoneHeightCategoriesAvail.first!.1 as! [String: AnyObject]
		var minDistanceBwScreens: Int = 100000
		
		for (height, info) in allPhoneHeightCategoriesAvail {
			
			let currentPhoneScreen: Int = Int(height)!
			let currentDistanceBwScreens = max(FirebaseHelper.phoneHeight, currentPhoneScreen) - min(FirebaseHelper.phoneHeight, currentPhoneScreen)
			
			if currentDistanceBwScreens < minDistanceBwScreens {
				bestPhoneScreen = "\(currentPhoneScreen)"
				minDistanceBwScreens = currentDistanceBwScreens
				allOpenRooms = info as! [String : AnyObject]
			}
		}
		
		var openGameRoomKey: String? = nil
		
		for (key, info) in allOpenRooms {
			if info["busy"] as! String != "1" {
				openGameRoomKey = key
				databaseRef.child("OpenGames").child(("\(bestPhoneScreen)")).child(openGameRoomKey!).child("busy").setValue("1")
				break
			}
			
		}
		
		
		return (bestPhoneScreen, openGameRoomKey)
	}
	
	
	//person who joins the open game, is the one who makes the new game!
	
	static func makeOpenGame(_ cancelGoingBack: @escaping ()->Void, completion: @escaping (_ key: String) -> Void) {
		let ref = databaseRef.child("OpenGames").child("\(phoneHeight!)").childByAutoId()
		let key = ref.key
		ref.setValue(["found": "0", "phoneHeight": phoneHeight, "busy": "0"])
		Data.madeOpenGameWithKey = key
		
		let busyRef = databaseRef.child("OpenGames").child("\(phoneHeight)").child(key).child("busy")
		busyRef.observe(.value) {snap, _ in
			if snap.exists() {
				if snap.value as! String == "1" {
					cancelGoingBack()
					busyRef.removeAllObservers()
				}
			}
		}
		
		
		let foundRef = databaseRef.child("OpenGames").child("\(phoneHeight)").child(key).child("found")
		foundRef.observe(.value) { snap, prevChildkey in
			if snap.exists() {
				
				let gameKey = snap.value as! String
				if gameKey != "0" {
					foundRef.removeAllObservers()
					databaseRef.child("OpenGames").child("\(phoneHeight)").child(key).removeValue()
					Data.madeOpenGameWithKey = nil
					foundGame = true
					
					joinNewGame(gameKey)
					completion(gameKey)
				}
				
			}
			
			
		}
	}
	
	static func joinNewGame(_ key: String) {
		databaseRef.child("Games").child(key).child("readyPlayerTwo").setValue(1)
		Data.currentOnlinePlayer = PlayerNumber.two
		Data.currentOpponentPlayer = PlayerNumber.one
	}
	
	static func setGameWidthAndHeight(_ key: String, WithBlock completion:@escaping () -> Void) {
		let ref = databaseRef.child("Games").child(key).child("gameHeight")
		ref.observe(.value) { snap, prevChildKey in
			if snap.exists() {
				Data.gameHeight = snap.value as! Int
				databaseRef.child("Games").child(key).child("gameWidth").observeSingleEvent(of: .value) { snap, prevChildKey in
					
						Data.gameWidth = snap.value as! Int
						ref.removeAllObservers()
						completion()
					}
				
			}
		}
	}
	
	static func endGame(_ key: String, num: PlayerNumber) {
		databaseRef.child("Games").child(key).child("gameover").setValue("\(num.rawValue)")
	}
	
	static func listenForGameover(_ key: String, withCompletion completion: @escaping (_ num: String) -> Void) {
		let ref = databaseRef.child("Games").child(key).child("gameover")
			ref.observe(.value) { snap, prevChildKey in
			if snap.exists() {
				completion(snap.value as! String)
				ref.removeAllObservers()
				databaseRef.child("Games").child(key).child("size").removeAllObservers()
				removeGameObservers(key, num: Data.currentOpponentPlayer)
			}
		}
	}
	
	
	static func addSizeOfTrail(_ key: String, size: String) {
		databaseRef.child("Games").child(key).child("size").setValue(size)
	}
	
	static func getSizeOfTrail(_ key: String, withBlock completion: @escaping (_ size: CGFloat) -> Void) {
		let ref = databaseRef.child("Games").child(key).child("size")
		ref.observe(.value) { snap, _ in
			if snap.exists() {
				let sizeSTR = snap.value as! String
				let size = CGFloat(Double(sizeSTR)!)
				ref.removeAllObservers()
				completion(size)
			}
		}
	}
	
	
	static func startGame(_ key: String) {
		databaseRef.child("Games").child(key).child("startGame").setValue("1")
	}
	
	static func observeStartGame(_ key: String, withBlock completion: @escaping ()->Void) {
		let ref = databaseRef.child("Games").child(key).child("startGame")
		ref.observe(.value) { snap, _ in
			if snap.exists() {
				completion()
				ref.removeAllObservers()
			}
		}
	}
	
	
	
	
	
	
	
	
	
	static func rematchAgreedInRoom(_ key: String, byPlayer num: PlayerNumber) {
		databaseRef.child("Games").child(key).child("rematchPlayer\(num.rawValue)").setValue("1")
	}
	
	static func checkIfBothPlayersAgreedRematchInRoom(_ key: String, WithBlock completion: @escaping ()->Void) {
		let ref1 = databaseRef.child("Games").child(key).child("rematchPlayer1")
		ref1.observe(.value) { snap, _ in
			if snap.exists() {
				if snap.value as! String == "1" {
					let ref2 = databaseRef.child("Games").child(key).child("rematchPlayer2")
					ref2.observe(.value) { snap, _ in
						if snap.exists() {
							if snap.value as! String == "1" {
								completion()
								ref1.removeAllObservers()
								ref2.removeAllObservers()
							}
						}
					}
				}
			}
		}
		
	}
	
	
	static func removeRematchObserversInRoom(_ key: String) {
		databaseRef.child("Games").child(key).child("rematchPlayer1").removeAllObservers()
		databaseRef.child("Games").child(key).child("rematchPlayer2").removeAllObservers()
	}
	
	
	
	
	
	
}
