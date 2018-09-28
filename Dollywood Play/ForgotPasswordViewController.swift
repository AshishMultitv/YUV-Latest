//
//  ForgotPasswordViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 17/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FormToolbar
import AFNetworking
import MatomoTracker



class ForgotPasswordViewController: UIViewController {
    @IBOutlet var Email_tx: UITextField!
    var toolbar = FormToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [Email_tx])
    }
    
    @IBAction func TAptosubmit(_ sender: UIButton) {
        
        if(!Common.isValidEmail(testStr: Email_tx.text!))
        {
            EZAlertController.alert(title: "Please enter Valid email")
        }
        else
        {
             MatomoTracker.shared.track(eventWithCategory: "User", action: "click", name: "forget_password", value: 1)
            forgotpassword()
        }
    }
    
    
    func forgotpassword()
    {
        Common.startloder(view: self.view)
        var parameters = [String : String]()
        parameters = [
            "email": Email_tx.text!,
            "device": "ios"
        ]
        let url = String(format: "%@%@", LoginCredentials.Forgotapi,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "This email id is not register, please enter register email id.")
                }
                else
                {
                    self.navigationController?.popViewController(animated: true)
                    EZAlertController.alert(title: "\(dict.value(forKey: "result") as! String)")
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptoback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.toolbar.update()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y = -50
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
