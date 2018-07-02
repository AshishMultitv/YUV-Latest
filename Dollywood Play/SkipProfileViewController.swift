//
//  SkipProfileViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 13/11/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FTPopOverMenu
import AFNetworking

class SkipProfileViewController: UIViewController {
    
    @IBOutlet var gendarlabel: UILabel!
    @IBOutlet var agelabel: UILabel!
    var Isnewuser = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.getRoundLabel(label: gendarlabel, borderwidth: 1.0)
        Common.getRoundLabel(label: agelabel, borderwidth: 1.0)
        Common.setlebelborderwidth(label: gendarlabel, borderwidth: 1.0)
        Common.setlebelborderwidth(label: agelabel, borderwidth: 1.0)
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict)
        if(Common.isNotNull(object: dict.value(forKey: "age_group") as AnyObject?))
        {
            agelabel.text = "\("  ")\(dict.value(forKey: "age_group") as! String)"
        }
        
        
        if(Common.isNotNull(object: dict.value(forKey: "gender") as AnyObject?) )
        {
            if((dict.value(forKey: "gender") as! String) == "")
            {
                
            }
            else
            {
                gendarlabel.text = "\("  ")\(dict.value(forKey: "gender") as! String)"
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Taptoback(_ sender: UIButton)
    {
        dataBase.deletedataentity(entityname: "Logindata")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
        let true2 =  (self.navigationController?.popViewController(animated: true))!
        
    }
    
    @IBAction func TaptoSkip(_ sender: UIButton) {
        
        if(self.Isnewuser == "1")
        {
            self.gotorefreelscreen()
        }
        else
        {
            self.gotohomeacreen()
        }
        
    }
    
    @IBAction func Taptosubmit(_ sender: UIButton) {
        self.updateprofiledata()
        
    }
    
    
    func gotohomeacreen()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    @IBAction func Taptogender(_ sender: UIButton) {
        
        let gederarray = ["Male", "Female"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: ["Male", "Female"], doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.gendarlabel.text = "\("  ")\(gederarray[selectedIndex])"
        }) {
            
        }
        
    }
    @IBAction func Taptoage(_ sender: UIButton) {
        
        let agearry = ["Below 18", "18-24", "25-34","35-44","Above 45"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: agearry, doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.agelabel.text = "\("  ")\(agearry[selectedIndex])"
            
            
        }) {
            
        }
        
    }
    
    
    func updateprofiledata()
    {
        
        
        if((gendarlabel.text == "Gender") || (agelabel.text == "Age"))
        {
            
            EZAlertController.alert(title: "Please Change for Update Profile")
            return
        }
        
        
        var age = agelabel.text
        age = age?.trimmingCharacters(in: .whitespacesAndNewlines)
        if(age == "Below 18")
        {
            age = "0-17"
        }
        else if(age == "Above 45")
        {
            age = "45-70"
        }
        
        if(age == "Age")
        {
            age = ""
        }
        
        var gendar = gendarlabel.text
        gendar = gendar?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(gendar == "Gender")
        {
            gendar = ""
        }
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict)
        Common.startloder(view: self.view)
        
        
        
        var parameters = [String : String]()
        
        parameters = [
            "device": "ios",
            "id": (dict.value(forKey: "id") as! NSNumber).stringValue,
            "gender": gendar!,
            "age_group": age!,
        ]
        print(parameters)
        let url = String(format: "%@%@", LoginCredentials.Editapi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "\(dict.value(forKey: "error") as! String)")
                    return
                }
                var data = NSMutableDictionary()
                if(LoginCredentials.IsencriptEditapi)
                {
                    data = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    data = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                print(data)
                dataBase.deletedataentity(entityname: "Logindata")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: data)
                
                if(self.Isnewuser == "1")
                {
                    self.gotorefreelscreen()
                }
                else
                {
                    self.gotohomeacreen()
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    func gotorefreelscreen()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RedeemReferralViewController") as! RedeemReferralViewController
        //self.slideMenuController()?.changeMainViewController(SignoutViewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
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
