//
//  puzzle.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
import ProgressHUD
//import Firebase

class PuzzleVC: UIViewController {

    
    @IBOutlet weak var timeTracker: UILabel!
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var hintText: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentGrade: UILabel!
    @IBOutlet weak var progressBar: UIView!
    
    let questionAll = Puzzle()
    let methods = Methods()
    var passedTitle : String = ""
    var countdownTimer: Timer!
    var totalTime = 0
    var currentQuestion : Int = 0
    var isPressed : [Bool] = [false,false,false,false]
    @IBOutlet var buttons: [UIButton] = []
    @IBOutlet var pictureBtn: [UIButton]!
    var grade : Int = 0
    var pictureTimer : Timer!
    var level: Int = 0
    var checkDuplicateArray : [Int] = []
    var totalGrade : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        totalGrade = questionAll.imageName[level-1].count
        print(level)
        updateUI()
        startTimer()
        startPicture()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseAthletes(_ sender: UIButton) {
        if currentQuestion >= questionAll.imageName[level-1].count - 1{
            //calculate the points and right or wrong
            if sender.tag == questionAll.answer[level-1][currentQuestion]{
                //the answer is right
                grade += 1
                ProgressHUD.showSuccess("Correct")
            }else{
                ProgressHUD.showError("Wrong")
            }
            endTimer()
            
            methods.accuracy = Float(grade)/Float(totalGrade)*100*100
            methods.gameTime = timeTracker.text!
            methods.gameType = passedTitle
            methods.level = level

            
            methods.checkGradeAndPopAlert(gameToUnlock:1,targetVC:self,targetNVMother:navigationController!){
                self.startOver()
            }
            
//            let currentTime = timeTracker.text!
//            let message = "You finished all questions with points \(grade) in \(currentTime). Do you want to play again?"
//            let alert = UIAlertController(title: "Congrats", message: message, preferredStyle: .alert)
//            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in self.startOver()})
//            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in self.cancel()})
//            alert.addAction(cancelAction)
//            alert.addAction(restartAction)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//
//                self.present(alert, animated: true, completion: nil)
//
//            }
            
        }else{

            //not reach the end
            //calculate the points and right or wrong
            if sender.tag == questionAll.answer[level-1][currentQuestion]{
                //the answer is right
                grade += 1
                ProgressHUD.showSuccess("Correct")

            }else{
                ProgressHUD.showError("Wrong")
            }
            currentQuestion += 1
            print(currentQuestion)
            checkDuplicateArray = []
            updateUI()
    
            //start picture timer again
            //first invalid timer then make all btn enable for new guess and start 10 s timer again
            pictureTimer.invalidate()
            enableRevealPicture()
            startPicture()
            
        }
    }
    
    
    
    @IBAction func revealPicture(_ sender: UIButton) {
        sender.setBackgroundImage(nil, for: [])
        for btn in pictureBtn{
            btn.isUserInteractionEnabled = false
        }
        
    }
    
    // set timer so every 10 seconds can reveal a picture
    func startPicture() {
        print("8888888")
        pictureTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(enableRevealPicture), userInfo: nil, repeats: true)
    }


    @objc func enableRevealPicture(){
        //every 10 seconds, user can choose reveal picture which means button can use
        for btn in pictureBtn{
            btn.isUserInteractionEnabled = true
        }
    }
    

    func updateUI(){
     
        let imgName = questionAll.imageName[level-1][currentQuestion]
        imageBackground.image = UIImage(named: imgName)

        hintText.text = questionAll.hint[level-1][currentQuestion]
        print(hintText)
       
        //update choices label
        for (index,singleButton) in buttons.enumerated(){
            let buttonTitle = questionAll.choice[level-1][currentQuestion][index]
            singleButton.setTitle("\(buttonTitle)",for: .normal)
        }
  
        //update all the btn picture to random kids
        for singleBtn in pictureBtn{
            var randomNumber = Int(arc4random_uniform(18))+1
            
            while checkDuplicateArray.contains(randomNumber){
                randomNumber = Int(arc4random_uniform(18))+1
            }
            
            checkDuplicateArray.append(randomNumber)

            let randomName = "ppl\(randomNumber).jpg"
//            singleBtn.setImage(UIImage(named: "oa-logo copy 2"), for: [])
            singleBtn.setBackgroundImage(UIImage(named: randomName), for:[])
        }
       
        //update progress bar
        progressBar.frame.size.width = (view.frame.size.width / CGFloat(questionAll.imageName[level-1].count)) * CGFloat(currentQuestion+1)

        // upodate progress label
        progressLabel.text = "\(currentQuestion + 1) / \(questionAll.imageName[level-1].count)"

        // update grade label
        currentGrade.text = "current points is \(grade)/\(questionAll.imageName[level-1].count)"


    }
    
    func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    func startOver(){
        currentQuestion = 0
        grade = 0
        checkDuplicateArray = []
        updateUI()
        totalTime = 0
        startTimer()
        enableRevealPicture()
        startPicture()
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
    
//    func endPictureTimer(timerToBeInvalided : Timer){
//        timerToBeInvalided.invalidate()
//    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
