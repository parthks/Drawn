//
//  Data.swift
//  Tron
//
//  Created by Alex Dao on 8/11/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import Foundation

class Data {
    static var player1: Player = Player()
    static var player2: Player = Player()
    
    static var tron: Player = Player().tron()
    
    static var aiType: String = ""
	
	
	static var currentOnlinePlayer: PlayerNumber!
	static var currentOpponentPlayer: PlayerNumber!
	static var opponentOnlinePlayer: Player = Player()
	static var dominantScreenSizePlayer: Bool = false
    
    static var playingWithDifferentSizedPlayers: Bool = false
	static var madeOpenGameWithKey: String?
	
    static var gameHeight: Int!
    static var gameWidth: Int!
    
}