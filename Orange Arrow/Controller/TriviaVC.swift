//
//  trivia.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase

class TriviaVC: UIViewController {
    
    @IBOutlet weak var questionsOfGame: UILabel!
    var passedTitle : String = ""
    var isPressed : [Bool] = [false,false,false,false]
    var currentNumberOfQuestion : Int = 0
    var level : Int = 0
    var methods = Methods()
    
    @IBOutlet var choiceBtn: [UIImageView]!
    @IBOutlet weak var timeTracker: UILabel!
    @IBOutlet weak var gradeTracker: UILabel!
    @IBOutlet var buttons: [UIButton] = []
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    var questionAll = Trivia()
    var grade : Int = 0
    var totalGrade : Int = 0
    var countdownTimer: Timer!
    var totalTime = 0

 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("===========\(level)")
        //calculate the total grades
        for singlePoint in questionAll.answers["level\(level)"]!{
            let sumGrade = singlePoint.reduce(0, {$0 + $1})
            totalGrade += sumGrade
        }
        gradeTracker.text = "0/\(totalGrade)"
        
        updateUI()
        startTimer()
        print(level)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // green means didnt choose, gray means has chosen
    @IBAction func chooseAnswer(_ sender: UIButton) {
        
        let numberOfButton = sender.tag

        
        if isPressed[numberOfButton] == true{
//            sender.backgroundColor = UIColor.green
            choiceBtn[numberOfButton].image = UIImage(named: "")
            isPressed[numberOfButton] = false
        }else if isPressed[numberOfButton] == false{
//            sender.backgroundColor = UIColor.gray
            choiceBtn[numberOfButton].image = UIImage(named: "approved.png")
            isPressed[numberOfButton] = true
        }
        
        //only to choose one button
        if isPressed[numberOfButton] {
            for btn in buttons {
                if btn.tag != numberOfButton{
                    btn.isEnabled = false
                }
            }
        }else{
            for btn in buttons {
                btn.isEnabled = true
            }
        }
  
    }
    
    @IBAction func confirmAnswer(_ sender: UIButton) {
        //to check if this is the last question,if it is last question then pop out result and play again or go back (dismiss)
        if currentNumberOfQuestion >= questionAll.questions[level].count - 1 {
            calculatePoint()
            endTimer()
            
    
            methods.accuracy = Float(grade)/Float(totalGrade) * 100 * 100

            methods.gameTime = timeTracker.text!
            methods.gameType = passedTitle
            
            methods.level = level
            
            methods.checkGradeAndPopAlert(gameToUnlock:0,targetVC:self,targetNVMother:navigationController!){
                self.startOver()
            }
            
            //to check if the grades is over 90%, if it is over then unlock the next level
//            if CGFloat(grade/totalGrade) >= 0.9 {
//                //unlock next level on firebase
//                var ref: DatabaseReference!
//                ref = Database.database().reference()
//                guard let userID = Auth.auth().currentUser?.uid else { fatalError("No User Sign In") }
//                ref.child("UsersInfo/\(userID)/Levels/0").setValue(level+1)
//                //send the alert to ask for store the result
//                //alert
//                let currentTime = timeTracker.text!
//                let accuracy: CGFloat = CGFloat(grade/totalGrade*100)
//                let message = "You finished level\(level)'s all questions with accuracy \(accuracy)% in \(currentTime). Do you want to keep your results?"
//                let alert = UIAlertController(title: "Congrats", message: message, preferredStyle: .alert)
////                let restartAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in self.storeResult(time: currentTime, accuracy:accuracy)})
//                let restartAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in self.methods.storeResult(time: currentTime, accuracy: accuracy, gameType: self.passedTitle, level: self.level)})
//                let cancelAction = UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in self.cancel()})
//                alert.addAction(cancelAction)
//                alert.addAction(restartAction)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//
//                    self.present(alert, animated: true, completion: nil)
//
//                }
//
//            }else{
//                //alert
//                print(grade)
//                print(totalGrade)
//                let accuracy: Float = Float(grade)/Float(totalGrade)*100*100
//                print(accuracy)
//                let currentTime = timeTracker.text!
//                let message = "You finished level\(level)'s all questions with accuracy \(accuracy.rounded()/100)% in \(currentTime), which is not enough to unlock level\(level+1). Do you want to play again?"
//                let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
//                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in self.startOver()})
//                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in self.cancel()})
//                alert.addAction(cancelAction)
//                alert.addAction(restartAction)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//
//                    self.present(alert, animated: true, completion: nil)
//
//                }
//            }
    
        }else{
            //if it is not last then update question, choices and add points
            calculatePoint()
            currentNumberOfQuestion += 1
            updateUI()
        }
  
    }
    
//    func cancel(){
//        navigationController?.popViewController(animated: true)
//    }
    
    func startOver(){
        currentNumberOfQuestion = 0
        grade = 0
        updateUI()
        totalTime = 0
        startTimer()
    }
    
    
    
//    func storeResult(time:String, accuracy:CGFloat){
//        let messageDB = Database.database().reference().child("Trivia")
//        guard let userID = Auth.auth().currentUser?.uid else { fatalError("No User Sign In") }
//
//        //to format date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE, MMMM, dd, yyyy HH:mm:ss a"
//        let date = formatter.string(from: Date())
//
//        let resultDictionary = ["level":level,"time":time,"accuracy":accuracy] as [String : Any]
//        messageDB.child("\(userID)/\(date)").setValue(resultDictionary)
//
//        //go back to main page
//        navigationController?.popViewController(animated: true)
////        messageDB.childByAutoId().setValue(messageDictionary){
////            (error,reference) in
////            if error != nil{
////                print(error!)
////            }else{
////                print("Message was saved in firebase")
////                self.messageTextfield.isEnabled = true
////                self.sendButton.isEnabled = true
////                self.messageTextfield.text = ""
////            }
////        }
//    }
    
    func updateUI(){
        //update the grade tracker
        gradeTracker.text = "current points is \(grade)/\(totalGrade)"
        //update question label
        questionsOfGame.text = questionAll.questions[level-1][currentNumberOfQuestion]
        //update choices label
        for (index,singleButton) in buttons.enumerated(){
            let buttonTitle = questionAll.choices[level-1][currentNumberOfQuestion][index]
            singleButton.setTitle("\(buttonTitle)",for: .normal)
        }
        //update button image
        for (index,_) in buttons.enumerated(){
//            singleButton.backgroundColor = UIColor.green
            choiceBtn[index].image = UIImage(named: "")
            isPressed[index] = false
        }
        //update progress bar
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(questionAll.questions[level-1].count)) * CGFloat(currentNumberOfQuestion+1)
        // upodate progress label
        progressLabel.text = "\(currentNumberOfQuestion + 1) / \(questionAll.questions[level-1].count)"
        //update choice isenable
        for btn in buttons {
            btn.isEnabled = true
        }
        
    }
    
    func calculatePoint(){
        for (index,_) in buttons.enumerated(){
            if choiceBtn[index].image == UIImage(named: "approved.png") {
                //the button has been chosed
                
                if questionAll.answers["level\(level)"]![currentNumberOfQuestion][index] == 1{
                    grade += 1
                    ProgressHUD.showSuccess("Correct")
                }else{
                    ProgressHUD.showError("Wrong")
                }
            }
        }
    }
    
    //timer
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeTracker.text = "\(timeFormatted(totalTime))"
        totalTime += 1
   
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }


    

}
