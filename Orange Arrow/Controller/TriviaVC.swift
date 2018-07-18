//
//  trivia.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class TriviaVC: UIViewController {
    
    @IBOutlet weak var titleOfGame: UILabel!
    @IBOutlet weak var questionsOfGame: UILabel!
    var passedTitle : String = ""
    var isPressed : [Bool] = [false,false,false,false]
    var currentNumberOfQuestion : Int = 0
    
    @IBOutlet weak var timeTracker: UILabel!
    @IBOutlet weak var gradeTracker: UILabel!
    @IBOutlet var buttons: [UIButton] = []
    var questionAll = Trivia()
    var grade : Int = 0
    var totalGrade : Int = 0
    
    var countdownTimer: Timer!
    var totalTime = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleOfGame.text = passedTitle
        //calculate the total grades
        for singlePoint in questionAll.answers{
            let sumGrade = singlePoint.reduce(0, {$0 + $1})
            totalGrade += sumGrade
        }
        gradeTracker.text = "0/\(totalGrade)"
        
        updateUI()
        startTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // green means didnt choose, gray means has chosen
    @IBAction func chooseAnswer(_ sender: UIButton) {
        let numberOfButton = sender.tag
        if isPressed[numberOfButton] == true{
            sender.backgroundColor = UIColor.green
            isPressed[numberOfButton] = false
        }else if isPressed[numberOfButton] == false{
            sender.backgroundColor = UIColor.gray
            isPressed[numberOfButton] = true
        }
    }
    
    @IBAction func confirmAnswer(_ sender: UIButton) {
        //to check if this is the last question,if it is last question then pop out result and play again or go back (dismiss)
        if currentNumberOfQuestion >= questionAll.questions.count - 1 {
            calculatePoint()
            endTimer()
            let currentTime = timeTracker.text!
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
            //if it is not last then update question, choices and add points
            calculatePoint()
            currentNumberOfQuestion += 1
            updateUI()
        }

        
        
    }
    
    func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func startOver(){
        currentNumberOfQuestion = 0
        grade = 0
        updateUI()
        totalTime = 0
        startTimer()
    }
    
    func updateUI(){
        //update the grade tracker
        gradeTracker.text = "\(grade)/\(totalGrade)"
        //update question label
        questionsOfGame.text = questionAll.questions[currentNumberOfQuestion]
        //update choices label
        for (index,singleButton) in buttons.enumerated(){
            let buttonTitle = questionAll.choices[currentNumberOfQuestion][index]
            singleButton.setTitle("\(buttonTitle)",for: .normal)
        }
        //update button color
        for (index,singleButton) in buttons.enumerated(){
            singleButton.backgroundColor = UIColor.green
            isPressed[index] = false
        }
        
    }
    
    func calculatePoint(){
        for (index,singleButton) in buttons.enumerated(){
            if singleButton.backgroundColor == UIColor.gray{
                //the button has been chosed
                if questionAll.answers[currentNumberOfQuestion][index] == 1{
                    grade += 1
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
