//
//  RegisterAndLoginViewController.swift
//  Orange Arrow
//
//  Created by 刘祥 on 8/7/18.
//  Copyright © 2018 Orange Arrow. All rights reserved.
//

import UIKit
//import SwiftGifOrigin


// MARK - FOR THE CUSTOM BUTTON
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class RegisterAndLoginViewController: UIViewController {

    @IBOutlet weak var registerImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let imageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
//        print(imageView)
//        registerImg.animate(withGIFNamed: "first_page"){
//            print("this is working!!!")
//        }
//        print("second time \(imageView)")
//        view.addSubview(imageView)
//        registerImg.image = UIImage.gif(name: "second_try")
        registerImg.image = UIImage(named: "first page back.jpg")
    }


    

}
