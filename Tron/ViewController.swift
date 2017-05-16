//
//  ViewController.swift
//  Tron
//
//  Created by Alex Dao on size/10/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

enum Direction: String {
    case down = "down"
    case up = "up"
    case right = "right"
    case left = "left"
}

class ViewController: UIViewController {
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var afterGameView: UIView!
    
    
    var player1: Player = Data.player1
    var player2: Player = Data.player2
    
    var players = [Player]()
    
    var gameOver = false
    
    var tie = false
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var player1WinsLabel: UILabel!
    @IBOutlet weak var player1Name: UILabel!
    
    @IBOutlet weak var player2WinsLabel: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    
    
    @IBOutlet weak var player2Slider: UISlider!
    @IBOutlet weak var player1Slider: UISlider!
    @IBOutlet weak var bottomControlView: UIView!
    @IBOutlet weak var background: UIView!
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    
    var topView: UIView!
    
    var occupied: [(CGFloat, CGFloat)] = []
    
    var timer1:Timer!
    var timer2:Timer!
    
    
    // BOOSTING PART ADDED - TIMER AND LEV!!
//    var boostLev = 2.0
    
    let size: CGFloat = 6
    
    var speed = 0.08

    override func viewDidLoad() {
        super.viewDidLoad()
        players.append(player1)
        players.append(player2)
//        restartButton.hidden = true
        afterGameView.isHidden = true
//        afterGameView.removeFromSuperview()
        topView = background
        player1.slider = player1Slider
        player2.slider = player2Slider
       // player1.color = UIColor.redColor()
        //player2.color = UIColor.blueColor()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        set()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func set() {
        height = background.bounds.height// - bottomControlView.bounds.height // 2
        width = background.bounds.width
        occupied = []
        gameOver = false
        
        
        player1.x = (width / 2) - (size / 2)
        player1.y = ((4 * height) / 5) - (size / 2) - ((((4 * height) / 5) - (size / 2)).truncatingRemainder(dividingBy: size))
        player1.direction = .up
        player1.boostLev = 2

        addView(player1)
        
        timer1 = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(makeView(_:)), userInfo: player1, repeats: true)
        
        player1.timer = timer1
        
        
        
        player2.x = (width / 2) - (size / 2)
        player2.y = ((1 * height) / 5) - (size / 2) - ((((1 * height) / 5) - (size / 2)).truncatingRemainder(dividingBy: size))
        player2.direction = .down
        player2.boostLev = 2
        
        addView(player2)
        
