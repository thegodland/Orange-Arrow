//
//  diy.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class DiyVC: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    var passedTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameTitle.text = passedTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
