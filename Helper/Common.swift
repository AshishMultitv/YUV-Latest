//
//  Common.swift
//  Eschool
//
//  Created by Desk28 on 03/08/15.
//  Copyright (c) 2015 Shree Ram. All rights reserved.
//

import UIKit
import CryptoSwift
import MBProgressHUD
import Foundation
import SystemConfiguration
import ReachabilitySwift
import CoreTelephony
import CZPicker


//For dev
//var MaterBaseUrl =  "http://staging.multitvsolution.com:9000/api/v6/master/url_static_staging"

//For Production
var MaterBaseUrl = "http://services.yuv.multitvsolution.com/api/v6/master/url_static"
////////////////////////////////PRODUCTION TOKEN ///////////////////////////////
//let Apptoken = "59a942cd8175f"
////////////////////////////////DEVLOPMENT   TOKEN ///////////////////////////////
let Apptoken = "5982e6bd0759f"
let Discriptioncolor = UIColor.init(colorLiteralRed: 110.0/255, green: 110.0/255, blue: 110.0/255, alpha: 1.0)
var timer:Timer!
let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
var picker: CZPickerView?


class Common: NSObject {
    
    
    static func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    static func setvideoplayeronview(testStr:UIView)
    {
        // println("validate calendar: \(testStr)")
    }
    static func Showloginalert(view:UIViewController,text:String)
    {
        let alert = UIAlertController(title: "YUV", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.destructive, handler: { action in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backactionnotofication"), object: nil, userInfo: nil)
            self.gotologinpage(view: view)
        }))
        view.present(alert, animated: true, completion: nil)
        
    }
    
    
    static func Isuserhavefreedayssubscription(Userdetails:AnyObject) -> Bool {
        
        if(LoginCredentials.Allusersubscriptiondetail.count>0) {
            
            if let _ = LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days")
            {
                let freedatys = Int(LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days") as! String) as! Int
                print(freedatys)
                if(freedatys>0)
                {
                    return true
                }
                
            }
            
        }
        return false
    }
    
    static func Isuserissubscribe(Userdetails:AnyObject) -> Bool {
        
        
        if(LoginCredentials.Ispaymentfailedonsever) {
            return true
        }

        if(LoginCredentials.UserSubscriptiondetail.count>0)
        {
            return true
        }
        if(LoginCredentials.Allusersubscriptiondetail.count>0) {
            
            if let _ = LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days")
            {
                let freedatys = Int(LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days") as! String) as! Int
                print(freedatys)
                if(freedatys>0)
                {
                    return true
                }
            }
            
        }
        
        if(LoginCredentials.UserPakegeList.count>0) {
            print(LoginCredentials.UserPakegeList)
            for i in 0..<LoginCredentials.UserPakegeList.count {
                let issubcribed = ((LoginCredentials.UserPakegeList.object(at: i) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
                if(issubcribed == "1") {
                    return true
                }
            }
            
            return false
        }
        else {
            return false
            
        }
        
    }
    
    
    static func Isuserissubscribenew(Userdetails:AnyObject) -> Bool {
        
        if(LoginCredentials.UserSubscriptiondetail.count>0)
        {
            return true
        }
        if(LoginCredentials.UserPakegeList.count>0) {
            print(LoginCredentials.UserPakegeList)
            for i in 0..<LoginCredentials.UserPakegeList.count {
                let issubcribed = ((LoginCredentials.UserPakegeList.object(at: i) as! NSDictionary).value(forKey: "s_package") as! NSDictionary).value(forKey: "is_subscriber") as! String
                if(issubcribed == "1") {
                    return true
                }
            }
            
            return false
        }
        else {
            return false
            
        }
        
    }
    
    static func PresentSubscription(Viewcontroller:UIViewController)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
        Viewcontroller.present(vc, animated: true, completion: nil)
        return
    }
    static func gotologinpage(view:UIViewController)
    {
        view.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        view.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    static func callappanalytics()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "useranalytics"), object: nil)
    }
    
    static func callUserfreesubscriptionapi()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Userfreesubscription"), object: nil)
    }
    
    
    static func stopHeartbeat()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }
    }
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    static func  getsplitnormalimageurl(url:String) -> String
    {
        print(url)
        if(url.contains("png"))
        {
            var splitnew = url
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = "\(splitnew )\("_480x270.png")"
            print(splitnew)
            return splitnew
        }
        else
        {
            var splitnew = url
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            print(splitnew)
            splitnew = "\(splitnew)\("_480x270.jpg")"
            print(splitnew)
            return splitnew
        }
        
        
        
        
    }
    static func  getsplitbannerimageurl(url:String) -> String
    {
        print(url)
        if(url.contains("png"))
        {
            var splitnew = url
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = "\(splitnew)\("_640x360.png")"
            print(splitnew)
            return splitnew
        }
        else
        {
            var splitnew = url
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = splitnew.substring(to: splitnew.index(before: splitnew.endIndex))
            splitnew = "\(splitnew)\("_640x360.jpg")"
            print(splitnew)
            return splitnew
        }
    }
    
    static func isEmptyOrWhitespace(testStr:String) -> Bool
    {
        let str = testStr.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if(testStr.isEmpty || str.isEmpty)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    static func isNotNull(object:AnyObject?) -> Bool
    {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
    
    static func isNotNSNull(object:AnyObject) -> Bool
    {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    static func isNotStringNull(object:AnyObject) -> Bool
    {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }
    
    
    static func gatedateheder(testStr:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: testStr)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date!)
        return result
    }
    
    
    static func isuserseletedlocality() -> Bool {
        
        if(LoginCredentials.Regiontype == "")
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    static func showuserlocationpopup(viewcontrooler:UIViewController) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectCountryViewController = storyboard.instantiateViewController(withIdentifier: "SelectCountryViewController") as! SelectCountryViewController
        //  viewcontrooler.navigationController?.pushViewController(selectCountryViewController, animated: true)
        viewcontrooler.present(selectCountryViewController, animated: true, completion: nil)
        
        //        LoginCredentials.UserCountry = ["India", "Outside India"]
        //        picker = CZPickerView(headerTitle: "Locality", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        //        picker?.allowMultipleSelection = false
        //        picker?.needFooterView = true
        //        picker?.delegate = viewcontrooler as! CZPickerViewDelegate
        //        picker?.dataSource = viewcontrooler as! CZPickerViewDataSource
        //        picker?.show()
        
        
        
    }
    
    
    
    
    
    static func CheckUserloginandsubscribtion(viewcontrolerl:UIViewController) -> Bool
    {
        
        if(!Common.Islogin()) {
            
            let alert = UIAlertController(title: "", message: "Please Login to watch Video", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) in
                Common.gotologinpage(view: viewcontrolerl)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
                //viewcontrolerl.navigationController?.popViewController(animated: true)
                print("Cancel")
            }))
            
            viewcontrolerl.present(alert, animated: true, completion: nil)
            return false
        }
        else
        {
            
            if(Common.Isuserissubscribe(Userdetails: self))
            {
                return true
            }
            else
            {
                
                
                //                let alert = UIAlertController(title: "", message: "Please Subscribe to watch our great video", preferredStyle: UIAlertControllerStyle.alert)
                //                alert.addAction(UIAlertAction(title: "Subscribe", style: UIAlertActionStyle.default, handler: { (action) in
                //
                //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                   let subscriptionView = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
                //                    viewcontrolerl.present(subscriptionView, animated: true, completion: nil)
                //                    //Common.PresentSubscription(Viewcontroller: viewcontrolerl)
                //                }))
                //
                //                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                //                 }))
                //                viewcontrolerl.present(alert, animated: true, completion: nil)
                //                return false
                
                
            //    if(Common.isuserseletedlocality()) {
                    
                    let alert = UIAlertController(title: "", message: "Please Subscribe to watch this  video", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Subscribe", style: UIAlertActionStyle.default, handler: { (action) in
                        
                        
                        
                        Common.PresentSubscription(Viewcontroller: viewcontrolerl)
                        
//                        if(!Common.isuserseletedlocality()) {
//
//                     //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                     //  let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
//                            Common.showuserlocationpopup(viewcontrooler: viewcontrolerl)
//
//                        }
//                        else
//                        {
//
//                        Common.PresentSubscription(Viewcontroller: viewcontrolerl)
//                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                        
                    }))
                    viewcontrolerl.present(alert, animated: true, completion: nil)
                    return false
                    
            //    }
                    
