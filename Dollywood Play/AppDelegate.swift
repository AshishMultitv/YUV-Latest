

//
//  AppDelegate.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 25/05/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import AFNetworking
import UserNotifications
import SystemConfiguration
import CryptoSwift
import CoreTelephony
import Fabric
import Crashlytics
import OneSignal
import ATAppUpdater
import GoogleCast
import AVFoundation


let kPrefPreloadTime = "preload_time_sec"
let kPrefEnableAnalyticsLogging = "enable_analytics_logging"
let kPrefEnableSDKLogging = "enable_sdk_logging"
let kPrefAppVersion = "app_version"
let kPrefSDKVersion = "sdk_version"
let kPrefReceiverAppID = "receiver_app_id"
let kPrefCustomReceiverSelectedValue = "use_custom_receiver_app_id"
let kPrefCustomReceiverAppID = "custom_receiver_app_id"
let kPrefEnableMediaNotifications = "enable_media_notifications"
let kApplicationID: String? = nil
let appDelegate = (UIApplication.shared.delegate as? AppDelegate)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,OSSubscriptionObserver {
    
    
    var window: UIWindow?
    var catid = String()
    var Isdeeplinking:Bool = false
    
    
    var orientationLock = UIInterfaceOrientationMask.all
    
    fileprivate var enableSDKLogging = false
    fileprivate var mediaNotificationsEnabled = false
    fileprivate var firstUserDefaultsSync = false
    fileprivate var useCastContainerViewController = false
    var mediaList: MediaListModel!
    
    
    var isCastControlBarsEnabled: Bool {
        get {
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                return castContainerVC!.miniMediaControlsItemEnabled
            } else {
                let rootContainerVC = (window?.rootViewController as? ViewController)
                return rootContainerVC!.miniMediaControlsViewEnabled
            }
        }
        set(notificationsEnabled) {
            if useCastContainerViewController {
                var castContainerVC: GCKUICastContainerViewController?
                castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = notificationsEnabled
            } else {
                
                var rootContainerVC: ViewController?
                rootContainerVC = (window?.rootViewController as? ViewController)
                rootContainerVC?.miniMediaControlsViewEnabled = notificationsEnabled
                
            }
        }
    }

    fileprivate func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            if(Common.isInternetAvailable())
            {
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                leftViewController.HomeViewController = nvc
                
                let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
                slideMenuController.delegate = mainViewController
                
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }
            else{
                
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
                let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                leftViewController.HomeViewController = nvc
                
                let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
                
                
            }
        }
        else
        {
            
            if(Common.isInternetAvailable())
            {
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                leftViewController.HomeViewController = nvc
                
                let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
                slideMenuController.delegate = mainViewController
                
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }
            else
            {
                
                print("not skipped")
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                leftViewController.HomeViewController = nvc
                
                let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                // let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: nil)
                slideMenuController.automaticallyAdjustsScrollViewInsets = true
                self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
            }
        }
        
    }

    func userlogoutfromapp()
    {
        
        Common.DeActivateUsersession()
        dataBase.deletedataentity(entityname: "Logindata")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
        dataBase.deletedataentity(entityname: "Downloadvideoid")
        Common.stopHeartbeat()
        print("User Logout From aPp")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //        self.window?.rootViewController = loginViewController
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        leftViewController.HomeViewController = nvc
        let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController as? SlideMenuControllerDelegate
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LoginCredentials.Isallapicall = false
        dataBase.deletedataentity(entityname: "Channeldata")
        //  ATAppUpdater.init().showUpdateWithConfirmation()
        self.Getmasterurl()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "708011623836-e6c5naj5lfdnfhnjfjj5m7q1dekq23qh.apps.googleusercontent.com"
        
        Fabric.with([Crashlytics.self])
        
        /////Set UDID
        let uuid = UUID().uuidString
        if UserDefaults.standard.value(forKey: "UUID") as? String != nil {
            print("already uuid")
        }
        else
        {
            UserDefaults.standard.set(uuid as String, forKey: "UUID")
        }
        //        ///SEt Notification
        //
        //                 if #available(iOS 10.0, *) {
        //                    let center = UNUserNotificationCenter.current()
        //                    center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        //                        // Enable or disable features based on authorization.
        //                    }
        //                    application.registerForRemoteNotifications()
        //                } else {
        //                    if #available(iOS 9, *) {
        //                        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        //                        UIApplication.shared.registerForRemoteNotifications()
        //                    }
        //                    // Fallback on earlier versions
        //                }
        application.applicationIconBadgeNumber = 0
        NotificationCenter.default.addObserver(self, selector: #selector(appanalytics), name: NSNotification.Name(rawValue: "useranalytics"), object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(activateUserappsession),name: NSNotification.Name(rawValue: "activateusersession"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(deActivateUserappsession),name: NSNotification.Name(rawValue: "deactivateusersession"),object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(userlogoutfromapp),name: NSNotification.Name(rawValue: "Userapplogout"),object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(IapVerifyPaymentourserver),name: NSNotification.Name(rawValue: "Verifypayment"),object: nil)
        
        
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock =
        { notification in
            
            print("Did Recive notofiasd")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            if let additionalData = result!.notification.payload!.additionalData {
                if let _ = additionalData["type"]
                {
                    let type = additionalData["type"] as! String
                    if(type == "SESSION_EXPIRY")
                    {
                        if(Common.Islogin())
                        {
                            Common.appLogout()
                            return
                        }
                        else
                        {
                            return
                        }
                    }
                }
                
                
                
                print(additionalData)
                if let _ = additionalData["id"] {
                    
                  if(!Common.Islogin()) {
                    return
                    }
                    if(!Common.Isuserissubscribe(Userdetails: self))
                    {
                      return
                    }
                    
                    print(additionalData["id"] as! String)
                    self.catid = additionalData["id"] as! String
                    print(self.catid)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                    mainViewController.cat_id = self.catid
                    mainViewController.Isfromdeeplinking = true
                    self.Isdeeplinking = true
                    let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
                    let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                    UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
                    leftViewController.HomeViewController = nvc
                    let slideMenuController =   ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
                    slideMenuController.automaticallyAdjustsScrollViewInsets = true
                    self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
                    self.window?.rootViewController = slideMenuController
                    self.window?.makeKeyAndVisible()
           
            }
                // DEEP LINK and open url in RedViewController
                // Send notification with Additional Data > example key: "OpenURL" example value: "https://google.com"
                
                if let actionSelected = payload?.actionButtons {
                    print("actionSelected = \(actionSelected)")
                    
                }
                
                // DEEP LINK from action buttons
                if let actionID = result?.action.actionID {
                    // For presenting a ViewController from push notification action button
                    print("actionID = \(actionID)")
                }
            }
        }
        
        
        /////////REGISTER ONE SINGLE NOTIFICATION?//////
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.add(self as OSSubscriptionObserver)
        // OneSignal.initWithLaunchOptions(launchOptions, appId: "2662a68c-d7cc-4d92-bc47-2de7d0b5965c", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        //16b95c8e-6fd7-46cc-a1c4-a5ccde92da78 /// Ye kis app
        OneSignal.initWithLaunchOptions(launchOptions, appId: "2662a68c-d7cc-4d92-bc47-2de7d0b5965c", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            
        })
        
        
        //       // let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
        //          let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        //
        //        OneSignal.initWithLaunchOptions(launchOptions, appId: "16b95c8e-6fd7-46cc-a1c4-a5ccde92da78", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        //
        //        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        //        print(Common.getstatickey())
        
        
        ///////CROME CAST
        
        populateRegistrationDomain()
        // Don't try to go on without a valid application ID - SDK will fail an
        // assert and app will crash.
        guard let applicationID = applicationIDFromUserDefaults(), applicationID != "" else {
            return true
        }
        useCastContainerViewController = false
        let options = GCKCastOptions(receiverApplicationID: applicationID)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        window?.clipsToBounds = true
        setupCastLogging()
        
        // Set playback category mode to allow playing audio on the video files even
        // when the ringer mute switch is on.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let setCategoryError {
            print("Error setting audio category: \(setCategoryError.localizedDescription)")
        }
        
        if useCastContainerViewController {
            let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = appStoryboard.instantiateViewController(withIdentifier: "MainNavigation")
                as? UINavigationController else { return false }
            let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(for: navigationController)
                as GCKUICastContainerViewController
            castContainerVC.miniMediaControlsItemEnabled = true
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = castContainerVC
            window?.makeKeyAndVisible()
        } else {
            let rootContainerVC = (window?.rootViewController as? ViewController)
            rootContainerVC?.miniMediaControlsViewEnabled = true
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(syncWithUserDefaults),
                                               name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentExpandedMediaControls),
                                               name: NSNotification.Name.gckExpandedMediaControlsTriggered, object: nil)
        firstUserDefaultsSync = true
        syncWithUserDefaults()
        UIApplication.shared.statusBarStyle = .lightContent
        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
        
       
        if(LoginCredentials.Ispaymentfailedonsever)
        {
           IapVerifyPaymentourserver()
        }
        return true

    }
    
    
    
    /////Notification Delegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceTokenString >>",deviceTokenString)
        LoginCredentials.DiviceToken = deviceTokenString
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        LoginCredentials.DiviceToken = ""
    }
    
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            LoginCredentials.OnesinglePlayerid = playerId
            self.Refreshtoken(playerid: LoginCredentials.OnesinglePlayerid)
        }
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("Recived: \(userInfo)")
        completionHandler(.newData)
        if let _ = userInfo["custom"] {
            
            if let _  = (userInfo["custom"] as! NSDictionary).value(forKey: "a")
            {
                let dict  = (userInfo["custom"] as! NSDictionary).value(forKey: "a") as! NSDictionary
                if let _ = dict.value(forKey: "type")
                {
                let type = dict.value(forKey: "type") as! String
                if(type == "SESSION_EXPIRY")
                {
                    if(Common.Islogin())
                    {
                        Common.appLogout()
                    }
                }
            }
            }
            
            
        }
        
        
        if let _ = userInfo["type"]
        {
            let typeStr = userInfo["type"] as! String
            print(typeStr)
            if typeStr == "SESSION_EXPIRY" {
                print("Content updated")
                if(Common.Islogin())
                {
                    Common.appLogout()
                }
            }
            else if typeStr == "SESSION_INACTIVE" {
                print("SESSION_INACTIVE")
                if(Common.Islogin())
                {
                    Common.Pushback()
                }
            }
            
        }
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == .active {
            //opened from a push notification when the app was on background
            print(userInfo)
        }
        else
        {
            print(userInfo)
        }
        print(userInfo)
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
        
        print("userInfo",userInfo)
        let typeStr = userInfo["type"] as! String
        
        if typeStr == "SESSION_EXPIRY" {
            print("Content updated")
            if(Common.Islogin())
            {
                Common.appLogout()
            }
        }
        else if typeStr == "SESSION_INACTIVE" {
            print("SESSION_INACTIVE")
            if(Common.Islogin())
            {
                Common.Pushback()
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    func activateUserappsession()
    {
        if(Common.Islogin())
        {
            
            let uuid = UIDevice.current.identifierForVendor!.uuidString
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            let json = ["device":"ios","customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,"content_id":"", "session_status":"active","device_unique_id" : uuid as String] as [String : Any]
            print("CAll USER ACTIVE SESSION")
            print("json >>",json)
            
            var url = String(format: "%@%@", LoginCredentials.Ifallowedapi,Apptoken)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
            
        }
    }
    
    func deActivateUserappsession()
    {
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            let uuid = UIDevice.current.identifierForVendor!.uuidString
            let json = ["device":"ios","customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue  ,"content_id":"", "session_status":"inactive","device_unique_id" : uuid as String] as [String : Any]
            print("CAll DE USER ACTIVE SESSION")
            print("json >>",json)
            var url = String(format: "%@%@", LoginCredentials.Ifallowedapi,Apptoken)
            print(url)
            url = url.trimmingCharacters(in: .whitespaces)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
            
        }
    }
    
    
    
    ///////getMasterurl Update
    
    func Getmasterurl()
    {
        let url = String(format: "%@/token/%@", MaterBaseUrl,Apptoken)
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
                    
                    let Catdata_dict = dict.value(forKey: "result") as! NSDictionary
                    print(Catdata_dict)
                    
                    ////////////////////////////////addapi 1  //////////////////////////
                    let addapi = Catdata_dict.value(forKey: "add") as! String
                    let addapiArr : [String] = addapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AddAPi = addapiArr[1]
                    if((addapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddAPi = false
                    }
                    
                    ////////////////////////////////addetail  2 /  /////////////////////////
                    let addetailapi = Catdata_dict.value(forKey: "addetail") as! String
                    let addetailapiArr : [String] = addetailapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Addetailapi = addetailapiArr[1]
                    if((addetailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAddetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAddetailapi = false
                    }
                    
                    ////////////////////////////////analytics  3//////////////////////////
                    let analyticslapi = Catdata_dict.value(forKey: "analytics") as! String
                    let analyticslapiArr : [String] = analyticslapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Analyticsappapi = analyticslapiArr[1]
                    if((analyticslapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAnalyticsappapi = false
                    }
                    
                    
                    ////////////////////////////////autosuggest  4//////////////////////////
                    let autosuggestapi = Catdata_dict.value(forKey: "autosuggest") as! String
                    let autosuggestapiArr : [String] = autosuggestapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Autosuggestapi = autosuggestapiArr[1]
                    if((autosuggestapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAutosuggestapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAutosuggestapi = false
                    }
                    
                    
                    
                    ////////////////////////////////catlist  5  //////////////////////////
                    let catlistapi = Catdata_dict.value(forKey: "catlist") as! String
                    let catlistapiArr : [String] = catlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.catlistapi = catlistapiArr[1]
                    if((catlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptcatlistapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptcatlistapi = false
                    }
                    
                    ////////////////////////////////channel_list 6  //////////////////////////
                    let channellistapi = Catdata_dict.value(forKey: "channel_list") as! String
                    let channellistapiArr : [String] = channellistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Channellistapi = channellistapiArr[1]
                    if((channellistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptChannellistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptChannellistapi = false
                    }
                    
                    
                    ////////////////////////////////comment_add   7  //////////////////////////
                    let commentaddapi = Catdata_dict.value(forKey: "comment_add") as! String
                    let commentaddapiArr : [String] = commentaddapi.components(separatedBy: "|,")
                    
                    LoginCredentials.CommentaddAPi = commentaddapiArr[1]
                    if((commentaddapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentaddAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentaddAPi = false
                    }
                    
                    ////////////////////////////////commentlist  8  //////////////////////////
                    let commentlistapi = Catdata_dict.value(forKey: "comment_list") as! String
                    let commentlistapiArr : [String] = commentlistapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Commentlistapi = commentlistapiArr[1]
                    if((commentlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptCommentlistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptCommentlistapi = false
                    }
                    
                    ////////////////////////////////detail 9 //////////////////////////
                    let detailapi = Catdata_dict.value(forKey: "detail") as! String
                    let detailapiArr : [String] = detailapi.components(separatedBy: "|,")
                    LoginCredentials.Detailapi = detailapiArr[1]
                    if((detailapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDetailapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDetailapi = false
                    }
                    
                    ////////////////////////////////deviceinfo   10  //////////////////////////
                    let deviceinfoapi = Catdata_dict.value(forKey: "deviceinfo") as! String
                    let deviceinfoapiArr : [String] = deviceinfoapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Deviceinfoapi = deviceinfoapiArr[1]
                    if((deviceinfoapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDeviceinfoapi = false
                    }
                    
                    
                    ////////////////////////////////dislike   11   //////////////////////////
                    let dislikeapi = Catdata_dict.value(forKey: "dislike") as! String
                    let dislikeapiArr : [String] = dislikeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Dislikeapi = dislikeapiArr[1]
                    if((dislikeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptDislikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptDislikeapi = false
                    }
                    
                    
                    ////////////////////////////////edit    12   //////////////////////////
                    if let _ = Catdata_dict.value(forKey: "edit")  {
                        let editapi = Catdata_dict.value(forKey: "edit") as! String
                        let editapiArr : [String] = editapi.components(separatedBy: "|,")
                        
                        LoginCredentials.Editapi = editapiArr[1]
                        if((editapiArr[0] as String) == "0")
                        {
                            LoginCredentials.IsencriptEditapi = true
                        }
                        else
                        {
                            LoginCredentials.IsencriptEditapi = false
                        }
                    }
                    ////////////////////////////////forgot   13   //////////////////////////
                    let forgotapi = Catdata_dict.value(forKey: "forgot") as! String
                    let forgotapiArr : [String] = forgotapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Forgotapi = forgotapiArr[1]
                    if((forgotapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptForgotapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptForgotapi = false
                    }
                    
                    ////////////////////////////////home    13    //////////////////////////
                    let homeapi = Catdata_dict.value(forKey: "home_content") as! String
                    let homeapiArr : [String] = homeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Homeapi = homeapiArr[1]
                    if((homeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptHomeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptHomeapi = false
                    }
                    
                    
                    
                    ////////////////////////////////like    14    //////////////////////////
                    let likeapi = Catdata_dict.value(forKey: "like") as! String
                    let likeapiArr : [String] = likeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Likeapi = likeapiArr[1]
                    if((likeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLikeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLikeapi = false
                    }
                    
                    
                    ////////////////////////////////list   15    //////////////////////////
                    let listapi = Catdata_dict.value(forKey: "list") as! String
                    let listapiArr : [String] = listapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Listapi = listapiArr[1]
                    if((listapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptListapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptListapi = false
                    }
                    
                    
                    ////////////////////////////////login  16   //////////////////////////
                    let loginapi = Catdata_dict.value(forKey: "login") as! String
                    let loginapiArr : [String] = loginapi.components(separatedBy: "|,")
                    
                    LoginCredentials.LoginAPI = loginapiArr[1]
                    if((loginapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptLoginAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptLoginAPI = false
                    }
                    
                    ////////////////////////////////menu   17   //////////////////////////
                    let menuapi = Catdata_dict.value(forKey: "menu") as! String
                    let menuapiArr : [String] = menuapi.components(separatedBy: "|,")
                    
                    LoginCredentials.MenuAPi = menuapiArr[1]
                    if((menuapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptMenuAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptMenuAPi = false
                    }
                    
                    ////////////////////////////////otp_generate  18    //////////////////////////
                    let otpgenerateapi = Catdata_dict.value(forKey: "otp_generate") as! String
                    let otpgenerateapiArr : [String] = otpgenerateapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Otpgenerateapi = otpgenerateapiArr[1]
                    if((otpgenerateapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptOtpgenerateapi = false
                    }
                    
                    ////////////////////////////////playlist    19   //////////////////////////
                    let playlistapi = Catdata_dict.value(forKey: "playlist") as! String
                    let playlistapiArr : [String] = playlistapi.components(separatedBy: "|,")
                    LoginCredentials.Playlistapi = playlistapiArr[1]
                    if((playlistapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptPlaylistapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptPlaylistapi = false
                    }
                    
                    
                    ////////////////////////////////rating     20    //////////////////////////
                    let ratingapi = Catdata_dict.value(forKey: "rating") as! String
                    let ratingapiArr : [String] = ratingapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Ratingapi = ratingapiArr[1]
                    if((ratingapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRatingapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRatingapi = false
                    }
                    
                    ////////////////////////////////recomended    21   //////////////////////////
                    let recomendedapi = Catdata_dict.value(forKey: "recomended") as! String
                    let recomendedapiArr : [String] = recomendedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Recomendedapi = recomendedapiArr[1]
                    if((recomendedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptRecomendedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptRecomendedapi = false
                    }
                    
                    ////////////////////////////////search     22     //////////////////////////
                    let searchapi = Catdata_dict.value(forKey: "search") as! String
                    let searchapiArr : [String] = searchapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Searchapi = searchapiArr[1]
                    if((searchapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSearchapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSearchapi = false
                    }
                    
                    ////////////////////////////////social     23     //////////////////////////
                    let socialapi = Catdata_dict.value(forKey: "social") as! String
                    let socialapiArr : [String] = socialapi.components(separatedBy: "|,")
                    
                    LoginCredentials.SocialAPI = socialapiArr[1]
                    if((socialapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSocialAPI = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSocialAPI = false
                    }
                    
                    
                    
                    ////////////////////////////////subscribe     24     //////////////////////////
                    let subscribeapi = Catdata_dict.value(forKey: "subscribe") as! String
                    let subscribeapiArr : [String] = subscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Subscribeapi = subscribeapiArr[1]
                    if((subscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptSubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptSubscribeapi = false
                    }
                    
                    ////////////////////////////////unsubscribe     25      //////////////////////////
                    let unsubscribeapi = Catdata_dict.value(forKey: "unsubscribe") as! String
                    let unsubscribeapiArr : [String] = unsubscribeapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Unsubscribeapi = unsubscribeapiArr[1]
                    if((unsubscribeapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUnsubscribeapi = false
                    }
                    
                    ////////////////////////////////udatedevice      26    //////////////////////////
                    let udatedeviceapi = Catdata_dict.value(forKey: "udatedevice") as! String
                    let udatedeviceapiArr : [String] = udatedeviceapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Udatedeviceapi = udatedeviceapiArr[1]
                    if((udatedeviceapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUdatedeviceapi = false
                    }
                    
                    ////////////////////////////////user_behavior     27     //////////////////////////
                    let userbehaviorapi = Catdata_dict.value(forKey: "user_behavior") as! String
                    let userbehaviorapiArr : [String] = userbehaviorapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userbehaviorapi = userbehaviorapiArr[1]
                    if((userbehaviorapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserbehaviorapi = false
                    }
                    
                    
                    
                    ////////////////////////////////userrelated    28     //////////////////////////
                    let userrelatedapi = Catdata_dict.value(forKey: "userrelated") as! String
                    let userrelatedapiArr : [String] = userrelatedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Userrelatedapi = userrelatedapiArr[1]
                    if((userrelatedapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptUserrelatedapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptUserrelatedapi = false
                    }
                    
                    ////////////////////////////////verify_otp    29     //////////////////////////
                    let verifyotpapi = Catdata_dict.value(forKey: "verify_otp") as! String
                    let verifyotpapiArr : [String] = verifyotpapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Verifyotpapi = verifyotpapiArr[1]
                    if((verifyotpapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVerifyotpapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVerifyotpapi = false
                    }
                    
                    ////////////////////////////////version    30     //////////////////////////
                    let versionapi = Catdata_dict.value(forKey: "version") as! String
                    let versionapiArr : [String] = versionapi.components(separatedBy: "|,")
                    
                    LoginCredentials.AppVersionAPi = versionapiArr[1]
                    if((versionapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptAppVersionAPi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptAppVersionAPi = false
                    }
                    
                    ////////////////////////////////version_check      31    //////////////////////////
                    let versioncheckapi = Catdata_dict.value(forKey: "version_check") as! String
                    let versioncheckapiArr : [String] = versioncheckapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Versioncheckapi = versioncheckapiArr[1]
                    if((versioncheckapiArr[0] as String) == "0")
                    {
                        LoginCredentials.IsencriptVersioncheckapi = true
                    }
                    else
                    {
                        LoginCredentials.IsencriptVersioncheckapi = false
                    }
                    
                    ////////////////////////////////watchduration     32         //////////////////////////
                    let watchdurationapi = Catdata_dict.value(forKey: "watchduration") as! String
                    let watchdurationapiArr : [String] = watchdurationapi.components(separatedBy: "|,")
                    LoginCredentials.watchdurationapi = watchdurationapiArr[1]
                    if((watchdurationapiArr[0] as String) == "0")
                    {
                        LoginCredentials.Isencriptwatchdurationapi = true
                    }
                    else
                    {
                        LoginCredentials.Isencriptwatchdurationapi = false
                    }
                    
                    
                    
                    
                    ////////////////////////////////ifallowed    33         //////////////////////////
                    let ifallowedapi = Catdata_dict.value(forKey: "ifallowed") as! String
                    let ifallowedapiArr : [String] = ifallowedapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Ifallowedapi = ifallowedapiArr[1]
                    
                    
                    
                    ////////////////////////////////abuse     33         //////////////////////////
                    let abuseapi = Catdata_dict.value(forKey: "abuse") as! String
                    let abuseapiArr : [String] = abuseapi.components(separatedBy: "|,")
                    
                    LoginCredentials.Abuseapi = abuseapiArr[1]
                    
                    
                    
                    //////////////////////////////Fauvout   33   //////////////////////////
                    let fauvoutapi = Catdata_dict.value(forKey: "favorite") as! String
                    let fauvoutapiArr : [String] = fauvoutapi.components(separatedBy: "|,")
                    LoginCredentials.Favrioutapi = fauvoutapiArr[1]
                    
    
                    
                    
                    ////////////////////////////////Autosugection     34        //////////////////////////
                    let Autosugectionapi = Catdata_dict.value(forKey: "autosuggest") as! String
                    let Autosugectionarra : [String] = Autosugectionapi.components(separatedBy: "|,")
                    LoginCredentials.Autosuggestapi = Autosugectionarra[1]
                    
                    ////////////////////////////////Clearwatchapi     34        //////////////////////////
                    let Clearwatchapi = Catdata_dict.value(forKey: "clear_watch") as! String
                    let Clearwatchapiarra : [String] = Clearwatchapi.components(separatedBy: "|,")
                    LoginCredentials.Clearwatchapi = Clearwatchapiarra[1]
                    
                    
                        ///////Subscription///////////////////
                    
                    
                    //////////////////////////////subs_redeem_refferal   34   //////////////////////////
                    let redeemrefferalapi = Catdata_dict.value(forKey: "subs_redeem_refferal") as! String
                    let redeemrefferalapiArr : [String] = redeemrefferalapi.components(separatedBy: "|,")
                    LoginCredentials.Redeemrefferalapi = redeemrefferalapiArr[1]
                    
                    
                    //////////////////////////////subs_redeem_coupon   34   //////////////////////////
                    let redeemcouponapi = Catdata_dict.value(forKey: "subs_redeem_coupon") as! String
                    let redeemcouponapiArr : [String] = redeemcouponapi.components(separatedBy: "|,")
                    LoginCredentials.Redeemcouponapi = redeemcouponapiArr[1]
                    
                    //////////////////////////////subs_create_order_onetime   34   //////////////////////////
                    let createorderonetimeapi = Catdata_dict.value(forKey: "subs_create_order_onetime") as! String
                    let createorderonetimeapiArr : [String] = createorderonetimeapi.components(separatedBy: "|,")
                    LoginCredentials.Onetimecreateorderapi = createorderonetimeapiArr[1]
                    
                   
                    
                    //////////////////////////////subs_create_order_autorenewl   34   //////////////////////////
                    let createorderautorenewlapi = Catdata_dict.value(forKey: "subs_create_order_autorenewl") as! String
                    let createorderautorenewlapiArr : [String] = createorderautorenewlapi.components(separatedBy: "|,")
                    LoginCredentials.Createorderapi = createorderautorenewlapiArr[1]
                    
                    
                    
                    //////////////////////////////subs_complete_order_onetime   34   //////////////////////////
                    let completeorderonetimeapi = Catdata_dict.value(forKey: "subs_complete_order_onetime") as! String
                    let completeorderonetimeapiArr : [String] = completeorderonetimeapi.components(separatedBy: "|,")
                    LoginCredentials.Onetimecompleteorderapi = completeorderonetimeapiArr[1]
                    
                    
                    //////////////////////////////subs_complete_order_autorenewl   34   //////////////////////////
                    let completeorderautorenewlapi = Catdata_dict.value(forKey: "subs_complete_order_autorenewl") as! String
                    let completeorderautorenewlapiArr : [String] = completeorderautorenewlapi.components(separatedBy: "|,")
                    LoginCredentials.Completeorderapi = completeorderautorenewlapiArr[1]
                    
                    
                    
                    //////////////////////////////subs_package_list   34   //////////////////////////
                    let packagelistapi = Catdata_dict.value(forKey: "subs_package_list") as! String
                    let packagelistapiArr : [String] = packagelistapi.components(separatedBy: "|,")
                    LoginCredentials.Subscriptionpackageapi = packagelistapiArr[1]
                    
                    
                    
                    //////////////////////////////subs_user_subscriptions   34   //////////////////////////
                    let usersubscriptionsapi = Catdata_dict.value(forKey: "subs_user_subscriptions") as! String
                    let usersubscriptionsapiArr : [String] = usersubscriptionsapi.components(separatedBy: "|,")
                    LoginCredentials.Userpackagesapi = usersubscriptionsapiArr[1]
                    
                    
                    //////////////////////////////subs_free_subscription   34   //////////////////////////
                    let freesubscriptionapi = Catdata_dict.value(forKey: "subs_free_subscription") as! String
                    let freesubscriptionapiArr : [String] = freesubscriptionapi.components(separatedBy: "|,")
                    LoginCredentials.Freesubscriptionapi = freesubscriptionapiArr[1]
                    
                    
                    //////////////////////////////dvr_url   34   //////////////////////////
                    let Dvrurlapi = Catdata_dict.value(forKey: "dvr_url") as! String
                    let DvrurlapiArr : [String] = Dvrurlapi.components(separatedBy: "|,")
                    LoginCredentials.Dvrurl = DvrurlapiArr[1]
                    
                    
                    self.Refreshtoken(playerid: LoginCredentials.OnesinglePlayerid)
                    self.checkContantUpdate()
                    if(!self.Isdeeplinking)
                    {
                        self.createMenuView()
                    }
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            self.createMenuView()
        }
        
    }
    
    
    
    
    
    
    ///////Refreshtoken Update
    func Refreshtoken(playerid:String)
    {
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        let parameters = ["device_type":"app",
                          "device_unique_id": uuid,
                          "device_push_token":LoginCredentials.DiviceToken,
                          "one_signal_id":playerid
        ]
        print(parameters)
        let url = String(format: "%@%@", LoginCredentials.Udatedeviceapi,Apptoken)
        let manager = AFHTTPSessionManager()
        
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
    }
    
    
    //    ///////Verify user recive notification
    //    func Verifyuserrecivenotification(push_id:String)
    //    {
    //        if(Common.Islogin())
    //        {
    //            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
    //        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    //         let uuid = UIDevice.current.identifierForVendor!.uuidString
    //        var parameters = [String : Any]()
    //        parameters =    ["platform":"ios",
    //                          "device_id": uuid as String,
    //                           "push_id":push_id as String,
    //                          "user_id":dict.value(forKey: "id") as! String,
    //                          "app_version":(appversion! as String),
    //            "token":Apptoken]
    //         print(parameters)
    //         let url = String(format: "%@", LoginCredentials.Notificationveryfyurl)
    //            print(url)
    //        let manager = AFHTTPSessionManager()
    //
    //        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
    //            if (responseObject as? [String: AnyObject]) != nil {
    //                let dict = responseObject as! NSDictionary
    //                print(dict)
    //
    //            }
    //        }) { (task: URLSessionDataTask?, error: Error) in
    //            print("POST fails with error \(error)")
    //        }
    //
    //        }
    //    }
    //
    
    
    
    
    
    
    
    
    ///////Check Contant Update
    
    func checkContantUpdate()
    {
        
        let parameters = ["device":"ios"]
        print(parameters)
        let url = String(format: "%@%@/device/ios", LoginCredentials.AppVersionAPi,Apptoken)
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
                    
                    var Catdata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptAppVersionAPi)
                    {
                        Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    }
                    
                    
                    print(Catdata_dict)
                    
                    if((LoginCredentials.Contentversion == Catdata_dict.value(forKey: "content_version") as! String) && (LoginCredentials.Categoryversion == Catdata_dict.value(forKey: "category_version") as! String) && (LoginCredentials.Dashversion == Catdata_dict.value(forKey: "dash_version") as! String) && (LoginCredentials.Menuversion == Catdata_dict.value(forKey: "menu_version") as! String))
                    {
                        
                    }
                    else
                    {
                        
                        LoginCredentials.Contentversion = Catdata_dict.value(forKey: "content_version") as! String
                        LoginCredentials.Categoryversion = Catdata_dict.value(forKey: "category_version") as! String
                        LoginCredentials.Dashversion = Catdata_dict.value(forKey: "dash_version") as! String
                        LoginCredentials.Menuversion = Catdata_dict.value(forKey: "menu_version") as! String
                        self.deletealldatabase()
                        
                    }
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    
    
    
    func deletealldatabase()
    {
        
        
        dataBase.deletedataentity(entityname: "Sidemenudata")
        dataBase.deletedataentity(entityname: "Homedata")
        dataBase.deletedataentity(entityname: "Slidermenu")
        dataBase.deletedataentity(entityname: "Catlistdata")
    }
    
    
    
    
    
    
    /////appanalytics APi
    
    func appanalytics()
    {
        print("called for App analytics")
        let netInfo:CTTelephonyNetworkInfo=CTTelephonyNetworkInfo()
        let carrier = netInfo.subscriberCellularProvider
        let strDeviceName=UIDevice.current.model
        let strResolution=String(format: "%.f*%.f", self.window!.frame.size.width, (self.window?.frame.size.height)!)
        
        // Get carrier name
        let carrierName = carrier?.carrierName
        let systemVersion=UIDevice.current.systemVersion
        let appversion=Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        
        var Pushtoken  = String()
        
        if(!Common.isNotNull(object: UserDefaults.standard.value(forKey: "tokenID") as AnyObject?))
        {
            Pushtoken = ""
        }
        else
        {
            Pushtoken = UserDefaults.standard.value(forKey: "tokenID") as! String
        }
        
        
        var networkname =  String()
        
        if(!Common.isNotNull(object: carrier?.carrierName as AnyObject?))
        {
            networkname = ""
        }
        else
        {
            networkname = (carrier?.carrierName)! as String
        }
        
        
        print(Common.getnetworktype())
        
        
        let dictionaryOtherDetail: NSDictionary = [
            "os_version" : systemVersion,
            "network_type" : Common.getnetworktype(),
            "network_provider" : networkname,
            "app_version" : appversion!
        ]
        let devicedetailss: NSDictionary = [
            "make_model" : Common.getModelname(),
            "os" : "ios",
            "screen_resolution" : strResolution,
            "device_type" : "app",
            "platform" : "iOS",
            "device_unique_id" : UserDefaults.standard.value(forKey: "UUID") as! String,//token! as! String,
            "push_device_token" :  LoginCredentials.DiviceToken,
            "manufacturer":"Apple"
        ]
        var json = [String:Any]()
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            json = ["device":"ios","u_id":((dict.value(forKey: "id") as! NSNumber).stringValue),"c_id":LoginCredentials.Videoid ,"type": "2","buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Apptoken]
        }
        else
        {
            json = ["device":"ios","u_id":"","c_id":LoginCredentials.Videoid ,"type": "2","buff_d":"0","dod":Common.convertdictinyijasondata(data: dictionaryOtherDetail),"dd":Common.convertdictinyijasondata(data: devicedetailss),"pd":LoginCredentials.VideoPlayingtime,"token":Apptoken]
        }
        
        print("App analytics json >>",json)
        let url = String(format: "%@%@", LoginCredentials.Analyticsappapi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: json, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
   
    }

    func IapVerifyPaymentourserver()
    {
       let Param = LoginCredentials.LatestIapRecipt
        print(Param)
       if(Param.count<=0)
       {
         return
        }
        var url = String()
        url = String(format: "%@%@/device/ios",LoginCredentials.Onetimecompleteorderapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: Param, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                 let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                Common.Verifyfailedpayment()
                }
                else
                {
                LoginCredentials.Ispaymentfailedonsever = false
                self.getUsersubscriptiondetail()
                    
                }
                
             }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
             Common.Verifyfailedpayment()
         }
      }
    
    
    
    
    
    func getUsersubscriptiondetail() {
        if(Common.Islogin()) {
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
                                    else
                                    {
                                        LoginCredentials.Regiontype = ((LoginCredentials.UserSubscriptiondetail.object(at: 0) as! NSDictionary).value(forKey: "region_type") as! NSNumber).stringValue
                                        if(LoginCredentials.Regiontype == "2")
                                        {
                                            
                                        }
                                        else
                                        {
                                            LoginCredentials.CreateorderRegiontype = (LoginCredentials.UserSubscriptiondetail.object(at: 0) as! NSDictionary).value(forKey: "local_user") as! String
                                            
                                            var dict  =  [String:String]()
                                            dict = ["code":(LoginCredentials.UserSubscriptiondetail.object(at: 0) as! NSDictionary).value(forKey: "state_code") as! String]
                                            print(dict)
                                            LoginCredentials.SelectedUserCountry = dict as NSDictionary
                                            print(LoginCredentials.SelectedUserCountry)
                                            
                                        }
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
    
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url as URL!,
                                                                                                                                                                                                        sourceApplication: sourceApplication,
                                                                                                                                                                                                        annotation: annotation)
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        Common.stopHeartbeat()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.gckExpandedMediaControlsTriggered,
                                                  object: nil)
        Common.stopHeartbeat()
        self.saveContext()
    }
    
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return "" as AnyObject?
        } else {
            return value
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Dollywood_Play")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func setupCastLogging() {
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                            "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
    }
    
    
    func presentExpandedMediaControls() {
        print("present expanded media controls")
        // Segue directly to the ExpandedViewController.
        let navigationController: UINavigationController?
        if useCastContainerViewController {
            let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
            navigationController = (castContainerVC?.contentViewController as? UINavigationController)
        } else {
            let rootContainerVC = (window?.rootViewController as? ViewController)
            navigationController = rootContainerVC?.navigationController
        }
        // NOTE: Why aren't we just setting this to nil?
        navigationController?.navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let appDelegate = appDelegate, appDelegate.isCastControlBarsEnabled == true {
            appDelegate.isCastControlBarsEnabled = false
        }
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    
    
}



// MARK: - Working with default values
extension AppDelegate {
    
    func populateRegistrationDomain() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        var appDefaults = [String: Any]()
        if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            loadDefaults(&appDefaults, fromSettingsPage: "Root", inSettingsBundleAt: settingsBundleURL)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: appDefaults)
        userDefaults.setValue(appVersion, forKey: kPrefAppVersion)
        userDefaults.setValue(kGCKFrameworkVersion, forKey: kPrefSDKVersion)
        userDefaults.synchronize()
    }
    
    func loadDefaults(_ appDefaults: inout [String: Any], fromSettingsPage plistName: String,
                      inSettingsBundleAt settingsBundleURL: URL) {
        let plistFileName = plistName.appending(".plist")
        let settingsDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent(plistFileName))
        if let prefSpecifierArray = settingsDict?["PreferenceSpecifiers"] as? [[AnyHashable:Any]] {
            for prefItem in prefSpecifierArray {
                let prefItemType = prefItem["Type"] as? String
                let prefItemKey = prefItem["Key"] as? String
                let prefItemDefaultValue = prefItem["DefaultValue"] as? String
                if prefItemType == "PSChildPaneSpecifier" {
                    if let prefItemFile = prefItem["File"]  as? String {
                        loadDefaults(&appDefaults, fromSettingsPage: prefItemFile, inSettingsBundleAt: settingsBundleURL)
                    }
                } else if let prefItemKey = prefItemKey, let prefItemDefaultValue = prefItemDefaultValue {
                    appDefaults[prefItemKey] = prefItemDefaultValue
                }
            }
        }
    }
    
    func applicationIDFromUserDefaults() -> String? {
        let userDefaults = UserDefaults.standard
        var prefApplicationID = userDefaults.string(forKey: kPrefReceiverAppID)
        if prefApplicationID == kPrefCustomReceiverSelectedValue {
            prefApplicationID = userDefaults.string(forKey: kPrefCustomReceiverAppID)
        }
        if let prefApplicationID = prefApplicationID {
            let appIdRegex = try? NSRegularExpression(pattern: "\\b[0-9A-F]{8}\\b", options: [])
            let rangeToCheck = NSRange(location: 0, length: (prefApplicationID.characters.count))
            let numberOfMatches = appIdRegex?.numberOfMatches(in: prefApplicationID,
                                                              options: [],
                                                              range: rangeToCheck)
            if numberOfMatches == 0 {
                let message: String = "\"\(prefApplicationID)\" is not a valid application ID\n" +
                "Please fix the app settings (should be 8 hex digits, in CAPS)"
                showAlert(withTitle: "Invalid Receiver Application ID", message: message)
                return nil
            }
        } else {
            let message: String = "You don't seem to have an application ID.\n" +
            "Please fix the app settings."
            showAlert(withTitle: "Invalid Receiver Application ID", message: message)
            return nil
        }
        return prefApplicationID
    }
    
    func syncWithUserDefaults()
    {
        let userDefaults = UserDefaults.standard
        // Forcing no logging from the SDK
        enableSDKLogging = false
        let mediaNotificationsEnabled = userDefaults.bool(forKey: kPrefEnableMediaNotifications)
        GCKLogger.sharedInstance().delegate?.logMessage?("Notifications on? \(mediaNotificationsEnabled)",
            fromFunction: #function)
        if firstUserDefaultsSync || (self.mediaNotificationsEnabled != mediaNotificationsEnabled) {
            self.mediaNotificationsEnabled = mediaNotificationsEnabled
            if useCastContainerViewController {
                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = mediaNotificationsEnabled
            } else {
                let rootContainerVC = (window?.rootViewController as? ViewController)
                rootContainerVC?.miniMediaControlsViewEnabled = mediaNotificationsEnabled
                
            }
        }
        firstUserDefaultsSync = false
    }
}

// MARK: - GCKLoggerDelegate
extension AppDelegate: GCKLoggerDelegate {
    func logMessage(_ message: String, fromFunction function: String) {
        if enableSDKLogging {
            // Send SDK's log messages directly to the console.
            print("\(function)  \(message)")
        }
    }
    
}

// MARK: - GCKSessionManagerListener
extension AppDelegate: GCKSessionManagerListener {
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        if error == nil {
            if let view = window?.rootViewController?.view {
                Toast.displayMessage("Session ended", for: 3, in: view)
            }
        } else {
            let message = "Session ended unexpectedly:\n\(error?.localizedDescription ?? "")"
            showAlert(withTitle: "Session error", message: message)
        }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKSession, withError error: Error) {
        let message = "Failed to start session:\n\(error.localizedDescription)"
        showAlert(withTitle: "Session error", message: message)
    }
    
    func showAlert(withTitle title: String, message: String) {
        // TODO: Pull this out into a class that either shows an AlertVeiw or a AlertController
        let alert = UIAlertView(title: title, message: message,
                                delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
    
}

// MARK: - GCKUIImagePicker
extension AppDelegate: GCKUIImagePicker {
    func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        let images = metadata.images
        guard !images().isEmpty else { print("No images available in media metadata."); return nil }
        if images().count > 1 && imageHints.imageType == .background {
            return images()[1] as? GCKImage
        } else {
            return images()[0] as? GCKImage
        }
    }
}

