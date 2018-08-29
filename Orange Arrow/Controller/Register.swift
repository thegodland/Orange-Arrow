//
//  Register.swift
//  Orange Arrow
//
//  Created by 刘祥 on 8/7/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ValidationComponents



class Register: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var sports: UITextField!
    @IBOutlet weak var schoolName: UITextField!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var imageUploadBtn: UIButton!
    @IBOutlet weak var invalidMessage: UILabel!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var ageInput: UITextField!
    
    let imagePicker = UIImagePickerController()
    var gender : String = ""
    
    var schoolPickerView : UIPickerView!
    var agePickerView : UIPickerView!
    // todo - to set the real school name and age range
    let schoolData = ["Target School","Arsenal 6-8" , "Arsenal K5" , "FAU" , "Liberty","Miami","Pitt","Robert Morris","Sci-Tech","South Brook"]
    let ageData = ["Age","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolName.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    //MARK - Sign up button clicked function
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        
        
        // other non empty value
        guard let firstNameInfo = firstName.text, !firstNameInfo.isEmpty else{
            self.invalidMessage.text = "Please enter your first name"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        guard let lastNameInfo = lastName.text, !lastNameInfo.isEmpty else{
            self.invalidMessage.text = "Please enter your last name"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        guard let passwordInfo = password.text, !passwordInfo.isEmpty else{
            self.invalidMessage.text = "Please enter your password"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        //MARK - to validate correct email format
        let emailPredicate = EmailValidationPredicate()
        guard let emailInfo = email.text, !emailInfo.isEmpty && emailPredicate.evaluate(with: emailInfo) else{
            self.invalidMessage.text = "Please enter correct email"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        guard let sportsInfo = sports.text, !sportsInfo.isEmpty else{
            self.invalidMessage.text = "Please enter your professional sports"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        guard let schoolInfo = schoolName.text, !schoolInfo.isEmpty && schoolInfo != "Target School" else{
            self.invalidMessage.text = "Please select your current school"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        guard let ageInfo = ageInput.text, !ageInfo.isEmpty && ageInfo != "Age" else{
            self.invalidMessage.text = "Please select your current age"
            self.invalidMessage.backgroundColor = UIColor.white
            return
        }
        
        SVProgressHUD.show()
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailInfo, password: passwordInfo) { (user, error) in
            if error != nil {
                print("The user can't store at firebase with error: \(error!)")
                self.invalidMessage.text = "There is error to sign up! Error is \(error!)"
                self.invalidMessage.backgroundColor = UIColor.white
                SVProgressHUD.dismiss()
            }else{
                //TODO: Save rest user information to Firebase
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                self.btnControl(inUse: false)
                // TODO: store profile img to storage
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("\(imageName).png")
                if self.profileImage.image == nil {
                    self.profileImage.image = UIImage(named: "default_profile")
                }
                if let uploadData = UIImagePNGRepresentation(self.profileImage.image!){
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print("Upload Image Error with reason \(error!)")
                            return
                        }
                        
                        storageRef.downloadURL(completion: { (url,error) in
                            guard let downloadURL = url?.absoluteString else{
                                print("there is a download url error \(error!)")
                                return
                            }
                            
                            let userDictionary = ["First Name":firstNameInfo,"Last Name":lastNameInfo,"Email":emailInfo,"Age":ageInfo,"Gender":self.gender,"Sports":sportsInfo,"School":schoolInfo,"ProfileImageUrl":downloadURL,"Levels":[1,1,1,1]] as [String : Any]
                            
                            self.registerUserInfoWithUID(uid:uid, values:userDictionary as [String : AnyObject])
                            
                        })
                    })
                }

                print("successfully create a user!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "registerToMainPage", sender: self)
            }
        }
    }
    
    //MARK - FUNCTION TO ENABLE OR DISABLE BUTTON AND TEXTFIELD
    func btnControl(inUse : Bool){
            firstName.isEnabled = inUse
            lastName.isEnabled = inUse
            password.isEnabled = inUse
            email.isEnabled = inUse
            sports.isEnabled = inUse
            schoolName.isEnabled = inUse
            joinButton.isEnabled = inUse
            imageUploadBtn.isEnabled = inUse
        genderControl.isEnabled = inUse
        ageInput.isEnabled = inUse
    }
    
    // MARK -
    private func registerUserInfoWithUID(uid: String, values: [String: AnyObject]){
        
        let userDB = Database.database().reference().child("UsersInfo").child(uid)
        userDB.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("user information can't be stored at firebase with error: \(error!)")
                return
            }
            print("additional user info was saved in firebase")
            self.btnControl(inUse: true)
        }
    }
    
    
    // MARK - FUNCTION TO CREATE UIPickerView with ToolBar
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        if textField.tag == 4{
            self.agePickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.agePickerView.delegate = self
            self.agePickerView.dataSource = self
            self.agePickerView.backgroundColor = UIColor.white
            textField.inputView = self.agePickerView
            
        }else if textField.tag == 6{
            self.schoolPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
            self.schoolPickerView.delegate = self
            self.schoolPickerView.dataSource = self
            self.schoolPickerView.backgroundColor = UIColor.white
            textField.inputView = self.schoolPickerView
        }

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Register.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Register.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK - DATA SOURCE METHOD OF PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == schoolPickerView{
            return schoolData.count
        }else if pickerView == agePickerView{
            return ageData.count
        }else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == schoolPickerView{
            return schoolData[row]
        }else if pickerView == agePickerView{
            return ageData[row]
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView == schoolPickerView{
            schoolName.text = schoolData[row]
        }else if pickerView == agePickerView{
            ageInput.text = ageData[row]
        }
    }
    
    // MARK - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4{
            self.pickUp(ageInput)
        }else if textField.tag == 6{
            self.pickUp(schoolName)
        }

    }
    
    // - MARK - FUNCTIONS FOR TOOLBAR BUTTON
    @objc func doneClick(textField: UITextField) {
        
        self.view.endEditing(true)
    }
    @objc func cancelClick(textField: UITextField) {
//        if textField.tag == 6{
//            schoolName.resignFirstResponder()
//        }else if textField.tag == 4{
//            ageInput.resignFirstResponder()
//        }
        self.view.endEditing(true)
    }
    
    // MARK - ADD PROFILE IMAGE FUNCTION
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK - DELEGATE FOR IMAGE PICKER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            profileImage.image = pickImage
            // TO UPLOAD THIS IMAGE TO FIREBASE STORAGE WITH EMAIL

        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK - function for gender button touched
    @IBAction func genderChanged(_ sender: UISegmentedControl) {
        switch genderControl.selectedSegmentIndex
        {
        case 0:
            gender = "M";
        case 1:
            gender = "F";
        case 2:
            gender = "O";
        default:
            break
        }
    }
    
    // MARK - to make return key as done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag
        {
        case 0:
            firstName.resignFirstResponder();
        case 1:
            lastName.resignFirstResponder();
        case 2:
            password.resignFirstResponder();
        case 3:
            email.resignFirstResponder();
        case 4:
            ageInput.resignFirstResponder();
        case 5:
            sports.resignFirstResponder();
        case 6:
            schoolName.resignFirstResponder();
        default:
            break
        }
        return true
    }
    
    


}
