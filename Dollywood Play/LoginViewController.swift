//
//  LoginViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 09/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import CoreTelephony
import AFNetworking
import FormToolbar



class LoginViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,UITextViewDelegate {
    
    
    
    @IBOutlet weak var email_txtfld: UITextField!
    @IBOutlet weak var Password_txtfld: UITextField!
    private let loader = FacebookUserLoader()
    var dictionaryOtherDetail = NSDictionary()
    var devicedetailss =  NSDictionary()
    var socail_dict =  NSDictionary()
    var uniqsocial_id =  String()
    var phone =  String()
    
    var type =  String()
    var fboremail =  String()
    var logindatadict = NSMutableDictionary()
    var toolbar = FormToolbar()
    var Isnewuser:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait)
          // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [email_txtfld, Password_txtfld])
        self.navigationController?.isNavigationBarHidden = true
        self.getloginpram()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func Taptosignup(_ sender: UIButton) {
        
        gotoSignupview()
        
    }
    
    @IBAction func Taptopasswordvisibility(_ sender: UIButton) {
        
        if(Password_txtfld.isSecureTextEntry)
        {
            Password_txtfld.isSecureTextEntry = false
        }
        else
        {
            Password_txtfld.isSecureTextEntry = true
        }
  
    }
    @IBAction func TaptoForgot(_ sender: UIButton) {
        gotoforgotview()
        //gotouserintersetview()
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        // User click on a link in a textview
        print(characterRange)
        // True => User can click on the URL Ling (otherwise return false)
        return true
    }
    
    @IBAction func Taptologin(_ sender: UIButton) {
        
        
        if(!Common.isValidEmail(testStr: email_txtfld.text!))
        {
            EZAlertController.alert(title: "Please enter Valid email id")
        }
        else if(!(Common.isEmptyOrWhitespace(testStr: Password_txtfld.text!)))
        {
            EZAlertController.alert(title: "Please enter Password")
        }
            
        else{
            type = "phone"
            //gotouserintersetview()
            getloginapi()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TAptoskip(_ sender: UIButton) {
        self.gotohomeacreen()   
        
    }
    @IBAction func Taptogoogle(_ sender: UIButton) {
        type = "social"
        fboremail = "google"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        // Common.startloder(view: self.view)
        
    }
    
    
    func getloginapi()
    {
        Common.startloder(view: self.view)
        do {
            
            
            /// phone, email, social
            var parameters = [String : Any]()
            
            
            
            
            if(type == "social")
            {
                if(fboremail == "facebook")
                {
                    
                    let param=Common.convertdictinyijasondata(data: devicedetailss)
                    print(param)
                    parameters = ["type":type,
                                  "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                  "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                  "social":Common.convertdictinyijasondata(data: socail_dict),
                                  "device": "ios",
                                  "provider":"facebook",
                    ]
                }
                else if(fboremail == "google")
                {
                    
                    
                    parameters = ["type":type,
                                  "dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                                  "dd":Common.convertdictinyijasondata(data: devicedetailss),
                                  "social":Common.convertdictinyijasondata(data: socail_dict),
                                  "device": "ios",
                                  "provider":"google"
                    ]
                    
                    
                    
                    
                    
                }
            }
            else
            {
                
                parameters = ["email":email_txtfld.text! as String,
                              "password":Password_txtfld.text! as String,
                              "devicedetail":Common.convertdictinyijasondata(data: devicedetailss),
                              "device_other_detail":Common.convertdictinyijasondata(data: dictionaryOtherDetail),
                              "device": "ios",
                ]
                
            }
            
            
            var url = String()
            
            if(type == "social")
            {
                url = String(format: "%@%@", LoginCredentials.SocialAPI,Apptoken)
                LoginCredentials.Issociallogin = true
                
            }
            else
            {
                url = String(format: "%@%@", LoginCredentials.LoginAPI,Apptoken)
                LoginCredentials.Issociallogin = false
                
            }
            
            //
            let jsonData = try JSONSerialization.data(withJSONObject: parameters,options: [])
            let otherDetailString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(url)
            print(otherDetailString)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    Common.stoploder(view: self.view)
                    print(dict)
                    if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                    {
                        EZAlertController.alert(title: "Please Enter valid Email or password")
                    }
                    else
                    {
                        if(LoginCredentials.IsencriptLoginAPI)
                        {
                            self.logindatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                        else
                        {
                            self.logindatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                        }
                        
                        
                        if let _ = dict.value(forKey: "new_user") {
                            if((dict.value(forKey: "new_user") as! NSNumber).stringValue == "1")
                            {
                                self.Isnewuser = true
                            }
                            else
                            {
                                self.Isnewuser = false
                            }
                        }
                        print(self.logindatadict)
                        
                        if((self.logindatadict.value(forKey: "status") as! String) == "inactive")
                        {
                            self.showinactiveuseralert(userid: ((self.logindatadict.value(forKey: "id") as! NSNumber).stringValue))
                            return
                        }
                        
                        
                        dataBase.deletedataentity(entityname: "Logindata")
                        dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: self.logindatadict)
                        self.getUsersubscriptiondetail()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "usersession"), object: nil)
                        
                        //                    if((Common.isNotNull(object: self.logindatadict.value(forKey: "age_group") as AnyObject?)) || (Common.isNotNull(object: self.logindatadict.value(forKey: "gender") as AnyObject?)) )
                        //                    {
                        //
                        //                      if(((self.logindatadict.value(forKey: "age_group") as! String) == "0-0") || ((self.logindatadict.value(forKey: "gender") as! String) == ""))
                        //                      {
                        //                        self.gotoskipprofilescreen()
                        //                        }
                        //                        else
                        //                      {
                        //                         }
                        //
                        //
                        //
                        //                    }
                        //                    else
                        //                    {
                        //                      self.gotoskipprofilescreen()
                        //                    }
                        //                    //self.gotouserintersetview()
                    }
                    
                }
            }
            ) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
        }
        catch
        {}
    }
    
    
    
    
    func showinactiveuseralert(userid:String)
    {
        let alert = UIAlertController(title: "", message: "This user is not active", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Mobile Number"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if(!Common.Isphonevalid(phoneNumber: (textField?.text)!))
            {
                EZAlertController.alert(title: "Please Enter Valid Mobile Number")
            }
            else
            {
                self.jurateotp(userid: userid, mobile: (textField?.text)!)
                //self.gotoOTPacreen(otp: "", userid: userid, mobileno: (textField?.text)!)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func jurateotp(userid:String,mobile:String)
    {
        Common.startloder(view: self.view)
        let parameters = [
            "user_id": userid,
            "type": "mobile",
            "value":mobile,
            ]
        let url = String(format: "%@%@", LoginCredentials.Otpgenerateapi,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                {
                    EZAlertController.alert(title: dict.value(forKey: "error") as! String)
                    return
                }
                else
                {
                    
                    self.gotoOTPacreen(otp: "", userid: userid, mobileno: mobile)
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
            
        }
    }
    
    
    
    func gotoOTPacreen(otp:String,userid:String,mobileno:String)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        oTPViewController.user_id = userid
        oTPViewController.mobileno = mobileno
        self.navigationController?.pushViewController(oTPViewController, animated: true)
        // self.slideMenuController()?.changeMainViewController(oTPViewController, close: true)
        
    }
    
    
    @IBAction func TAptoFacebook(_ sender: UIButton) {
        
        
        type = "social"
        fboremail = "facebook"
        
        Common.startloder(view: self.view)
        loader.load(askEmail: true, onError: { [weak self] in
            Common.stoploder(view: (self?.view)!)
            let alt:UIAlertView=UIAlertView(title: "YUV", message: "Cannot login with Facebook, something is missing. Try another account for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
            },
                    onSuccess: { [weak self] user in
                        self?.onUserLoaded(user: user)
        })
        
        
        
    }
    private func onUserLoaded(user: TegFacebookUser) {
        
        Common.stoploder(view: self.view)
        print("emailAddress\(user.email) and Gender is \(user.gender) and userFBID is \(user.id) and userprofilepIc url is \(user.profilePic)")
        
        if user.email != nil
        {
            uniqsocial_id = user.id as String
            socail_dict = [
                "first_name": user.firstName! as String,
                "last_name": user.lastName! as String,
                "gender": user.gender! as String,
                "link": "",
                "locale": "",
                "name": user.name! as String,
                "email": user.email! as String,
                "location": "",
                "dob": "",
                "id":user.id as String]
            self.getloginapi()
            
        }
        else
        {
            let alt:UIAlertView=UIAlertView(title: "YUV", message: "Cannot login with Facebook, email id is missing. Try another account or go for login.", delegate: nil, cancelButtonTitle: "OK")
            alt.show()
        }
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        //print("Sign in presented")
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        // print("Sign in dismissed")
    }
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if error == nil
        {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Welcome: ,\(userId), \(idToken), \(fullName), \(givenName), \(familyName), \(email)")
            uniqsocial_id = userId!
            
            socail_dict = [
                "first_name":user.profile.name,
                "last_name": "",
                "gender": "",
                "link": "",
                "locale": "",
                "name": user.profile.name,
                "email": user.profile.email,
                "location": "",
                "dob": "",
                "id":user.userID ]
            self.getloginapi()
            
        }
        
    }
    
    func getloginpram()
    {
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strResolution=String(format: "%.f*%.f", self.view.frame.size.width, self.view.frame.size.height)
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        print(uuid)
        
        
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname =  (carrier?.carrierName)! as String
        }
        
        dictionaryOtherDetail = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        devicedetailss = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "IOS",
            "device_unique_id" : uuid as String,//token! as! String,
            "push_device_token" :  LoginCredentials.DiviceToken
        ]
        print(dictionaryOtherDetail)
        print(devicedetailss)
        
        
        
    }
    
    
    
    
    
    
    
    @IBAction func BackButton_action(_ sender: UIButton) {
        
        
        
    }
    
    func gotoOTPacreen(otp:String,userid:String,type:String,value:String,data:NSMutableDictionary,resendotp:String)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        oTPViewController.user_id = userid
        oTPViewController.value = value
        oTPViewController.type = type
        oTPViewController.data = data
        oTPViewController.resendotp = resendotp
        
        self.navigationController?.pushViewController(oTPViewController, animated: true)
        // self.slideMenuController()?.changeMainViewController(oTPViewController, close: true)
        
    }
    
    
    func gotoforgotview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    
    func gotoSignupview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    
    func gotoskipprofilescreen()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SkipProfileViewController") as! SkipProfileViewController
        if(Isnewuser)
        {
            viewController.Isnewuser = "1"
        }
        else
        {
            viewController.Isnewuser = "2"
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotouserintersetview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userintersetViewController = storyboard.instantiateViewController(withIdentifier: "UserintersetViewController") as! UserintersetViewController
        self.navigationController?.pushViewController(userintersetViewController, animated: true)
    }
    
    
    func gotohomeacreen()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //self.slideMenuController()?.changeMainViewController(SignoutViewController, close: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotorefreelscreen()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RedeemReferralViewController") as! RedeemReferralViewController
        //self.slideMenuController()?.changeMainViewController(SignoutViewController, close: true)
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
                    
                    
                    //                    if(self.type == "social") {
                    //                        
                    //                        if(self.Isnewuser)
                    //                      {
                    //                        self.gotorefreelscreen()
                    //                        return
                    //                        }
                    //                        
                    //                    }
                    //   
                    if(((self.logindatadict.value(forKey: "age_group") as! String) == "0-0") || ((self.logindatadict.value(forKey: "gender") as! String) == ""))
                    {
                        self.gotoskipprofilescreen()
                        return
                    }
                    
                    
                    self.gotohomeacreen()
                    
                    
                    //
                    //                       if(self.type == "social")
                    //                    {
                    //                        if(self.Isnewuser)
                    //                        {
                    //                            self.gotorefreelscreen()
                    //                            return
                    //                        }
                    //                        else
                    //                        {
                    //                            self.gotohomeacreen()
                    //                            return
                    //
                    //                        }
                    //                    }
                    //
                    //                    else
                    //                    {
                    //                        self.gotohomeacreen()
                    //                         return
                    //                    }
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
        }
    }
    
    
    
    
    @IBAction func Skipbutonaction(_ sender: UIButton) {
        UserDefaults.standard.setValue("skip", forKey: "skip")
        LoginCredentials.Isskip = true
        gotohomeacreen()
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        self.toolbar.update()
        
    }
    
    
    
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y = -50
        //  myscroll.contentInset = contentInsets
        // myscroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0.0
        // myscroll.contentInset = .zero
        //  myscroll.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        
        AppUtility.lockOrientation(.portrait)
        self.perform(#selector(changeOrientation), with: nil, afterDelay: 5.0)
    }
    func changeOrientation()
    {
        AppUtility.lockOrientation(.portrait)
    }
    
  
}
