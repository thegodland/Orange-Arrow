//
//  ViewController.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/1/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class MainPage: UIViewController {

    @IBOutlet weak var triviaButton: UIButton!
    @IBOutlet weak var puzzleButton: UIButton!
    @IBOutlet weak var wordsButton: UIButton!
    @IBOutlet weak var diyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! Intro
        if segue.identifier == "trivia"{
            
            destinationVC.game = triviaButton.currentTitle!
            print(destinationVC.game)
        } else if segue.identifier == "puzzle"{
            destinationVC.game = puzzleButton.currentTitle!
        }else if segue.identifier == "words"{
            destinationVC.game = wordsButton.currentTitle!
        }else if segue.identifier == "diy"{
            destinationVC.game = diyButton.currentTitle!
        }
    }

}

