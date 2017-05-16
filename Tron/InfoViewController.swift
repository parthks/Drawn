//
//  InfoViewController.swift
//  Tron
//
//  Created by Parth Shah on 14/08/16.
//  Copyright © 2016 InParthWeTrust. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
		textView.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textView.isScrollEnabled = true
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