        timer2 = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(makeView(_:)), userInfo: player2, repeats: true)
        
        player2.timer = timer2

    }
    
    func contains(_ a:[(CGFloat, CGFloat)], v:(CGFloat, CGFloat)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        for p in players {
            p.status = "alive"
            p.boostLev = 2
            if let slider = p.slider {
                slider.setValue(p.boostLev, animated: true)
            }
            p.boostOn = false
        }
        performSegue(withIdentifier: "LocalToHomeSegue", sender: self)
    }
    
    @IBAction func restartButtonPressed(_ sender: AnyObject) {
//        restartButton.hidden = true
//        afterGameView.removeFromSuperview()
        afterGameView.isHidden = true
        for p in players {
            p.status = "alive"
            p.boostLev = 2
            p.slider.setValue(p.boostLev, animated: true)
            p.boostOn = false
        }
//        let rect = CGRect(x: 0, y: 0, width: width, height: height)
//        let spot = UIView(frame: rect)
//        spot.backgroundColor = UIColor.blackColor()
//        background.addSubview(spot)
//
//        topView = spot
//        
//
//        set()
        
        performSegue(withIdentifier: "StartRefreshSegue", sender: self)
    }
    
    func checkCollide(_ player: Player) -> Bool {
        var other: Player!
        for p in players {
            if p != player {
                other = p
            }
        }
        
        let otherCoords = (other.x, other.y)
        
        switch player.direction {
        case .up:
            let x: CGFloat = player.x
            let y: CGFloat = player.y - size
            
            if otherCoords == (x,y) {
                tie = true
            }
            
            return contains(occupied, v: (x,y))
            
            
            
        case .down:
            let x: CGFloat = player.x
            let y: CGFloat = player.y + size
            
            if otherCoords == (x,y) {
                tie = true
            }
            
            return contains(occupied, v: (x,y))
            
        case .left:
            let x: CGFloat = player.x - size
            let y: CGFloat = player.y
            
            if otherCoords == (x,y) {
                tie = true
            }
            
            return contains(occupied, v: (x,y))
            
        case .right:
            
            let x: CGFloat = player.x + size
            let y: CGFloat = player.y
            
            if otherCoords == (x,y) {
                tie = true
            }
            
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
        
//        guard checkCollide(player) else {addDeathView(player); return}
        
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
        let rect = CGRect(x: player.x, y: player.y, width: size, height: size)
        let spot = UIView(frame: rect)
        spot.backgroundColor = player.color
        occupied.append((player.x,player.y))
        background.addSubview(spot)
    }
    
    func addDeathView(_ player: Player) {
        for p in players {
            p.timer.invalidate()
        }
        let rect = CGRect(x: player.x, y: player.y, width: size, height: size)
        let spot = UIView(frame: rect)
        spot.backgroundColor = UIColor.orange
        background.addSubview(spot)
        
        
        player.status = "dead"
        var winner: Player!
        
        if !tie {
            for p in players {
                if p.status != "dead" {
                    winner = p
                    p.wins += 1
                }
            }
            
            if let victor = winner.name {
                winnerLabel.text = "\(victor) has won!"
            } else {
                winnerLabel.text = "You have won!"
            }
        } else {
            //if it is a tie
            winnerLabel.text = "Tie Game"
        }
        
        player1WinsLabel.text = String(player1.wins)
        player1Name.text = player1.name
        player2WinsLabel.text = String(player2.wins)
        player2Name.text = player2.name
        
        
        gameOver = true
        afterGameView.isHidden = false
        let temp = afterGameView
        topView.addSubview(temp!)
        view.bringSubview(toFront: afterGameView)
    }
    
    
    @IBAction func player1UpButtonPressed(_ sender: AnyObject) {
        if player1.direction != .down {
            player1.direction = .up
        }
    }
    
    
    @IBAction func player1DownButtonPressed(_ sender: AnyObject) {
        if player1.direction != .up {
            player1.direction = .down
        }
    }
    
    // BOOSTING PART CHANGED!!
    @IBAction func player1BoostButtonPressed(_ sender: AnyObject) {
        turnBoostStateForPlayer(player1)
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
        if player1.direction == .right {
            player1.direction = .up
        } else if player1.direction == .down {
            if player1.inverted {
            player1.direction = .left
            } else {
                player1.direction = .right
            }
        } else if player1.direction == .left {
            player1.direction = .down
        } else if player1.direction == .up {
            player1.direction = .left
        }
    }
    
    @IBAction func player1RightButtonPressed(_ sender: AnyObject) {
        if player1.direction == .right {
            player1.direction = .down
        } else if player1.direction == .down {
            if player1.inverted {
                player1.direction = .right
            } else {
                player1.direction = .left
            }
        } else if player1.direction == .left {
            player1.direction = .up
        } else if player1.direction == .up {
            player1.direction = .right
        }
    }
    
    @IBAction func player2LeftButtonPressed(_ sender: AnyObject) {
        if player2.direction == .right {
            player2.direction = .up
        } else if player2.direction == .down {
            player2.direction = .right
        } else if player2.direction == .left {
            player2.direction = .down
        } else if player2.direction == .up {
            if player2.inverted {
                player2.direction = .right
            } else {
                player2.direction = .left
            }
        }

    }
    
    @IBAction func player2RightButtonPressed(_ sender: AnyObject) {
        if player2.direction == .right {
            player2.direction = .down
        } else if player2.direction == .down {
            player2.direction = .left
        } else if player2.direction == .left {
            player2.direction = .up
        } else if player2.direction == .up {
            if player2.inverted {
                player2.direction = .left
            } else {
                player2.direction = .right
            }
        }
    }
    

    @IBAction func player2BoostButtonPressed(_ sender: AnyObject) {
        turnBoostStateForPlayer(player2)
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "LocalToHomeSegue" {
            for p in players {
                p.wins = 0
            }
        }
    }

 

    
    
    



}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
}

}

