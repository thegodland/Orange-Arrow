//
//  File.swift
//  Orange Arrow
//
//  Created by 刘祥 on 8/25/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import Foundation
import Firebase

class Methods {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var gameTime : String = ""
    var level : Int = 0
    var accuracy : Float = 0
    var gameType : String = ""
    
    func storeResult(targetNV:UINavigationController){
        let messageDB = ref.child(gameType)
//        guard let userID = Auth.auth().currentUser?.uid else { fatalError("No User Sign In") }
        guard let userID = Auth.auth().currentUser?.uid else { fatalError("No User Sign In") }
        
        //to format date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM, dd, yyyy HH:mm:ss a"
        let date = formatter.string(from: Date())
        
        let resultDictionary = ["level":level,"time":gameTime,"accuracy":accuracy/100] as [String : Any]
        messageDB.child("\(userID)/\(date)").setValue(resultDictionary)
        
        //go back to main page
        targetNV.popViewController(animated: true)
    }
    
    func checkGradeAndPopAlert(gameToUnlock:Int,targetVC:UIViewController,targetNVMother:UINavigationController,startOver: @escaping ()->()){
        
        //to check if the grades is over 90%, if it is over then unlock the next level
        if accuracy >= 9000 {
            //unlock next level on firebase
            guard let userID = Auth.auth().currentUser?.uid else { fatalError("No User Sign In") }
            
            ref.child("UsersInfo/\(userID)/Levels/\(gameToUnlock)").setValue(level+1)
            //send the alert to ask for store the result
            //alert
            let message = "You finished level\(level)'s all questions with accuracy \(accuracy.rounded()/100)% in \(gameTime). Do you want to keep your results?"
            let alert = UIAlertController(title: "Congrats", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in self.storeResult(targetNV:targetNVMother)})
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in self.cancel(targetNV: targetNVMother)})
            alert.addAction(cancelAction)
            alert.addAction(restartAction)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                targetVC.present(alert, animated: true, completion: nil)
            }
        }else{
            //alert
            
            let message = "You finished level\(level)'s all questions with accuracy \(accuracy.rounded()/100)% in \(gameTime), which is not enough to unlock level\(level+1). Do you want to play again?"
            let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in startOver()})
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in self.cancel(targetNV: targetNVMother)})
            alert.addAction(cancelAction)
            alert.addAction(restartAction)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                targetVC.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    
    func cancel(targetNV:UINavigationController){
        targetNV.popViewController(animated: true)
    }

    
}

