//
//  intro.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/1/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class Intro: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var rule: UILabel!
    
    var game : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateChosenGame()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this is for the back button
    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateChosenGame () {
        if game == "Trivia" {
            let chosenGame = Trivia()
            gameTitle.text = chosenGame.title
            rule.text = chosenGame.rule
        }else if game == "Puzzle"{
            let chosenGame = Puzzle()
            gameTitle.text = chosenGame.title
            rule.text = chosenGame.rule
        }else if game == "DIY"{
            let chosenGame = Diy()
            gameTitle.text = chosenGame.title
            rule.text = chosenGame.rule
        }else if game == "Words"{
            let chosenGame = Words()
            gameTitle.text = chosenGame.title
            rule.text = chosenGame.rule
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        if gameTitle.text == "Trivia"{
            performSegue(withIdentifier: "gotoTrivia", sender: self)
        }else if gameTitle.text == "Puzzle"{
            performSegue(withIdentifier: "gotoPuzzle", sender: self)
        }else if gameTitle.text == "Words"{
            performSegue(withIdentifier: "gotoWord", sender: self)
        }else if gameTitle.text == "Diy"{
            performSegue(withIdentifier: "gotoDIY", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTrivia"{
            let destinationVC = segue.destination as! TriviaVC
            destinationVC.passedTitle = gameTitle.text!
        }else if segue.identifier == "gotoPuzzle"{
            let destinationVC = segue.destination as! PuzzleVC
            destinationVC.passedTitle = gameTitle.text!
        }else if segue.identifier == "gotoWord"{
            let destinationVC = segue.destination as! WordsVC
            destinationVC.passedTitle = gameTitle.text!
        }else if segue.identifier == "gotoDIY"{
            let destinationVC = segue.destination as! DiyVC
            destinationVC.passedTitle = gameTitle.text!
        }
    }
    
    
    
}
