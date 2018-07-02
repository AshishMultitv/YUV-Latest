//
//  RedeemReferralViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 07/06/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class RedeemReferralViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Referral_tx: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Referral_tx.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Taptoskip(_ sender: UIButton) {
        self.gotohomeacreen()
    }
    @IBAction func TaptoSubmite(_ sender: UIButton) {
        
        if(!Common.isEmptyOrWhitespace(testStr: Referral_tx.text!))
        {
            EZAlertController.alert(title: "Please Enter Referral Code")
            self.view.endEditing(true)
            return
        }
        redeemcode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func redeemcode()
    {
        print(Referral_tx.text!)
        Common.startloder(view: self.view)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict.value(forKey: "id") as! NSNumber)
        let parameters = [
            "refferal_code": Referral_tx.text!,
            "c_id": (dict.value(forKey: "id") as! NSNumber).stringValue
        ]
        print(parameters)
        var url = String(format: "%@/subscriptionapi/v6/subscription/redeem_refferal/token/%@/device/ios", SubscriptionBaseUrl,Apptoken)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url.url)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                {
                    EZAlertController.alert(title: dict.value(forKey: "error") as! String)
                    self.view.endEditing(true)
                    return
                }
                else
                {
                    self.gotohomeacreen()
                    EZAlertController.alert(title: "Successfully Redeemed Referal Code")
                    self.getUsersubscriptiondetail()
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
    }
    
    func gotohomeacreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        // self.slideMenuController()?.changeMainViewController(viewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    func getUsersubscriptiondetail() {
        if(Common.Islogin()) {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            print(dict.value(forKey: "id") as! NSNumber)
            var url = String(format: "%@/subscriptionapi/v6/spackage/user_packages/token/%@/device/ios/uid/%@",SubscriptionBaseUrl,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                        
                        
                    }
                    else
                    {
                        
                        
                        if let _  = dict.value(forKey: "result")
                        {
                            LoginCredentials.Allusersubscriptiondetail = dict.value(forKey: "result") as! NSDictionary
                            
                        }
                        
                        if let _  = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list")
                        {
                            if(Common.isNotNull(object: (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as AnyObject))
                            {
                                if(((dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray).count>0) {
                                    LoginCredentials.UserSubscriptiondetail = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray
                                    if(!Common.Isuserissubscribe(Userdetails: self))
                                    {
                                        LoginCredentials.Regiontype = ""
                                    }
                                    
                                    
                                }
                                else
                                {
                                    LoginCredentials.UserSubscriptiondetail = NSArray()
                                    LoginCredentials.Regiontype = ""
                                }
                            }
                        }
                        
                    }
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
