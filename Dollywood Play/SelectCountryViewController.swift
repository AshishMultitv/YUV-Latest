//
//  SelectCountryViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 29/05/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class SelectCountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var internationalbutton: UIButton!
    @IBOutlet weak var indiabutton: UIButton!
    @IBOutlet weak var mytableview: UITableView!
    
    var contrylist = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJsonfile()
        indiabutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
        internationalbutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
        mytableview.isHidden = false
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func parseJsonfile()
    {
        if let path = Bundle.main.path(forResource: "state", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let state = jsonResult["state"] as? [Any] {
                    contrylist = state as NSArray
                    print(contrylist)
                    mytableview.reloadData()
                    
                    // do stuff
                }
            } catch {
                // handle error
            }
        }
    }
    
    @IBAction func Taptointernational(_ sender: UIButton) {
        internationalbutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
        indiabutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
        mytableview.isHidden = true
        LoginCredentials.Regiontype = "2"
        LoginCredentials.CreateorderRegiontype = ""
        chekcUsersubscription()
        Common.startloderonsubscription(view: self.view)
        
        
        
    }
    @IBAction func Taptocancel(_ sender: Any) {
        
        backaction()
        
    }
    
    
    func backaction() {
        
        
        self.dismiss(animated: true, completion: nil)
        //  backaction()
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismisssubscription"), object: nil)
        
        //        self.dismiss(animated: true) {
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let subscriptionView = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
        //            subscriptionView.dismiss(animated: true, completion: nil)
        //        }
        
    }
    
    
    @IBAction func TaptoIndia(_ sender: UIButton) {
        indiabutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
        internationalbutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
        mytableview.isHidden = false
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contrylist.count
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = self.mytableview.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = (contrylist.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        let name = (contrylist.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        
        if(name == "Tamil Nadu") {
            LoginCredentials.Regiontype = "1"
            LoginCredentials.CreateorderRegiontype = "1"
            print((contrylist.object(at: indexPath.row) as! NSDictionary))
            LoginCredentials.SelectedUserCountry = (contrylist.object(at: indexPath.row) as! NSDictionary)
            print(LoginCredentials.SelectedUserCountry)
            Common.startloderonsubscription(view: self.view)
            chekcUsersubscription()
        }
        else {
            LoginCredentials.Regiontype = "1"
            LoginCredentials.CreateorderRegiontype = "2"
            LoginCredentials.SelectedUserCountry = (contrylist.object(at: indexPath.row) as! NSDictionary)
            print(LoginCredentials.SelectedUserCountry)
            Common.startloderonsubscription(view: self.view)
            chekcUsersubscription()
        }
        
        
        
    }
    
    
    //region_type
    func chekcUsersubscription()
    {
        if(Common.Islogin()) {
            
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            print(dict.value(forKey: "id") as! NSNumber)
            var url = String(format: "%@/subscriptionapi/v6/spackage/subscription/token/%@/device/ios/uid/%@/region_type/%@",SubscriptionBaseUrl,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,LoginCredentials.Regiontype)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    let number = dict.value(forKey: "code") as! NSNumber
                    Common.stoploderonsubscription(view: self.view)
                    if(number == 0)
                    {
                        Common.stoploderonsubscription(view: self.view)
                        self.backaction()
                    }
                    else
                    {
                        if let _ = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list")
                        {
                            let pakkagearray = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list") as! NSArray
                            if(pakkagearray.count>0)
                            {
                                LoginCredentials.UserPakegeList = pakkagearray
                                print(LoginCredentials.UserPakegeList)
                            }
                            else
                            {
                                
                                LoginCredentials.UserPakegeList = NSArray()
                            }
                            
                            self.backaction()
                            
                        }
                    }
                    
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                LoginCredentials.UserPakegeList = NSArray()
                Common.stoploderonsubscription(view: self.view)
                self.backaction()
                
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
