//
//  puzzle.swift
//  Orange Arrow
//
//  Created by 刘祥 on 7/2/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit

class PuzzleVC: UIViewController {

    
    @IBOutlet weak var timeTracker: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var hintText: UILabel!
    let questionAll = Puzzle()
    var passedTitle : String = ""
    var countdownTimer: Timer!
    var totalTime = 0
    var currentQuestion : Int = 0
    var isPressed : [Bool] = [false,false,false,false]
    @IBOutlet var buttons: [UIButton] = []
    
    @IBOutlet var pictureBtn: [UIButton]!
    var grade : Int = 0
    
    var pictureTimer : Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameTitle.text = passedTitle
        updateUI()
        startTimer()
        startPicture()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseAthletes(_ sender: UIButton) {
        if currentQuestion >= questionAll.imageName.count - 1{
            //calculate the points and right or wrong
            if sender.tag == questionAll.answer[currentQuestion]{
                //the answer is right
                grade += 1
            }
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
            //not reach the end
            //calculate the points and right or wrong
            if sender.tag == questionAll.answer[currentQuestion]{
                //the answer is right
                grade += 1

            }
            currentQuestion += 1
            updateUI()
            //start picture timer again
            //first invalid timer then make all btn enable for new guess and start 10 s timer again
            pictureTimer.invalidate()
            enableRevealPicture()
            startPicture()
            
        }
    }
    
    
    @IBAction func revealPicture(_ sender: UIButton) {
        sender.setImage(nil, for: [])
        for btn in pictureBtn{
            btn.isUserInteractionEnabled = false
        }
        
    }
    
    func startPicture() {
        pictureTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(enableRevealPicture), userInfo: nil, repeats: true)
    }


    @objc func enableRevealPicture(){
        //every 10 seconds, user can choose reveal picture which means button can use
        for btn in pictureBtn{
            btn.isUserInteractionEnabled = true
        }
        
    }
    

    
    func updateUI(){
        let imgName = questionAll.imageName[currentQuestion]
        imageBackground.image = UIImage(named: imgName)
        hintText.text = questionAll.hint[currentQuestion]
        //update choices label
        for (index,singleButton) in buttons.enumerated(){
            let buttonTitle = questionAll.choice[currentQuestion][index]
            singleButton.setTitle("\(buttonTitle)",for: .normal)
        }
        //update all the btn picture to default
        for singleBtn in pictureBtn{
            singleBtn.setImage(UIImage(named: "oa-logo copy 2"), for: [])
        }
        

    }
    
    func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func startOver(){
        currentQuestion = 0
        grade = 0
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
