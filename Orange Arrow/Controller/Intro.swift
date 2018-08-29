//
//  intro.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/1/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
import Firebase

class Intro: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var rule: UILabel!
    var game : String = ""
    @IBOutlet weak var titleImg: UIImageView!
    var level : Int = 1
    
    @IBOutlet var levelBtns: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateChosenGame()
        titleImg.image = UIImage(named: "\(game)_banner.jpg")
        checkGameLevel()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
//    @IBAction func startGame(_ sender: UIButton) {
//        if gameTitle.text == "Trivia"{
//            performSegue(withIdentifier: "gotoTrivia", sender: self)
//        }else if gameTitle.text == "Puzzle"{
//            performSegue(withIdentifier: "gotoPuzzle", sender: self)
//        }else if gameTitle.text == "Words"{
//            performSegue(withIdentifier: "gotoWord", sender: self)
//        }else if gameTitle.text == "Diy"{
//            performSegue(withIdentifier: "gotoDIY", sender: self)
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTrivia"{
            let destinationVC = segue.destination as! TriviaVC
            destinationVC.passedTitle = gameTitle.text!
            destinationVC.level = level
        }else if segue.identifier == "gotoPuzzle"{
            let destinationVC = segue.destination as! PuzzleVC
            destinationVC.passedTitle = gameTitle.text!
            destinationVC.level = level
        }else if segue.identifier == "gotoWord"{
            let destinationVC = segue.destination as! WordsVC
            destinationVC.passedTitle = gameTitle.text!
            destinationVC.level = level
        }else if segue.identifier == "gotoDIY"{
            let destinationVC = segue.destination as! DiyVC
            destinationVC.passedTitle = gameTitle.text!
        }
    }
    
    //for level button to be touched
    
    @IBAction func levelbtnTouched(_ sender: UIButton) {
        level = sender.tag
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
    
    //function to check database current player related game level
    func checkGameLevel(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("UsersInfo").child(userID!).child("Levels").observe(.value) { (snapshot) in

//        }
//        ref.child("UsersInfo").child(userID!).child("Levels").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSArray ?? []
            
            var levelToBeOpen : Int = 0
            switch self.game
            {
            case "Trivia":
                levelToBeOpen = value[0] as! Int
            case "Puzzle":
                levelToBeOpen = value[1] as! Int
            case "Words":
                levelToBeOpen = value[2] as! Int
            case "DIY":
                levelToBeOpen = value[3] as! Int
            default:
                break
            }
//            let username = value?["username"] as? String ?? ""
            for (index,btn) in self.levelBtns.enumerated(){
                if index <= levelToBeOpen - 1 {
                    btn.isEnabled = true
                }else{
                    btn.isEnabled = false
                }
            }
        
//             ...
//        }) { (error) in
//            print(error.localizedDescription)
            //                    }
            
        }

    }
    
    
    
}