//                else
//                {
//                    // let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    //   let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
//                    Common.showuserlocationpopup(viewcontrooler: viewcontrolerl)
//                    return false
//                }
//
                
                
            }
            
        }
    }
    
    
    
    
    static func startloder(view:UIView)
    {
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    static func stoploder(view:UIView)
    {
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    static func startloderonplayer(view:UIView)
    {
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
    }
    
    static func stoploderonplayer(view:UIView)
    {
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    
    static func startloderonsubscription(view:UIView) {
        
        MBProgressHUD.showAdded(to:view, animated: true)
        
    }
    static func stoploderonsubscription(view:UIView) {
        
        MBProgressHUD.hide(for: view, animated: true)
        
    }
    static func getModelname()->String
    {
        let divice = UIDevice()
        return divice.modelName
    }
    
    static func getnetworktype()->String
        
    {
        let reachability = Reachability()!
        print(reachability.description)
        if(!reachability.isReachable)
        {
            return ""
        }
        if(reachability.isReachableViaWiFi)
        {
            return "WiFi"
        }
        else
        {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?:
                return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?:
                return "3G"
            case CTRadioAccessTechnologyLTE?:
                return "4G"
            default: return ""
            }
        }
        return ""
    }
    
    
    
    static func trimstring(text:String) ->String
    {
        var trim = text
        trim = trim.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trim
    }
    
    
    static func makewhitplaceholderintextview(textview:UITextView,string:String)
    {
        textview.text = string
        textview.textColor = UIColor.lightGray
    }
    
    static func Endtextviewplaceholder(textview:UITextView)
    {
        textview.text = nil
        textview.textColor = UIColor.black
    }
    
    
    static func decodedresponsedata(msg:String)-> NSMutableDictionary
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
        let jsonObject = try!JSONSerialization.jsonObject(with: encode.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions())as! NSDictionary
        return jsonObject.mutableCopy() as! NSMutableDictionary
    }
    
    static func decodedresponseheartbeat(msg:String)-> String
    {
        let keyString = "0123456789abcdef0123456789abcdef"
        let encode =  msg.aesDecrypt(key: keyString)
        return encode
    }
    
    
    
    static func makewhitplaceholder(textfiled:UITextField,string:String)
    {
        textfiled.attributedPlaceholder = NSAttributedString(string:string,
                                                             attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
    
    
    static func Isphonevalid(phoneNumber: String) -> Bool
    {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    static func Islogin() -> Bool
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        
        if (dict.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    static func Isvideolivetype(type: String) -> Bool
    {
        if(type == "1")
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    static func Isvideolvodtype(type: String) -> Bool
    {
        if(type == "0")
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    
    static func convertarrayinyijasondata(data:NSMutableArray) -> String
    {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data as NSMutableArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return otherDetailString
        }
        catch{
            
        }
        return ""
    }
    
    
    
    
    static func convertdictinyijasondata(data:NSDictionary) -> String
    {
        do {
            
            
            let jsonData = try JSONSerialization.data(withJSONObject: data,options: [])
            
            
            //            let jsonData = try JSONSerialization.data(withJSONObject: data as NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return otherDetailString
        }
        catch{
            
        }
        return ""
    }
    
    
    
    
    
    
    
    static func getRounduiview(view: UIView, radius:CGFloat)
    {
        view.layer.cornerRadius = radius;
        view.clipsToBounds=true
    }
    static func getRoundImage(imageView: UIImageView, radius:CGFloat)
    {
        imageView.layer.cornerRadius = radius;
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
    }
    
    static func getRounduibutton(button: UIButton, radius:CGFloat)
    {
        button.layer.cornerRadius = radius;
        button.clipsToBounds = true
        button.layer.masksToBounds = true
    }
    
    static func getRoundLabel(label: UILabel,borderwidth:CGFloat)
    {
        label.layer.cornerRadius = borderwidth
        label.clipsToBounds = true
        label.layer.masksToBounds = true
    }
    
    
    static func setuiviewdborderwidth(View: UIView, borderwidth:CGFloat)
    {
        View.layer.borderColor=UIColor.white.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
    
    static func setuiimageviewdborderwidth(imageView: UIImageView, borderwidth:CGFloat)
    {
        imageView.layer.borderColor=UIColor.white.cgColor
        imageView.layer.borderWidth=borderwidth
        imageView.clipsToBounds=true
    }
    
    
    static func settextfieldborderwidth(textfield: UITextField, borderwidth:CGFloat)
    {
        textfield.layer.borderColor=UIColor.white.cgColor
        textfield.layer.borderWidth=borderwidth
        textfield.layer.cornerRadius = 1.0
        textfield.clipsToBounds=true
    }
    
    
    static func settextviewborderwidth(textview: UITextView, borderwidth:CGFloat)
    {
        textview.layer.borderColor=UIColor.white.cgColor
        textview.layer.borderWidth=borderwidth
        textview.clipsToBounds=true
    }
    
    
    static func setbuttonborderwidth(button: UIButton, borderwidth:CGFloat)
    {
        button.layer.borderColor=UIColor.white.cgColor
        button.layer.borderWidth=borderwidth
        button.clipsToBounds=true
    }
    
    
    static func setuiviewdbordercolor(View: UIView, borderwidth:CGFloat,bordercolor:UIColor) {
        View.layer.borderColor=bordercolor.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
    
    static func setlebelborderwidth(label: UILabel, borderwidth:CGFloat)
    {
        label.layer.borderColor=UIColor.white.cgColor
        label.layer.borderWidth=borderwidth
        label.clipsToBounds=true
    }
    
    static func getstatickey() -> String
    {
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        var fullNameArr = uuid.components(separatedBy: "-")
        print(fullNameArr)
        let uniqekey = fullNameArr[fullNameArr.count-1]
        print(uniqekey)
        return uniqekey
        
    }
    static func ActivateUsersession()
    {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "activateusersession"), object: nil)
    }
    static func DeActivateUsersession()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deactivateusersession"), object: nil)
    }
    
    static func appLogout()
    {
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Pushback"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Userapplogout"), object: nil)
    }
    
    
    static func Verifyfailedpayment()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 300.0, execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Verifypayment"), object: nil)
         })
      
    }
    
    static func Pushback()
    {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Pushback"), object: nil)
    }
    
}
extension ViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        
        return nil
    }
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return 10
    }
    
    
    func czpickerView(_ pickerView: CZPickerView?, titleForRow row: Int) -> String? {
        return "Ashish"
    }
    
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        if(LoginCredentials.UserCountry[row] == "India") {
            LoginCredentials.UserCountry = ["Tamilnadu","Other"]
            picker?.reloadData()
            
        }
        else
        {
            LoginCredentials.UserCountry = ["India", "Outside India"]
        }
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
    }
    
    func czpickerView(_pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
    }
}
extension LeftViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        
        return nil
    }
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return LoginCredentials.UserCountry.count
    }
    
    
    func czpickerView(_ pickerView: CZPickerView?, titleForRow row: Int) -> String? {
        return LoginCredentials.UserCountry[row]
    }
    
    
    
    
    func czpickerView(_ pickerView: CZPickerView!, didclickonConfirmbuttonWithItemAtRow row: Int){
        print(LoginCredentials.UserCountry[row])
        
        
        if(LoginCredentials.UserCountry[row] == "Tamilnadu") {
            LoginCredentials.Regiontype = "1"
            LoginCredentials.CreateorderRegiontype = "1"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkusersubscription"), object: nil)
            return
        }
        if(LoginCredentials.UserCountry[row] == "Other") {
            LoginCredentials.Regiontype = "1"
            LoginCredentials.CreateorderRegiontype = "2"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkusersubscription"), object: nil)
            return
        }
        if(LoginCredentials.UserCountry[row] == "Outside India") {
            LoginCredentials.Regiontype = "2"
            LoginCredentials.CreateorderRegiontype = ""
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkusersubscription"), object: nil)
            return
        }
        
        
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        
        
        if(LoginCredentials.UserCountry[row] == "India") {
            LoginCredentials.UserCountry = ["Tamilnadu","Other"]
            picker?.reloadData()
            return
            
        }
        
        
        
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
    }
    
    func czpickerView(_pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        
    }
}

