//
//  words.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class WordsVC : UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var middleArea: UIView!
    @IBOutlet weak var wordsSet: UILabel!
    @IBOutlet weak var hintContent: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var timerForGame: UILabel!
    @IBOutlet weak var answerArea: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    let questionAll = Words()
    var currentQuestion : Int = 0
    var passedTitle : String = ""
    var countdownTimer: Timer!
    var timeConstraint : Timer!
    var totalTime = 0
    var questionTime = 0
    var grade = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        answerArea.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        middleArea.addGestureRecognizer(tapGesture)
        
        gameTitle.text = passedTitle
        updateUI()
        startTimer()
        startTimeConstraint()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        
        answerArea.text = ""
        var setToShow = Array(questionAll.answer[currentQuestion])
//        setToShow.sort(){_, _ in arc4random() % 2 == 0}

        //to check the shuffled is same as before
        while String(setToShow) == questionAll.answer[currentQuestion]{
            setToShow.sort(){_, _ in arc4random() % 2 == 0}
        }
        
        var stringToShow = ""
        for letter in setToShow{
            stringToShow += "\(letter) 🍊 "
        }
        wordsSet.text = stringToShow
        hintContent.text = questionAll.hint[currentQuestion]
        
    }
    
    //TODO: Declare ViewTapped here:
    @objc func viewTapped(){
        answerArea.endEditing(true)
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        //user click confirm to check if it is the end of game
        //end of game then alert
        if currentQuestion >= questionAll.answer.count-1 {
            answerArea.endEditing(true)
            calculate()
            endTimer()
            let currentTime = timerForGame.text!
            let message = "You finished all questions with points \(grade) in \(currentTime). Do you want to play again?"
            let alert = UIAlertController(title: "Congrats", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in self.startOver()})
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in self.cancel()})
            alert.addAction(cancelAction)
            alert.addAction(restartAction)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }else{
            // not end of game then check textfield is same as answer then update question hint clear textfield change current number
            answerArea.endEditing(true)
            calculate()
            currentQuestion += 1
            questionTime = 0
            updateUI()
            endTimeConstraint()
            startTimeConstraint()
            
        }
        
        
    }
    
    @IBAction func startTyping(_ sender: UITextField) {
        //lift the hight constraint
    }
    
    //one timer to check the time of whole game
    //timer
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerForGame.text = "\(timeFormatted(totalTime))"
        timeLeftLabel.text = "\(timeFormatted(questionTime))"
        questionTime += 1
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
    
    //one timer to check every 60 seconds to force current number change and update UI
    func startTimeConstraint(){
        timeConstraint = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(nextQuestion), userInfo: nil, repeats: true)
    }
    
    @objc func nextQuestion(){
        //force to next question
        questionTime = 0
        calculate()
        currentQuestion += 1
        updateUI()
    }
    
    func endTimeConstraint(){
        timeConstraint.invalidate()
    }
    
    //to start over or cancel
    func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func startOver(){
        currentQuestion = 0
        grade = 0
        questionTime = 0
        updateUI()
        totalTime = 0
        startTimer()
    }
    
    //to calculate right or wrong
    func calculate(){
        if answerArea.text?.uppercased() == questionAll.answer[currentQuestion]{
            grade += 1
        }
    }

    //textField delegate method
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 288
            self.view.layoutIfNeeded()
        }
    }

    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    
}
