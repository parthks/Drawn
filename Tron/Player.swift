//
//  Player.swift
//  Tron
//
//  Created by Alex Dao on 8/10/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import Foundation
import UIKit

class Player: NSObject {
    var name: String!
    var x: CGFloat = 0
    var y: CGFloat = 0
    var boostOn = false
    var direction: Direction = Direction.right
    var color: UIColor = UIColor.white
    var status = "alive"
    
    var timer: Timer!
    var boostLev: Float = 2.0
    var slider: UISlider!
    var inverted: Bool = false
    
    var wins = 0
    

//    init(x: CGFloat, y: CGFloat, direction: Direction, color: UIColor) {
//        self.x = x
//        self.y = y
//        self.direction = direction
//        self.color = color
//    }
//    
//    override init() {
//        direction = .up
//        color = UIColor.whiteColor()
//        super.init()
//    }
    func tron() -> Player {
        self.name = "Tron"
        self.color = UIColor.orange
        
        return self
    }
    
    func localBot() -> Player {
        self.name = "You"
        self.color = UIColor.red
        
        return self
    }
	
}
