//
//  words.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class WordsVC : UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var middleArea: UIView!
  
    @IBOutlet weak var toTypeArea: UIView!
    @IBOutlet weak var hintContent: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var timerForGame: UILabel!
    @IBOutlet weak var answerArea: UITextField!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var gradeTracker: UILabel!
    
    @IBOutlet var wordImage: [UIImageView]!
    
    @IBOutlet var wordLabel: [UILabel]!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    let wordFrameName = ["football.png","tennis.png","basketball.png","volleyball.png","soccer.png"]
    let questionAll = Words()
    var currentQuestion : Int = 0
    var passedTitle : String = ""
    var countdownTimer: Timer!
    var timeConstraint : Timer!
    var totalTime = 0
    var questionTime = 0
    var grade = 0
    var level = 0
    let methods = Methods()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        answerArea.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        middleArea.addGestureRecognizer(tapGesture)
        
//        gameTitle.text = passedTitle
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
        var setToShow = Array(questionAll.answer[level-1][currentQuestion])
//        setToShow.sort(){_, _ in arc4random() % 2 == 0}

        //to check the shuffled is same as before
        while String(setToShow) == questionAll.answer[level-1][currentQuestion]{
            setToShow.sort(){_, _ in arc4random() % 2 == 0}
        }
        
//        var stringToShow = ""
//        for letter in setToShow{
//            stringToShow += "\(letter) 🍊 "
//        }
        
        //to update on the interface
        for (index,letter) in setToShow.enumerated() {
            wordLabel[index].text = String(letter)
            wordImage[index].image = UIImage(named: wordFrameName[index%5])

        }
        for index in setToShow.count...wordLabel.count-1 {
            wordLabel[index].text = nil
            wordImage[index].image = UIImage(named: "")
        }
            
//        wordsSet.text = stringToShow
        hintContent.text = questionAll.hint[level-1][currentQuestion]
        
        //update progress bar
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(questionAll.answer[level-1].count)) * CGFloat(currentQuestion + 1)
        
        // upodate progress label
        progressLabel.text = "\(currentQuestion + 1) / \(questionAll.answer[level-1].count)"
        
        // update grade label
        gradeTracker.text = "current points is \(grade)/\(questionAll.answer[level-1].count)"
        
        
        
    }
    
    //TODO: Declare ViewTapped here:
    @objc func viewTapped(){
        answerArea.endEditing(true)
    }
    
    @IBAction func confirmClick(_ sender: UIButton) {
        //user click confirm to check if it is the end of game
        //end of game then alert        

        if currentQuestion >= questionAll.answer[level-1].count - 1{
            answerArea.endEditing(true)
            calculate()
            endTimer()

            
            methods.accuracy = Float(grade)/Float(questionAll.answer[level-1].count)*100*100
            methods.gameTime = timerForGame.text!
            methods.gameType = passedTitle
            methods.level = level
            
            
            methods.checkGradeAndPopAlert(gameToUnlock:2,targetVC:self,targetNVMother:navigationController!){
                self.startOver()
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
        // before goto next question by force timing, check if the current question is last one
        if currentQuestion >= questionAll.answer[level-1].count - 1 {
            answerArea.endEditing(true)
            calculate()
            endTimer()
            
            
            methods.accuracy = Float(grade)/Float(questionAll.answer[level-1].count)*100*100
            methods.gameTime = timerForGame.text!
            methods.gameType = passedTitle
            methods.level = level
            
            
            methods.checkGradeAndPopAlert(gameToUnlock:2,targetVC:self,targetNVMother:navigationController!){
                self.startOver()
            }
        }else{
            //force to next question
            questionTime = 0
            calculate()
            currentQuestion += 1
            updateUI()
        }
        

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
        if answerArea.text?.uppercased() == questionAll.answer[level-1][currentQuestion]{
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
