//
//  HomeViewController.swift
//  Tron
//
//  Created by Alex Dao on 8/12/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.phoneHeight = Int(view.frame.height)
        FirebaseHelper.phoneWidth = Int(view.frame.width)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onlineGameButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "online", sender: self)
    }
    
    @IBAction func unwindToHomeVC(_ segue: UIStoryboardSegue) {
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
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
