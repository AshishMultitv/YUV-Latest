
//
//  SubscriptionView.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 05/03/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking

class SubscriptionView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    ////////// Object Declaration/////////////////
    var freesubscriptionid = NSString()
    var Subscriptionpakagename = String()
    var Subscriptioniapname = String()
    var Subscriptiontype = String()
    var Subscriptionpakageid = String()
    var Isuserlocalityback:Bool = false
    
    
    ////////// Object Outlate Connection/////////////////
    @IBOutlet var Subscriptiontableview: UITableView!
    @IBOutlet weak var ScroolviewHeightcntrant: NSLayoutConstraint!
    @IBOutlet weak var tabelviewhghtcontrant: NSLayoutConstraint!
    @IBOutlet weak var giftView: UIView!
    
    @IBOutlet weak var Redeemgiftrefreellabel: UILabel!
    
    
    
    // MARK: - view Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginCredentials.Isselectuserback = false
        Common.getRounduiview(view: Subscriptiontableview, radius: 10.0)
        Common.getRounduiview(view: giftView, radius: 10.0)
        // Common.setuiviewdborderwidth(View: Subscriptiontableview, borderwidth: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userFreesubscriptionapi),
                                               name: NSNotification.Name(rawValue: "Userfreesubscription"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismisssubscription), name: NSNotification.Name(rawValue: "dismisssubscription"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        if(Common.Isuserhavefreedayssubscription(Userdetails: self))
        {
            tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count-1) * 113.0
            ScroolviewHeightcntrant.constant = tabelviewhghtcontrant.constant + 50.0
        }
        else
        {
            tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count) * 113.0
            ScroolviewHeightcntrant.constant = tabelviewhghtcontrant.constant + 50.0
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        print(LoginCredentials.UserPakegeList)
        self.Subscriptiontableview.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("Is Press Back \(LoginCredentials.Isselectuserback)")
        if(LoginCredentials.Isselectuserback)
        {
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
        if(!Common.isuserseletedlocality()) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let selectCountryViewController = storyboard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
            self.present(selectCountryViewController, animated: true, completion: nil)
        }
        else
        {
            
            
            if(LoginCredentials.Regiontype == "2")
            {
                Redeemgiftrefreellabel.text = "Redeem a Referral"
            }
            else
            {
                Redeemgiftrefreellabel.text = "Use a Gift / Referral"
            }
            
            
            if(Common.Isuserhavefreedayssubscription(Userdetails: self))
            {
                tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count) * 113.0
                ScroolviewHeightcntrant.constant = tabelviewhghtcontrant.constant + 50.0
            }
            else
            {
                tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count) * 113.0
                ScroolviewHeightcntrant.constant = tabelviewhghtcontrant.constant + 50.0
            }
            self.Subscriptiontableview.reloadData()
        }
        
    }
    
    
    func willResignActive(_ notification: Notification) {
        self.Subscriptiontableview.reloadData()
    }
    
    
    
    func dismisssubscription() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func taptoGift(_ sender: UIButton) {
        
        //        if(Common.Isuserissubscribe(Userdetails: self))
        //        {
        //            EZAlertController.alert(title: "You are already subcribed")
        //            return
        //        }
        
        var title = String()
        
        if(LoginCredentials.Regiontype == "2")
        {
            title = "Redeem Referral"
        }
        else
        {
            title = "Redeem Gift / Referral"
        }
        
        
        let alert = UIAlertController(title: title, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        
        if(LoginCredentials.Regiontype == "2")
        {
            
        }
        else
        {
            
            alert.addAction(UIAlertAction(title: "Redeem Gift", style: .default , handler:{ (UIAlertAction)in
                print("User click Approve button")
                self.showredeemgiftalert()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Redeem Referral", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.showredeemrefreemcodealert()
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
        
        
        
    }
    
    
    
    
    func showredeemgiftalert() {
        
        
        
        //        if(Common.Isuserissubscribenew(Userdetails: self))
        //        {
        //            EZAlertController.alert(title: "You are already subcribed")
        //            return
        //        }
        //
        let alertController = UIAlertController(title: "Redeem Gift", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Gift Code"
        }
        let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
            let couponTextField = alertController.textFields![0] as UITextField
            if(!Common.isEmptyOrWhitespace(testStr: couponTextField.text!))
            {
                
                EZAlertController.alert(title: "Please Enter Gift Code")
            }
            else
            {
                self.redeemcooponcode(code: couponTextField.text as! String)
            }
            
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showredeemrefreemcodealert() {
        
        let alertController = UIAlertController(title: "Redeem Referral", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Referral Code"
        }
        let saveAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
            let couponTextField = alertController.textFields![0] as UITextField
            
            if(!Common.isEmptyOrWhitespace(testStr: couponTextField.text!))
            {
                
                EZAlertController.alert(title: "Please Enter Referral Code")
            }
            else
            {
                self.redeemreferrelcode(referralcode: couponTextField.text!)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func redeemreferrelcode(referralcode:String)
    {
        
        Common.startloderonsubscription(view: self.view)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict.value(forKey: "id") as! NSNumber)
        let parameters = [
            "refferal_code": referralcode,
            "c_id": (dict.value(forKey: "id") as! NSNumber).stringValue
        ]
        print(parameters)
        var url = String(format: "%@%@/device/ios", LoginCredentials.Redeemrefferalapi,Apptoken)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploderonsubscription(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                {
                    EZAlertController.alert(title: dict.value(forKey: "error") as! String)
                    return
                }
                else
                {
                    
                    self.dismissalert(msg: "Successfully Redeemed Referal Code")
                    self.chekcUsersubscription()
                    
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
        }
    }
    
    
    
    
    
    func redeemcooponcode(code:String) {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        var email = String()
        var contactno = String()
        if let _ = dict.value(forKey: "contact_no")
        {
            if(Common.isNotNull(object: dict.value(forKey: "contact_no") as AnyObject)) {
                contactno = dict.value(forKey: "contact_no") as! String
            }
        }
        
        
        if let _ = dict.value(forKey: "email")
        {
            if(Common.isNotNull(object: dict.value(forKey: "email") as AnyObject)) {
                email = dict.value(forKey: "email") as! String
            }
        }
        
        let Param =   ["c_id":dict.value(forKey: "id") as! NSNumber,
                       "coupon_code":code,
                       "c_email":email,
                       "c_phone":contactno
            ] as [String:Any]
        print(dict.value(forKey: "id") as! NSNumber)
        var url = String(format: "%@%@/device/ios",LoginCredentials.Redeemcouponapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        print(Param)
        Common.startloderonsubscription(view: self.view)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploderonsubscription(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: dict.value(forKey: "error") as! String)
                }
                else
                {
                    self.dismissalert(msg: dict.value(forKey: "result") as! String)
                    self.chekcUsersubscription()
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let pakeagename = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
        if(pakeagename == "1 Day @ Free")
        {
            if(Common.Isuserhavefreedayssubscription(Userdetails: self))
            {
                tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count-1) * 113.0
                ScroolviewHeightcntrant.constant = tabelviewhghtcontrant.constant + 50.0
                return 0.0
            }
        }
        
        
        return 113.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        
        print(LoginCredentials.UserPakegeList)
        return LoginCredentials.UserPakegeList.count
    }
    // cell height
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print(indexPath.row)
        print(LoginCredentials.UserPakegeList.count)
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[4] as! Custometablecell
        let pakeagename = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
        if(pakeagename == "1 Day @ Free")
        {
            
            Common.setuiviewdbordercolor(View: cell.subscriptionview, borderwidth: 2.0, bordercolor: UIColor.white)
            Common.getRounduiview(view: cell.subscriptionview, radius: 10.0)
            //cell.subscriptionname.textAlignment = .center
            cell.subscriptionname.text =  "Free Subscription"
            cell.subscriptionprice.text = "Watch ad and get one day free."
            cell.subscriptionprice.textColor = UIColor.green
            let issubcribed = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
            if(issubcribed == "1") {
                cell.issubscribebutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
                //cell.Isusersubscribedlabel.text = ""
            }
            else
            {
                cell.issubscribebutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
                
            }
        }
        else
        {
            
            Common.setuiviewdbordercolor(View: cell.subscriptionview, borderwidth: 2.0, bordercolor: UIColor.white)
            Common.getRounduiview(view: cell.subscriptionview, radius: 10.0)
            cell.subscriptionprice.textColor = UIColor.white
            cell.subscriptionname.textAlignment = .left
            cell.subscriptionname.text = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as? String
            
            var price = String()
            
            price = "\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_currency") as! String)\(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_price") as! String)"
            
            if let _ = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_have_discount") {
                
                
                let havediscount = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_have_discount") as! String
                
                if(havediscount == "0")
                {
                    price = "\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_currency") as! String)\(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_price") as! String)"
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
                    cell.subscriptionprice.attributedText = attributeString
                    
                }
                else
                {
                    
                    
                    let discoubtprice = "\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_currency") as! String)\(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_price_without_discnt") as! String)"
                    let finalprice = "\(discoubtprice) \(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_currency") as! String)\(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "ios_price") as! String)"
                    //                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalprice)
                    //                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, discoubtprice.length))
                    //                     cell.subscriptionprice.attributedText = attributeString
                    
                    
                    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: finalprice)
                    attributeString.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: NSMakeRange(0, discoubtprice.length))
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, discoubtprice.length))
                    cell.subscriptionprice.attributedText = attributeString
                    
                    
                    
                }
                
            }
                
            else
            {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
                cell.subscriptionprice.attributedText = attributeString
                
                
            }
            
            
            
            
            //            cell.subscriptionprice.text = "\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_currency") as! String)\(" ")\(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_price") as! String)"
            
            //  cell.subscriptiondatelabel.text = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "end_date") as? String
            cell.subscriptiondatelabel.text = ""
            
            let issubcribed = ((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
            if(issubcribed == "1") {
                if(((LoginCredentials.UserPakegeList.object(at: indexPath.row) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_type") as! String == "5") {
                    cell.issubscribebutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
                }
                else
                {
                    cell.issubscribebutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
                    // cell.Isusersubscribedlabel.text = ""
                    
                }
            }
            else
            {
                cell.issubscribebutton.setImage(#imageLiteral(resourceName: "unselectcircle"), for: .normal)
                
            }
            
            
            
        }
        cell.subscriptioncellbutton.tag = indexPath.row
        cell.subscriptioncellbutton.addTarget(self, action: #selector(clickoncell(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    
    
    
    func clickoncell(sender:UIButton)
    {
        
        print("Cell Tag \(sender.tag)")
        
        
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.Subscriptiontableview)
        let indexPath = self.Subscriptiontableview.indexPathForRow(at: buttonPosition)
        
        print("indexPath row \(indexPath?.row)")
        
        
        
        
        
        
        if(Common.Islogin())
        {
            
            //            if(!Common.Isuserissubscribenew(Userdetails: self as AnyObject))
            //            {
            //
            
            let selectedCell:Custometablecell = Subscriptiontableview.cellForRow(at: indexPath!)! as! Custometablecell
            
            selectedCell.issubscribebutton.setImage(#imageLiteral(resourceName: "Selectcircle"), for: .normal)
            let pakeagename = ((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
            if(pakeagename == "1 Day @ Free")
            {
                freesubscriptionid = ((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_id") as! NSString
                print(freesubscriptionid)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddLoderViewController") as! AddLoderViewController
                self.present(vc, animated: true, completion: nil)
                
                
            }
            else
            {
                
                print(LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!))
                Subscriptionpakageid = ((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_id") as! String
                Subscriptionpakagename = ((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "p_name") as! String
                
                Subscriptioniapname = "\(((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "period_interval") as! String)\(" ")\((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_name") as! String)"
                
                print(Subscriptioniapname)
                
                
                if(((LoginCredentials.UserPakegeList.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "package_type") as! String == "3") {
                    self.showonetimesubscription(titile: Subscriptionpakagename, description: "")
                    
                }
                else
                {
                    self.showsubcriptionalert(titile: Subscriptionpakagename, description: "")
                }
            }
            //            }
            //            else
            //            {
            //                EZAlertController.alert(title: "You are already subscribed")
            //            }
        }
        else
        {
            
            
            let alert = UIAlertController(title: "", message: "Please login to Subscripton", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            }))
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) in
                // self.dismiss(animated: true, completion: nil)
                self.goTologin()
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            //   Common.Showloginalert(view: self, text: "Please login to access this section")
        }
        
    }
    
    
    func dismissalert(msg:String)
    {
        let alert = UIAlertController(title: "", message:msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showonetimesubscription(titile:String,description:String) {
        
        let alert = UIAlertController(title: titile, message: description, preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        let addAction = UIAlertAction(title: "Continue With One Time Subscription", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Continue With One Time Subscription")
            self.Subscriptiontype = "NonRenewable"
            self.createSubscriptionorderid()
            
        })
        alert.addAction(addAction)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.cancel,
                                      handler: {(alert: UIAlertAction!) in
                                        self.Subscriptiontableview.reloadData()
        }))
        
        //   alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showsubcriptionalert(titile:String,description:String) {
        let alert = UIAlertController(title: titile, message: description, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        
        let addAction = UIAlertAction(title: "Continue With One Time Subscription", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Continue With One Time Subscription")
            self.Subscriptiontype = "NonRenewable"
            self.createSubscriptionorderid()
            
        })
        let addAction1 = UIAlertAction(title: "Continue With Auto Renewable Subscription", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Continue With Auto Renewvel Subscription")
            self.Subscriptiontype = "AutoRenewable"
            self.createSubscriptionorderid()
            
        })
        
        alert.addAction(addAction)
        alert.addAction(addAction1)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertActionStyle.cancel,
                                      handler: {(alert: UIAlertAction!) in
                                        self.Subscriptiontableview.reloadData()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func goTologin()
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func createSubscriptionorderid() {
        
        let newid = (Subscriptionpakageid as NSString).intValue
        print(newid)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let items = ["id":newid] as [String:Any]
        let itemsarray = [items]
        let cartdetail = ["items" :itemsarray] as [String:Any]
        print(cartdetail)
        print(Common.convertdictinyijasondata(data: cartdetail as NSDictionary))
        Common.startloderonsubscription(view: self.view)
        var Param = NSDictionary()
        
        
        if(LoginCredentials.Regiontype == "1")
        {
            Param =   ["cart":Common.convertdictinyijasondata(data: cartdetail as NSDictionary),
                       "c_id":(dict.value(forKey: "id") as! NSNumber),
                       "paymentgateway":"inapp",
                       "local_user":LoginCredentials.CreateorderRegiontype,
                       "state_code": LoginCredentials.SelectedUserCountry.value(forKey: "code") as! String,
                       "region_type":LoginCredentials.Regiontype
                ] as NSDictionary
        }
        else
        {
            Param =   ["cart":Common.convertdictinyijasondata(data: cartdetail as NSDictionary),
                       "c_id":(dict.value(forKey: "id") as! NSNumber),
                       "paymentgateway":"inapp",
                       "region_type":LoginCredentials.Regiontype
                ] as NSDictionary
        }
        print(Common.convertdictinyijasondata(data: Param as NSDictionary))
        var url = String()
        if(Subscriptiontype == "NonRenewable") {
            
            url = String(format: "%@%@/device/ios",LoginCredentials.Onetimecreateorderapi,Apptoken)
            
        }
        else if(Subscriptiontype == "AutoRenewable")
        {
            
            url = String(format: "%@%@/device/ios",LoginCredentials.Createorderapi,Apptoken)
            
        }
        
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    Common.stoploderonsubscription(view: self.view)
                    
                }
                    
                else
                {
                    
                    let subs_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "subscriber_id") as! Int
                    let Order_id = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "id") as! Int
                    print(subs_id)
                    self.PaywithIap(orderid: Int(Order_id), subscriptionid: subs_id)
                    
                }
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            self.Subscriptiontableview.reloadData()
            Common.stoploderonsubscription(view: self.view)
        }
        
        
        
    }
    
    
    func PaywithIap(orderid:Int,subscriptionid:Int)
    {
        
        print(Subscriptioniapname)
        let fullNameArr : [String] = Subscriptionpakagename.components(separatedBy: "@")
        var newsubscriptionname = fullNameArr[0]
        newsubscriptionname = newsubscriptionname.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        print(newsubscriptionname)
        
        print(Constant.getsubscriptionid(subscriptiontype: Subscriptiontype, subscriptionname: newsubscriptionname, regiontype:LoginCredentials.Regiontype))
        print(Constant.getsubscriptionid(subscriptiontype: Subscriptiontype, subscriptionname: Subscriptioniapname, regiontype:LoginCredentials.Regiontype))
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(Constant.getsubscriptionid(subscriptiontype: Subscriptiontype, subscriptionname: Subscriptioniapname, regiontype:LoginCredentials.Regiontype), atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            if case .success(let purchase) = result {
                print(result)
                // Deliver content from server, then:
                print(purchase.transaction.transactionIdentifier!)
                let trsnid = purchase.transaction.transactionIdentifier!
                print(purchase.productId)
                Common.stoploderonsubscription(view: self.view)
                self.VerifyPaymentourserver(tran_id: trsnid, sub_id: subscriptionid, orderid: orderid)
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if case .error(let eror) = result
            {
                print(eror.code)
                Common.stoploderonsubscription(view: self.view)
                
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
                
            }
        }
    }
    
    
    
    
    
    func VerifyPaymentourserver(tran_id:String,sub_id:Int,orderid:Int)
    {
        Common.startloderonsubscription(view: self.view)
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = (receiptData?.base64EncodedString(options: []))! as String
        print(receiptString)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        
        print(dict.value(forKey: "id") as! NSNumber)
        print(tran_id)
        print(receiptString)
        print(sub_id)
        print(orderid)
        
        let Param =   ["c_id":dict.value(forKey: "id") as! NSNumber,
                       "paymentgateway":"inapp",
                       "trans_id":tran_id,
                       "signature":receiptString,
                       "subscription_id":sub_id,
                       "order_id":orderid,
                       "status":"1"
            ] as [String:Any]
        print(Param)
        var url = String()
        if(Subscriptiontype == "NonRenewable") {
            
            url = String(format: "%@%@/device/ios",LoginCredentials.Onetimecompleteorderapi,Apptoken)
            
        }
        else if(Subscriptiontype == "AutoRenewable")
        {
            url = String(format: "%@%@/device/ios",LoginCredentials.Completeorderapi,Apptoken)
            
        }
        Common.startloderonsubscription(view: self.view)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                Common.stoploderonsubscription(view: self.view)
                self.chekcUsersubscription()
                self.dismiss(animated: true, completion: nil)
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
    
    
    func chekcUsersubscription()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict.value(forKey: "id") as! NSNumber)
        var url = String(format: "%@%@/device/ios/uid/%@/region_type/%@",LoginCredentials.Subscriptionpackageapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,LoginCredentials.Regiontype)
        
        
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        Common.stoploderonsubscription(view: self.view)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploderonsubscription(view: self.view)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                    
                }
                else
                {
                    if let _ = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list")
                    {
                        
                        let pakkagearray = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "package_list") as! NSArray
                        if(pakkagearray.count>0)
                        {
                            LoginCredentials.UserPakegeList = pakkagearray.mutableCopy() as! NSMutableArray
                        }
                        else
                        {
                            
                        }
                        
                        
                        self.getUsersubscriptiondetail()
                        
                        
                        
                    }
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonsubscription(view: self.view)
            
        }
        
    }
    
    
    
    func getUsersubscriptiondetail() {
        if(Common.Islogin()) {
            Common.startloderonsubscription(view: self.view)
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            print(dict.value(forKey: "id") as! NSNumber)
            var url = String(format: "%@%@/device/ios/uid/%@",LoginCredentials.Userpackagesapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
            url = url.trimmingCharacters(in: .whitespaces)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    Common.stoploderonsubscription(view: self.view)
                    
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                        
                    }
                    else
                    {
                        
                        if let _  = dict.value(forKey: "result")
                        {
                            LoginCredentials.Allusersubscriptiondetail = dict.value(forKey: "result") as! NSDictionary
                            print(LoginCredentials.Allusersubscriptiondetail)
                            
                        }
                        
                        
                        
                        if let _  = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list")
                        {
                            if(Common.isNotNull(object: (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as AnyObject))
                            {
                                if(((dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray).count>0) {
                                    LoginCredentials.UserSubscriptiondetail = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "packages_list") as! NSArray
                                }
                                else
                                {
                                    LoginCredentials.UserSubscriptiondetail = NSArray()
                                }
                            }
                        }
                        self.Subscriptiontableview.reloadData()
                        if(Common.Isuserhavefreedayssubscription(Userdetails: self))
                        {
                            self.tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count-1) * 113.0
                            self.ScroolviewHeightcntrant.constant = self.tabelviewhghtcontrant.constant + 50.0
                        }
                        else
                        {
                            self.tabelviewhghtcontrant.constant = CGFloat(LoginCredentials.UserPakegeList.count) * 113.0
                            self.ScroolviewHeightcntrant.constant = self.tabelviewhghtcontrant.constant + 50.0
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonsubscription(view: self.view)
                LoginCredentials.UserSubscriptiondetail = NSArray()
                LoginCredentials.Allusersubscriptiondetail = NSDictionary()
            }
        }
    }
    
    
    //////////////Free Subscription after watching video///////////
    func userFreesubscriptionapi()
    {
        
        let newid = freesubscriptionid.intValue
        print(newid)
        let items = ["id":newid] as [String:Any]
        let itemsarray = [items]
        let cartdetail = ["items" :itemsarray] as [String:Any]
        print(cartdetail)
        print(Common.convertdictinyijasondata(data: cartdetail as NSDictionary))
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let Param =   ["c_id":dict.value(forKey: "id") as! NSNumber,
                       "paymentgateway":"other",
                       "cart":Common.convertdictinyijasondata(data: cartdetail as NSDictionary),
                       ] as [String:Any]
        print(dict.value(forKey: "id") as! NSNumber)
        var url = String(format: "%@%@/device/ios",LoginCredentials.Freesubscriptionapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        print(url)
        print(Param)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
                AppUtility.lockOrientation(.portrait)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                }
                else
                {
                    self.chekcUsersubscription()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                        JYToast.init().isShow("You have earned one-day free subscription successfully")
                        
                    })
                    
                    
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func TapToCancel(_ sender: UIButton) {
        if(!Common.Isuserissubscribenew(Userdetails: self))
        {
            LoginCredentials.Regiontype = ""
        }
        self.dismiss(animated: true, completion: nil)
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
