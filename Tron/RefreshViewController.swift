//
//  RefreshViewController.swift
//  Tron
//
//  Created by Alex Dao on 8/12/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class RefreshViewController: UIViewController {

    var timer: Timer!
    
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)


        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        if from == "Bot" {
            performSegue(withIdentifier: "BotEndSegue", sender: self)
        } else {
            performSegue(withIdentifier: "FinishRefreshSegue", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FinishRefreshSegue" {
            timer.invalidate()
        }
    }
    

}
