//
//  ViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 25/05/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import MBProgressHUD
import Kingfisher
import GoogleCast
import Sugar
let kCastControlBarsAnimationDuration: TimeInterval = 0.20




class ViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ImageCarouselViewDelegate,UITableViewDelegate,UITableViewDataSource,GCKUIMiniMediaControlsViewControllerDelegate {
    
    @IBOutlet weak var srollviewviewhgtconstrant: NSLayoutConstraint!
    @IBOutlet weak var myscrollview: UIScrollView!
    @IBOutlet weak var imageCarouselView: ImageCarouselView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var scrollXpos: CGFloat = 0.0
    var scrollYpos: CGFloat = 0.0
    
    var images: [UIImage]!
    var cellView: UIView?
    var genreName: UILabel?
    var uploadtimelabel: UILabel?
    var videoviewlabel: UILabel?
    var subgenreName: UILabel?
    var dummyLabel: UILabel?
    var cellImage: UIImageView?
    var cellbannerimageview: UIImageView?
    var cellheaderimageview: UIImageView?
    var cellheaderimageview1: UIImageView?
    var button: UIButton?
    var morebutton: UIButton?
    var homechannelheaderbutton: UIButton?
    var channelheaderheaderbutton: UIButton?
    var homebutton: UIButton?
    var dummyView: UIView?
    var Borderview: UIView?
    var timerview: UIView?
    var timelabel: UILabel?
    var playbutton: UIButton?
    var sectionValueBookIds = [Any]()
    var HomeData_dict:NSMutableDictionary = NSMutableDictionary()
    var sidemenudatadict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenulist_dict:NSMutableDictionary = NSMutableDictionary()
    var Slidermenusegment_dict:NSMutableDictionary = NSMutableDictionary()
    var Catdata_dict:NSMutableDictionary = NSMutableDictionary()
    var mXSegmentedPager = MXSegmentedPager()
    var nextbutton = UIButton()
    var slidermenuarray = NSMutableArray()
    var slidermenu_ids = [String]()
    var collectionviewarray = NSMutableArray()
    var otherviewarray = NSArray()
    var Ishomedata = Bool()
    var Iscliptv = Bool()
    var Ismoviepromo = Bool()
    var featurebanner = NSArray()
    var dummybutton: UIButton?
    
    @IBOutlet weak var activityindicater: UIActivityIndicatorView!
    @IBOutlet weak var Channel_view: UIView!
    @IBOutlet weak var OtherView: UIView!
    @IBOutlet weak var Othertableview: UITableView!
    @IBOutlet weak var Homeview: UIView!
    var channelarray = NSArray()
    var channeldatadict = NSMutableDictionary()
    var Ischannel = Bool()
    var flag = String()
    var display_offset = String()
    var Isscroolenable = Bool()
 
    
    @IBOutlet weak var Channel_collectionview: UICollectionView!
    @IBOutlet weak var OtherCollectionview: UICollectionView!
    
    
    private var miniMediaControlsViewController: GCKUIMiniMediaControlsViewController!
    
    var miniMediaControlsViewEnabled = false {
        didSet {
            if self.isViewLoaded {
                self.updateControlBarsVisibility()
            }
        }
    }
    
    
    
    //MARK:- View did Load
    override func viewDidLoad()
    {
        // myCollectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        super.viewDidLoad()
        LoginCredentials.UserSubscriptiondetail = NSArray()
        LoginCredentials.Allusersubscriptiondetail = NSDictionary()
        self.chekforceupgraorsoftupgrateapi()
        AppUtility.lockOrientation(.portrait)
        Isscroolenable = true
        Common.startloder(view: self.view)
        self.setupcollectionview()
        setupothercollectionview()
        activityindicater.hidesWhenStopped = true
        dataBase.deletedataentity(entityname: "Homedata")
        LoginCredentials.Display_offset_home = "0.0"
        LoginCredentials.Flag_Home = "0.0"
        flag = "0"
        display_offset = "0"
        Ishomedata = true
        self.getdatabaseresponse()
        
        
        //////GOOGLE CAST
        let castContext = GCKCastContext.sharedInstance()
        self.miniMediaControlsViewController = castContext.createMiniMediaControlsViewController()
        self.miniMediaControlsViewController.delegate = self
        self.updateControlBarsVisibility()
      
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        print("Scroll finished")
        if(Ishomedata)
        {
            self.activityindicater.isHidden = true
            if(Isscroolenable)
            {
                self.activityindicater.isHidden = false
                self.activityindicater.startAnimating()
                self.callhomedatawebapi()
                self.Isscroolenable = false
                
            }
        }
        
    }
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
      
        self.navigationController?.isNavigationBarHidden = true
        self.chekcUsersubscription()
        self.getUsersubscriptiondetail()
        NotificationCenter.default.addObserver(self, selector: #selector(clickcoresal), name: NSNotification.Name(rawValue: "clickoncoresal"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chekcUsersubscription), name: NSNotification.Name(rawValue: "checkusersubscription"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        //
        //
        //
        //         print("Before Crarsh")
        //
        //       if(!Common.isInternetAvailable())
        //       {
        //        let alert = UIAlertController(title: "", message: "No Internet connection, Please check your internet connection", preferredStyle: UIAlertControllerStyle.alert)
        //        // add an action (button)
        //        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { (alert) in
        //
        //            self.viewDidLoad()
        //        }))
        //        // show the alert
        //        self.present(alert, animated: true, completion: nil)
        //        }
        
        
        print("Before Crarsh")
        
    }
    
    
    
    
    func willResignActive(_ notification: Notification) {
        chekforceupgraorsoftupgrateapi()
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
                    if(number == 0)
                    {
                        print("Getting Error")
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
                        }
                    }
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                LoginCredentials.UserPakegeList = NSArray()
            }
        }
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
                        
                    }
                    
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                LoginCredentials.UserSubscriptiondetail = NSArray()
                LoginCredentials.Allusersubscriptiondetail = NSDictionary()
            }
        }
    }
    
    
    
    
    func chekforceupgraorsoftupgrateapi()
    {
        var url = String(format: "%@%@/device/ios", LoginCredentials.Versioncheckapi,Apptoken)
        url = url.trimmingCharacters(in: .whitespaces)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            let dict = responseObject as! NSDictionary
            print(dict)
            let resultCode = dict.object(forKey: "code") as! Int
            if resultCode == 1
            {
                let type = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "type") as! String
                let messege = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "message") as! String
                let apiversion = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "version") as! NSString
                let currentappvesrion = Bundle.main.releaseVersionNumber
                print(apiversion.floatValue)
                print(currentappvesrion!.floatValue)
                if(currentappvesrion!.floatValue<apiversion.floatValue)
                {
                    if(type == "soft")
                    {
                        self.softupdatealert(message: messege)
                    }
                    else if(type == "force")
                    {
                        self.forceupdatealert(message: messege)
                    }
                }
            }
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
        })
    }
    
    
    func softupdatealert(message:String)
    {
        let alert = UIAlertController(title: "YUV", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
            self.goToappstore()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func forceupdatealert(message:String)
    {
        let alert = UIAlertController(title: "YUV", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (action) in
            self.goToappstore()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToappstore()
    {
        UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/yuv/id1295744587?mt=8")! as URL)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    func getdatabaseresponse()
    {
        self.Slidermenulist_dict = NSMutableDictionary()
        self.slidermenuarray = NSMutableArray()
        dispatch(queue: .main) {
            self.sidemenudatadict = dataBase.getDatabaseresponseinentity(entityname: "Sidemenudata", key: "sidemenudatadict")
            self.HomeData_dict = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
            self.Slidermenulist_dict = dataBase.getDatabaseresponseinentity(entityname: "Slidermenu", key: "slidemenudict")
        }
        if(self.sidemenudatadict.count>0)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
        }
        else
        {
            self.getSidemenu()
        }
        
     
        
         self.callhomedatawebapi()
        
        
        
        
//        if(self.Slidermenulist_dict.count>0)
//        {
//
//
//            self.slidermenuarray.add("Home")
//
//            for i in 0..<(self.Slidermenulist_dict.value(forKey: "vod")  as! NSArray).count {
//                self.slidermenuarray.add((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
//                self.slidermenu_ids.append((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
//            }
//
//            print(self.slidermenuarray)
//            self.setmenu()
//        }
//        else
//        {
//            self.getslidermenudata()
//        }
//
//        if(self.HomeData_dict.count>0)
//        {
//            Homeview.isHidden = false
//            OtherView.isHidden = true
//            Channel_view.isHidden = true
//
//            Ischannel = false
//            Ishomedata = true
//            Iscliptv = false
//            Ismoviepromo = false
//            collectionviewarray = NSMutableArray()
//            self.collectionviewarray =  ((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).mutableCopy() as! NSMutableArray
//            ///set continue watching data
//            if(Common.Islogin())
//            {
//                let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
//
//                let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: ((dict.value(forKey: "id") as! NSNumber).stringValue)) as NSMutableArray
//                if(continuewatchingarray.count > 0)
//                {
//                    let dict = NSMutableDictionary()
//                    let continuewatchingmutablearray  = NSMutableArray()
//
//                    for i in 0..<continuewatchingarray.count {
//
//                        let array = continuewatchingarray.object(at: i) as! NSDictionary
//                        // array.setValue("Continue Watching", forKey: "cat_name")
//                        continuewatchingmutablearray.add(array)
//
//                    }
//
//                    dict.setValue(continuewatchingmutablearray, forKey: "cat_cntn")
//                    dict.setValue("Continue Watching", forKey: "cat_name")
//                    self.collectionviewarray.insert(dict, at: 0)
//
//                }
//            }
//            ///end continue watching data
//            self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
//            myscrollview.setContentOffset(CGPoint.zero, animated: true)
//            let collectionheight = self.collectionviewarray.count*80
//            srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 20.0
//            self.setimageincarouseview()
//            Common.stoploder(view: self.view)
//            self.myCollectionView.reloadData()
//
//        }
//        else
//        {
//            self.callhomedatawebapi()
//
//        }
//
        
    }
    
    
    //MARK:- SetUp Collection view
    func setupcollectionview()
    {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.alwaysBounceVertical = true
        myCollectionView.backgroundColor = UIColor.init(colorLiteralRed: 16.0/255, green: 16.0/255, blue: 16.0/255, alpha: 1.0)
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        UIGraphicsEndImageContext()
        navigationController?.navigationBar.barTintColor = UIColor.purple
    }
    
    
    
    func setupothercollectionview()
    {
        OtherCollectionview.dataSource = self
        OtherCollectionview.delegate = self
        OtherCollectionview.alwaysBounceVertical = true
        OtherCollectionview.backgroundColor = UIColor.init(colorLiteralRed: 16.0/255, green: 16.0/255, blue: 16.0/255, alpha: 1.0)
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        UIGraphicsEndImageContext()
        //view.backgroundColor = UIColor(patternImage: image!)
        navigationController?.navigationBar.barTintColor = UIColor.purple
    }
    
    
    //MARK:- Call Slidermenuapi
    func getslidermenudata()
    {
        Common.startloder(view: self.view)
        let parameters = [
            "device": "ios"
        ]
        var url = String(format: "%@%@/device/ios", LoginCredentials.catlistapi,Apptoken)
        print(url)
        url = url.trim()
        print(url)
        print(parameters)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                self.Slidermenulist_dict = NSMutableDictionary()
                self.slidermenuarray = NSMutableArray()
                if(LoginCredentials.Isencriptcatlistapi)
                {
                    self.Slidermenulist_dict = ((dict.value(forKey: "result") as! NSDictionary).value(forKey: "cat") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.Slidermenulist_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(self.Slidermenulist_dict)
                dataBase.Savedatainentity(entityname: "Slidermenu", key: "slidemenudict", data: self.Slidermenulist_dict)
                self.slidermenuarray.add("Home")
                for i in 0..<(self.Slidermenulist_dict.value(forKey: "vod")  as! NSArray).count {
                    self.slidermenuarray.add((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String))
                    if((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String) == "Shows")
                    {
                       LoginCredentials.Showlist = (self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as! NSDictionary
                    }
                  let dict = NSMutableDictionary()
                  let myarray =   (((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "children") as! NSArray).value(forKey: "children") as! NSArray).object(at: 0) as!  NSArray).mutableCopy() as! NSMutableArray
                  let name = (((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "name") as! String)
                    dict.setValue(myarray, forKey: "cat_cntn")
                    dict.setValue(name, forKey: "cat_name")
                    self.collectionviewarray.add(dict)
                     self.slidermenu_ids.append((((self.Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: i) as AnyObject).value(forKey: "id") as! String))
                }
                self.setcollectionviewheight()
                self.myCollectionView.reloadData()
               print(self.slidermenuarray)
                self.setmenu()
                // self.mXSegmentedPager.reloadData()
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)

        }
        
        
    }
    
    //MARK:- Call Home Data Api
    
    func callhomedatawebapi()
    {
        if(LoginCredentials.Display_offset_home == "")
        {
            LoginCredentials.Display_offset_home = "0"
            LoginCredentials.Flag_Home = "0"
        }

        let url = String(format: "%@%@/device/ios/display_offset/%@/display_limit/3/content_count/5", LoginCredentials.Homeapi,Apptoken,LoginCredentials.Display_offset_home)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                self.HomeData_dict.removeAllObjects()
                if(LoginCredentials.IsencriptHomeapi)
                {
                    self.HomeData_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.HomeData_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(self.HomeData_dict)
                
                if((self.display_offset == "0") && (self.flag == "0"))
                {
                    //  self.collectionviewarray.removeAllObjects()
                    //  dataBase.deletedataentity(entityname: "Homedata")
                    
                }
                var dictnew = NSMutableDictionary()
                dispatch(queue: .main) {
                    dictnew = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
                }
                if(dictnew.count>0)
                {
                    
                }
                else
                {
                    dataBase.Savedatainentity(entityname: "Homedata", key: "homedatadict", data:self.HomeData_dict)
                }
                
       
                if(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).count > 0)
                {
                    
                    
//                    for i in 0..<((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).count {
//
//                        if(self.collectionviewarray.contains((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray))
//                        {
//
//                        }
//                        else
//                        {
//                            self.collectionviewarray.add(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).object(at: i))
//                        }
//
//                    }
//
                    
                
                    
                    
                    ///set continue watching data
                    
                    if(Common.Islogin())
                    {
                        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                        
                        let continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
                        if(continuewatchingarray.count > 0)
                        {
                            let dict = NSMutableDictionary()
                            let continuewatchingmutablearray  = NSMutableArray()
                            
                            
                            for i in 0..<continuewatchingarray.count {
                                
                                let array = continuewatchingarray.object(at: i) as! NSDictionary
                                continuewatchingmutablearray.add(array)
                                
                            }
                            dict.setValue(continuewatchingmutablearray, forKey: "cat_cntn")
                            dict.setValue("Continue Watching", forKey: "cat_name")
                            // self.collectionviewarray.insert(dict, at: 0)
                            
                        }
                    }
                    ///end continue watching data
                    
                    
                    
                    
                    //////////////// set latest_content data ////////
                    
                    if let _ = ((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "latest_content"))
                    
                    {
                    let latestcontentarray = (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "latest_content") as! NSArray
                    if(latestcontentarray.count > 0)
                    {
                        let dict = NSMutableDictionary()
                        let latestcontentarraymutablearray  = NSMutableArray()
                        
                        
                        for i in 0..<latestcontentarray.count {
                            
                            let array = latestcontentarray.object(at: i) as! NSDictionary
                            latestcontentarraymutablearray.add(array)
                            
                        }
                        dict.setValue(latestcontentarraymutablearray, forKey: "cat_cntn")
                        dict.setValue("Latest Content", forKey: "cat_name")
                        self.collectionviewarray.add(dict)
                        
                        // self.collectionviewarray.insert(dict, at: 0)
                        
                    }
                }
                    
                    ////////////end another content/////////////////////
                    
                    
                    
            
                    //////////////// set trending_content data ////////
                    
                    if let _ = ((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "trending_content"))
                        
                    {
                        let trendingcontentarray = (self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "trending_content") as! NSArray
                        if(trendingcontentarray.count > 0)
                        {
                            let dict = NSMutableDictionary()
                            let trendingcontentarraymutablearray  = NSMutableArray()
                            
                            
                            for i in 0..<trendingcontentarray.count {
                                
                                let array = trendingcontentarray.object(at: i) as! NSDictionary
                                trendingcontentarraymutablearray.add(array)
                                
                            }
                            dict.setValue(trendingcontentarraymutablearray, forKey: "cat_cntn")
                            dict.setValue("Trending Content", forKey: "cat_name")
                            self.collectionviewarray.add(dict)
                          }
                    }
                    
                    ////////////end another content/////////////////////
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    // self.collectionviewarray.add(((self.HomeData_dict.value(forKey: "dashboard") as! NSDictionary).value(forKey: "home_category") as! NSArray).mutableCopy() as! NSMutableArray)
                    
                    
                    if(self.featurebanner.count<=0)
                    {
                        self.featurebanner =  (self.HomeData_dict.value(forKey: "dashboard") as!  NSDictionary).value(forKey: "feature_banner") as! NSArray
                        print(self.featurebanner)
                        self.setimageincarouseview()
                    }
                    
                    //  LoginCredentials.Flag_Home = self.HomeData_dict.value(forKey: "flag") as! String
                    LoginCredentials.Display_offset_home =  (self.HomeData_dict.value(forKey: "display_offset") as! NSNumber).stringValue
                    var collectionheight = Int()
                    
                    if(self.collectionviewarray.count<=3)
                    {
                        collectionheight = self.collectionviewarray.count*100
                    }
                    if(self.collectionviewarray.count>3)
                    {
                        collectionheight = self.collectionviewarray.count*180
                        
                    }
                    if(self.collectionviewarray.count>5)
                    {
                        collectionheight = self.collectionviewarray.count*200
                    }
                    if(self.collectionviewarray.count >= 6)
                    {
                        collectionheight = self.collectionviewarray.count*230
                        
                    }
                    
                    self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 20
                    
                    //  self.myscrollview.setContentOffset(CGPoint.zero, animated: true)
                    
                    Common.stoploder(view: self.view)
                     self.getslidermenudata()
                    self.Getchannel()
                    self.Isscroolenable = true
                    
                }
                else
                {
                    
                    self.activityindicater.isHidden = true
                    
                    //dataBase.Savedatainentity(entityname: "Homedata", key: "homedatadict", data:homedata_dictnew)
                }
                
                
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    func setcollectionviewheight() {
        var collectionheight = Int()
        
        if(self.collectionviewarray.count<=3)
        {
            collectionheight = self.collectionviewarray.count*100
        }
        if(self.collectionviewarray.count>3)
        {
            collectionheight = self.collectionviewarray.count*180
            
        }
        if(self.collectionviewarray.count>5)
        {
            collectionheight = self.collectionviewarray.count*200
        }
        if(self.collectionviewarray.count >= 6)
        {
            collectionheight = self.collectionviewarray.count*230
            
        }
        
        self.srollviewviewhgtconstrant.constant = CGFloat(collectionheight) + 20
    }
    
    
    
    //MARK:- Get Side Menu
    func getSidemenu()
    {
        let url = String(format: "%@%@/device/ios", LoginCredentials.MenuAPi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                if(LoginCredentials.IsencriptMenuAPi)
                {
                    self.sidemenudatadict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.sidemenudatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                dataBase.Savedatainentity(entityname: "Sidemenudata", key: "sidemenudatadict", data: self.sidemenudatadict)
                print(self.sidemenudatadict)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sidemenunotification"), object: self.sidemenudatadict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    //MARK:- Get catlistdata
    func Getcatlistdata(id:String)
    {
        let url = String(format: "%@%@/device/ios/cat_id/%@/max_counter/100", LoginCredentials.Listapi,Apptoken,id)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                print(Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String))
                
                if(LoginCredentials.IsencriptListapi)
                {
                    self.Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    self.Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                dataBase.Savecatlist(entityname: "Catlistdata", id: id, key: "catlistdatadict", data: self.Catdata_dict)
                self.otherviewarray = NSArray()
                self.otherviewarray = (self.Catdata_dict.value(forKey: "content") as! NSArray)
                self.OtherCollectionview.reloadData()
                Common.stoploder(view: self.view)
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    //MARK:-   Zonerbutton action
    @IBAction func TaptoZoner(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let zonerViewController = storyboard.instantiateViewController(withIdentifier: "ZonerViewController") as! ZonerViewController
        // let userintersetViewController = storyboard.instantiateViewController(withIdentifier: "UserintersetViewController") as! UserintersetViewController
        self.navigationController?.pushViewController(zonerViewController, animated: true)
        
        
    }
    
    
    
    
    //MARK:- UITableView delegate method
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.otherviewarray.count
        
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[0] as! Custometablecell
        cell.selectionStyle = .none
        Common.getRounduiview(view: cell.cellouterview, radius: 1.0)
        cell.cellouterview.layer.borderColor = UIColor.white.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        Common.getRoundLabel(label:  cell.timelabel, borderwidth: 5.0)
        Common.setlebelborderwidth(label: cell.timelabel, borderwidth: 1.0)
        cell.timelabel.layer.borderColor = UIColor.white.cgColor
        
        cell.titlelabel.text = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
        //        if Common.isNotNull(object: ((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
        //        {
        //            cell.titletypwlabel.text = ((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
        //        }
        //        else
        //        {
        //            cell.titletypwlabel.text = ""
        //        }
        var discriptiontext = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text = discriptiontext
        var url = ((((self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
        if(url == "")
        {
            cell.imageview.image = UIImage.init(named: "Placehoder1")
        }
        else
        {
            
            url = Common.getsplitnormalimageurl(url: url)
            cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder1"))
            
        }
        let videotime = (self.otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
        let time = dateFormatter.date(from: videotime!)
        dateFormatter.dateFormat = "HH:mm:ss"
        var coverttime = dateFormatter.string(from: time!)
        print(coverttime)
        let fullNameArr = coverttime.components(separatedBy: ":")
        if((fullNameArr[0] as String) == "00")
        {
            if((fullNameArr[1] as String) == "00")
            {
                coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) sec"
            }
            else
            {
                
                coverttime = "\(fullNameArr[1]):\(fullNameArr[2]) min"
            }
        }
        else
        {
            coverttime = "\(fullNameArr[0]):\(fullNameArr[1]) hr"
        }
        
        cell.timelabel.text = coverttime
        
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
        {
            let type = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
            print(type)
            if(!Common.Isvideolvodtype(type: type))
            {
                if(Common.Isvideolivetype(type: type))
                {
                    if(!Common.Islogin())
                    {
                        
                        Common.Showloginalert(view: self, text: "\((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                        return
                    }
                }
                else
                {
                    EZAlertController.alert(title: "\((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                    return
                }
                
            }
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.Video_url = ""
        
        if(Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
            playerViewController.descriptiontext = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
            playerViewController.descriptiontext = ""
        }
        playerViewController.liketext = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! String
        playerViewController.tilttext = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        
        playerViewController.fromdownload = "no"
        playerViewController.Download_dic = (otherviewarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if Common.isNotNull(object: (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
            
            playerViewController.downloadVideo_url = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
            
        }
        else
        {
            playerViewController.downloadVideo_url = ""
        }
        
        
        var ids = String()
        for i in 0..<((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
        {
            
            
            let str = ((otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
            ids = ids + str + ","
            
        }
        ids = ids.substring(to: ids.index(before: ids.endIndex))
        playerViewController.catid = ids
        playerViewController.cat_id = (otherviewarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
        {
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
    }
    
    
    //MARK:-   Collection view delegate method
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == myCollectionView
        {
            return collectionviewarray.count
        }
        else if(collectionView == OtherCollectionview)
        {
            if(Slidermenusegment_dict.count == 0)
            {
                return Slidermenusegment_dict.count
            }
            else
            {
                if Slidermenusegment_dict.value(forKey: "children") != nil
                {
                    return (Slidermenusegment_dict.value(forKey: "children") as! NSArray).count
                }
                else
                {
                    return 0
                }
                
            }
        }
        else
        {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == myCollectionView || collectionView == OtherCollectionview
        {
            return 1
        }
        else
        {
            return channelarray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myCollectionView
        {
            
            let cell: HomeCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell)
            for viewObject: UIView in (cell?.contentView.subviews)! {
                if (viewObject is UILabel) {
                    viewObject.removeFromSuperview()
                }
            }
            
            
            
            cellheaderimageview  = UIImageView(frame: CGRect(x: CGFloat(50), y: CGFloat(2), width: CGFloat(50), height: CGFloat(30)))
            Common.getRoundImage(imageView: cellheaderimageview!, radius: 8.0)
            Common.setuiimageviewdborderwidth(imageView: cellheaderimageview!, borderwidth: 1.0)
            if(Common.isNotNull(object: ((collectionviewarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "thumb") as AnyObject?)))
            {
                print(collectionviewarray.object(at: indexPath.section))
                
                let tumburl =  ((collectionviewarray.object(at: indexPath.section)) as AnyObject).value(forKey: "thumb") as? String
                // tumburl = Common.getsplitnormalimageurl(url: tumburl!)
                if(tumburl == "" )
                {
                    self.cellheaderimageview?.image = #imageLiteral(resourceName: "Placehoder1")
                }
                else
                {
                    self.cellheaderimageview?.setImageWith(URL(string: tumburl!)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                }
                
            }
            else
            {
                cellheaderimageview?.image = #imageLiteral(resourceName: "Placehoder1")
            }
            
            dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.20*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
            print(collectionviewarray.object(at: indexPath.section))
            dummyLabel?.text = ((collectionviewarray.object(at: indexPath.section)) as AnyObject).value(forKey: "cat_name") as? String
            dummyLabel?.textAlignment = .left
            dummyLabel?.textColor = UIColor.white
            dummyLabel?.numberOfLines = 0
            dummyLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
            dummyLabel?.adjustsFontSizeToFitWidth = true
            dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            homebutton = UIButton.init()
            homebutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            
           
            if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
            {
                morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width)-10, y: 8.0, width: 0.0, height: 0.0))
                morebutton?.setImage(nil, for: .normal)

            }
            else
            {
               morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width)-10, y: 8.0, width: 40.0, height: 20.0))
                 morebutton?.setImage(UIImage.init(named: "Homemore"), for: .normal)
            }
            homechannelheaderbutton = UIButton(frame: CGRect(x: 0, y: 8.0, width: self.view.frame.size.width/2, height: 40.0))
           
            morebutton?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            morebutton?.titleLabel?.textAlignment = .center
            morebutton?.tag = indexPath.section
            
            morebutton?.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
            morebutton?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
          //  homechannelheaderbutton?.addTarget(self, action: #selector(taptochannelpage), for: .touchUpInside)
            homechannelheaderbutton?.tag = indexPath.section
            dummybutton?.tag = indexPath.section
            homebutton?.tag = indexPath.section
            
            
            
            
           // cell?.contentView.addSubview(cellheaderimageview!)
            cell?.contentView.addSubview(dummyLabel!)
            cell?.contentView.addSubview(morebutton!)
            cell?.contentView.addSubview(dummybutton!)
            cell?.contentView.addSubview(homechannelheaderbutton!)
            
            if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
            {
            cell?.collectionScroll.contentSize = CGSize(width: CGFloat(((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count) * Int(self.view.frame.size.width/2)) + 100), height: CGFloat((cell?.frame.size.height)!))
            }
            else
            {
             cell?.collectionScroll.contentSize = CGSize(width: CGFloat(((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count) * Int(self.view.frame.size.width/3)) + 100), height: CGFloat((cell?.frame.size.height)!))
            }
            for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
            }
            scrollXpos = 0.12*CGFloat(view.frame.size.width)
            var continuewatchingarray = NSMutableArray()
            if(Common.Islogin())
            {
                let logindictnew = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                
                continuewatchingarray = dataBase.getcontinuewatchingfromdatabase(userid: (logindictnew.value(forKey: "id") as! NSNumber).stringValue) as NSMutableArray
            }
            else
            {
                
            }
            
            
            if(dummyLabel?.text == "Continue Watching")
            {
                morebutton?.isHidden = true
            }
            else
            {
                morebutton?.isHidden = false
                
            }
            
            
            
            for i in 0..<((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).count
            {
                print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i))
                
               
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                    
                cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(self.view.frame.size.width/2-10), height: CGFloat(150)))
                }
                else
                {
                    cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(self.view.frame.size.width/3-10), height: CGFloat(150)))
                }
                
          
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                    
                scrollXpos += self.view.frame.size.width/2-10
                }
                else
                {
                  scrollXpos += self.view.frame.size.width/3-10
                }
                cell?.collectionScroll.addSubview(cellView!)
                
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(140)))
                }
                else
                {
                   dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-15), height: CGFloat(140)))
                }
                dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
                button = UIButton(type: .custom)
                button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button?.tag = i
                button?.setTitle("", for: .normal)
               
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                
                cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(100)))
                  button?.frame = CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(140))
                }
                else
                {
 
                    cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-15), height: CGFloat(155)))
                    button?.frame = CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-15), height: CGFloat(140))
                }
                
                
              
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                    
                 if((((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.count) == 0)
                {
                    cellImage?.image = UIImage.init(named: "Placeholder1")
                }
                else
                {
                    if(Common.isNotNull(object: ((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as AnyObject)))
                    {
                        var str  = (((((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbs") as? NSArray)?.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String)
                     
                        
                        str = Common.getsplitnormalimageurl(url: str)
                         self.cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                    }
                    else
                    {
                        cellImage?.image = UIImage.init(named: "Placeholder1")
                        
                    }
                    
                    
                    
                }
            }
                else
                {
                    
                    Common.setuiimageviewdborderwidth(imageView: cellImage!, borderwidth: 1.0)

                    if(Common.isNotNull(object: ((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbnails") as AnyObject)))
                    {
                        var thumbnailsarray  = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "thumbnails") as? NSArray
                        
                        if(thumbnailsarray?.count == 0)
                        {
                            cellImage?.image = UIImage.init(named: "Placeholder1")
                        }
                        else
                        {
                            //tumburl = Common.getsplitnormalimageurl(url: tumburl)
                            
                            let str  = thumbnailsarray?.object(at: 0) as! String
                            if(Common.isEmptyOrWhitespace(testStr: str))
                            {
                            self.cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder1"))
                            }
                            else
                            {
                                cellImage?.image = UIImage.init(named: "Placeholder1")

                            }
                        }
                    }
                    
                }
                
                playbutton = UIButton(frame: CGRect(x: 5, y: (cellImage?.frame.maxY)!+10, width: 20, height: 20))
                playbutton?.setImage(UIImage.init(named: "play"), for: .normal)
                cellbannerimageview = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat((cellImage?.frame.maxY)!), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat(50)))
                cellbannerimageview?.image = UIImage.init(named: "cellbottom")
                genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + 5), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(20)))
                subgenreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + (genreName?.frame.size.height)! + 5), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
                
                genreName?.text = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "title") as? String
                let subgenreNametext = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "des") as? String
                
                if(Common.isNotNull(object: subgenreNametext as AnyObject?))
                {
                    subgenreName?.text = Common.trimstring(text: subgenreNametext!)
                }
                else
                {
                    subgenreName?.text = ""
                }
                genreName?.textColor = UIColor.white
                genreName?.numberOfLines = 1
                genreName?.font = UIFont(name: "HelveticaNeue", size: CGFloat(13))
                subgenreName?.textColor = Discriptioncolor
                subgenreName?.numberOfLines = 1
                subgenreName?.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
                
                
                videoviewlabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((subgenreName?.frame.origin.y)! + (subgenreName?.frame.size.height)! + 2), width: CGFloat((cellImage?.frame.size.width)! - 30), height: CGFloat(10)))
                uploadtimelabel = UILabel(frame: CGRect(x: CGFloat((cellImage?.frame.size.width)! - 50), y: CGFloat(((videoviewlabel?.frame.origin.y)!)), width: CGFloat(50), height: CGFloat(10)))
                uploadtimelabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(8))
                videoviewlabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(8))
                uploadtimelabel?.textColor = Discriptioncolor
                videoviewlabel?.textColor = Discriptioncolor
                uploadtimelabel?.textAlignment = .left
                
                
                if(Common.isNotNull(object: ((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject?)))
                {
                    
                    
                    
                    
                    if(Common.isNotNull(object: (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "created") as AnyObject?))
                    {
                        let videotime = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "created") as! String
                        
                        uploadtimelabel?.text = "\(self.compatedate(date: videotime))"
                    }
                    else
                    {
                        uploadtimelabel?.text = ""
                    }
                }
                else
                {
                    uploadtimelabel?.text = ""
                }
                
                
                
                if let _ = (((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "watch") {
                videoviewlabel?.text =  "\((((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at: indexPath.section) as AnyObject).object(at: i) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
                }
                else
                {
                    videoviewlabel?.text = ""
                }
                
                Borderview = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/2-15), height: CGFloat((cellImage?.frame.maxY)!)+10))
                if(dummyLabel?.text == "Latest Content" || dummyLabel?.text == "Trending Content" )
                {
                Common.setuiviewdborderwidth(View: Borderview!, borderwidth: 0.5)
                }
                
                cellView?.addSubview(cellbannerimageview!)
                cellView?.addSubview(cellImage!)
                cellView?.addSubview(genreName!)
                cellView?.addSubview(subgenreName!)
                cellView?.addSubview(dummyView!)
                cellView?.addSubview(uploadtimelabel!)
                cellView?.addSubview(videoviewlabel!)
                cellView?.addSubview(Borderview!)
                cellView?.addSubview(button!)
                //cellView?.addSubview(playbutton!)
                cell?.contentView.addSubview(homebutton!)
                
                
            }
            
            return cell!
            
        }
            
        else if(collectionView == OtherCollectionview)
        {
            
            
            let cell: HomeCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell)
            for viewObject: UIView in (cell?.contentView.subviews)! {
                if (viewObject is UILabel) {
                    viewObject.removeFromSuperview()
                }
            }
            
            cellheaderimageview1  = UIImageView(frame: CGRect(x: CGFloat(50), y: CGFloat(3), width: CGFloat(50), height: CGFloat(0)))
            Common.getRoundImage(imageView: cellheaderimageview1!, radius: 8.0)
            
            if(Common.isNotNull(object: ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "thumbnails")) as? NSArray)?.object(at: 0) as AnyObject?))
            {
                var tumburl =  ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "thumbnails")) as? NSArray)?.object(at: 0) as! String
                if(tumburl == "")
                {
                    // cellheaderimageview1?.image = nil
                }
                else
                {
                    //tumburl = Common.getsplitnormalimageurl(url: tumburl)
                    self.cellheaderimageview1?.setImageWith(URL(string: tumburl)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
            }
            
            
            dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.35*CGFloat(view.frame.size.width)), y: CGFloat(5), width: CGFloat(view.frame.size.width), height: CGFloat(0)))
            dummyLabel?.text = ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "name")) as? String)
            dummyLabel?.textAlignment = .left
            dummyLabel?.textColor = UIColor.white
            dummyLabel?.numberOfLines = 0
            dummyLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
            dummyLabel?.adjustsFontSizeToFitWidth = true
            
            
            morebutton = UIButton(frame: CGRect(x: CGFloat(view.frame.size.width), y: 8.0, width: 20.0, height: 15.0))
            morebutton?.setImage(UIImage.init(named: "Homemore"), for: .normal)
            morebutton?.tag = indexPath.section
            morebutton?.addTarget(self, action: #selector(taptomore), for: .touchUpInside)
            dummybutton = UIButton(frame: CGRect(x: 0, y: 0.0, width: 0, height: 0))
            dummybutton?.tag = indexPath.section
            
            
            channelheaderheaderbutton = UIButton(frame: CGRect(x: 0, y: 8.0, width: self.view.frame.size.width/2, height: 40.0))
            channelheaderheaderbutton?.addTarget(self, action: #selector(taptochannelheaderanother), for: .touchUpInside)
            channelheaderheaderbutton?.tag = indexPath.section
            cell?.contentView.addSubview(cellheaderimageview1!)
            cell?.contentView.addSubview(dummyLabel!)
            cell?.contentView.addSubview(channelheaderheaderbutton!)
            // cell?.contentView.addSubview(morebutton!)
            scrollXpos = 0.12*CGFloat(view.frame.size.width)
            scrollYpos = -30
            
            // let stt = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "id") as! String)
            let dataarray = NSMutableArray()
            otherviewarray = ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "children") as! NSArray
            for i in 0..<otherviewarray.count
            {
                
                dataarray.add(otherviewarray.object(at: i) as! NSDictionary)
                
            }
            
            
            cell?.collectionScroll.contentSize = CGSize(width: CGFloat(self.view.frame.size.width) , height:CGFloat(((dataarray.count * Int(self.view.frame.size.width/3)) + 100))/3)
            
            
            for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
            }
            
            
            
            
            for i in 0..<dataarray.count
            {
                
                if(scrollXpos >= self.view.frame.size.width)
                {
                    scrollXpos = 0.12*CGFloat(view.frame.size.width)
                    scrollYpos = scrollYpos + (self.view.frame.size.height/3)-40
                }
                
                
                cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(scrollYpos), width: CGFloat(self.view.frame.size.width/3-6), height: (self.view.frame.size.height/3)-50))
                
                
                if(scrollXpos >= self.view.frame.size.width)
                {
                    scrollXpos = 0.12*CGFloat(view.frame.size.width)
                    scrollYpos = scrollYpos + (self.view.frame.size.height/3)-40
                }
                else
                {
                    scrollXpos += self.view.frame.size.width/3
                    
                }
                
                
                cell?.collectionScroll.addSubview(cellView!)
                dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-6), height: (self.view.frame.size.height/3)-60))
                dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
                button = UIButton(type: .custom)
                button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button?.tag = i
                button?.setTitle("", for: .normal)
                
                button?.frame = CGRect(x: CGFloat(5), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-6), height: (self.view.frame.size.height/3)-50)
                cellImage = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(40), width: CGFloat(self.view.frame.size.width/3-6), height: (self.view.frame.size.height/3)-50))
                
                var str = String()
                
                Common.setuiimageviewdborderwidth(imageView: cellImage!, borderwidth: 1.0)
                
                let arra = ((dataarray.object(at: i) as! NSDictionary).value(forKey: "banners")) as! NSArray
                if(arra.count>0)
                {
                    str = arra.object(at: 0) as! String
                }
                else
                {
                    str = ""
                }
                
                
                if(!Common.isNotNull(object: str as AnyObject?))
                {
                    str = ""
                }
                print(str)
                if(str == "")
                {
                    cellImage?.image = #imageLiteral(resourceName: "Placehoder")
                }
                else
                {
                    //str = Common.getsplitnormalimageurl(url: str)
                    self.cellImage?.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
                
                
                cellView?.addSubview(button!)
                cellView?.addSubview(cellImage!)
                cellView?.addSubview(dummyView!)
            }
            return cell!
            
            
        }
        else
        {
            
            let cellchnl: ChannelCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "cellchnl", for: indexPath) as? ChannelCollectionViewCell)
            cellchnl?.layer.borderWidth = 0.5
            cellchnl?.layer.borderColor = UIColor.white.cgColor
            cellchnl?.clipsToBounds = true
            cellchnl?.chaneelname.text =  "\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "first_name") as! String)\(" ")\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "last_name") as! String)"
            let str = "\(channeldatadict.value(forKey: "banner_page") as! String)\((channelarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "channel_pic") as! String)"
            print(str)
            // str = Common.getsplitnormalimageurl(url: str)
            cellchnl?.chenelimageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
            
            return cellchnl!
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
//        if Ischannel {
//
//
//            if(!Common.isInternetAvailable())
//            {
//                EZAlertController.alert(title: "Internet is not avilabel")
//                return
//            }
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
//            channeldetailViewController.chanldict = channelarray.object(at: indexPath.row) as! NSDictionary
//            print( channelarray.object(at: indexPath.row) as! NSDictionary)
//            self.navigationController?.pushViewController(channeldetailViewController, animated: true)
//
//        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if Iscliptv
        {
            
            let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(170))
            return retval
        }
        else if(Ischannel)
        {
            return CGSize(width: self.view.frame.size.width/3-4, height:(self.view.frame.size.height/3)-50)
        }
        else
        {
            if(Ishomedata)
            {
                let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(200))
                return retval
            }
            else
            {
                
                let dataarray = NSMutableArray()
                var otherviewarray1 = NSArray()
                
                otherviewarray1 = ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: indexPath.section) as! NSDictionary).value(forKey: "children") as! NSArray
                
                
                for i in 0..<otherviewarray1.count
                {
                    
                    dataarray.add(otherviewarray1.object(at: i) as! NSDictionary)
                    
                }
                
                if(dataarray.count>9)
                {
                    let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(((dataarray.count * Int((self.view.frame.size.height/3)-50)) + 650))/3)
                    return retval
                }
                
                if(dataarray.count>6)
                {
                    let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(((dataarray.count * Int((self.view.frame.size.height/3)-50)) + 650))/3)
                    return retval
                }
                else if(dataarray.count>3)
                {
                    let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(((dataarray.count * Int((self.view.frame.size.height/3)-50)) + 550))/3)
                    return retval
                }
                else
                {
                    let retval = CGSize(width: CGFloat(view.frame.size.width+70), height: CGFloat(((dataarray.count * Int((self.view.frame.size.height/3)-50)) + 400))/3)
                    return retval
                }
                
                
            }
            
        }
    }
    
    
    
    
    
    
    @IBAction func Taptosearch(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    
    func taptochannelheaderanother(sender: UIButton!)
    {
//        print(Slidermenusegment_dict)
//        print((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (sender?.tag)!) as! NSDictionary)
//        let dict = ["id":((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "partner_id") as! String] as NSDictionary
//        print(dict)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
//        channeldetailViewController.chanldict = dict
//        self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        
    }
    
    
    func taptochannelpage(sender: UIButton!)
    {
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        
        print(collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary)
        if(((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String) == "Latest Uploads")
        {
            return
        }
        let dict = ["id":(collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "partner_id") as! String] as NSDictionary
        print(dict)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
        channeldetailViewController.chanldict = dict
        self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        
    }
    
    
    
    
    func taptomore(sender: UIButton!)
    {
        
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        
        if(Ishomedata)
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            print(collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary)
            let catname = (collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String
            let index = (sender?.tag)! - 1
            
            
            
            for i in 0..<mXSegmentedPager.segmentedControl.sectionTitles.count
            {
                let seletename =  mXSegmentedPager.segmentedControl.sectionTitles[i] as! String
                print(seletename)
               if(catname == seletename)
               {
                mXSegmentedPager.pager.showPage(at:i, animated: true)
                return
                }
                
            }
            
            
            
//            print(index)
//
//            if(index == 1)
//            {
//                 mXSegmentedPager.pager.showPage(at:1, animated: true)
//
//               }
//            else if(index == 2)
//            {
//              mXSegmentedPager.pager.showPage(at:2, animated: true)
//            }
//            else if(index == 3)
//            {
//                mXSegmentedPager.pager.showPage(at:3, animated: true)
//
//
//
//            }
//
//            else if(index == 4)
//            {
//                mXSegmentedPager.pager.showPage(at:4, animated: true)
//
//            }
//
//            else if(index == 5)
//            {
//                mXSegmentedPager.pager.showPage(at:5, animated: true)
//
//
//             }
//
//            else if(index == 6)
//            {
//                mXSegmentedPager.pager.showPage(at:6, animated: true)
//            }
//            else if(index == 7)
//            {
//                mXSegmentedPager.pager.showPage(at:7, animated: true)
//
//            }
//
  
            
//
//            moreViewController.id = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_id") as! String)
//            moreViewController.moreorzoner = "more"
//            moreViewController.Isfromhome = true
//            moreViewController.headertext = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "cat_name") as! String)
//            self.navigationController?.pushViewController(moreViewController, animated: true)
        }
        else
        {
            print((sender?.tag)! as Int)
            print((morebutton?.tag)! as Int)
            print ((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary)
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            print((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String))
            moreViewController.id = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "id") as! String)
            moreViewController.moreorzoner = "more"
            
            moreViewController.headertext = (((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at:sender.tag) as! NSDictionary).value(forKey: "name") as! String)
            moreViewController.headerimageurl = ((collectionviewarray.object(at: (sender?.tag)!) as! NSDictionary).value(forKey: "thumb") as! String)
            
            self.navigationController?.pushViewController(moreViewController, animated: true)
            
        }
        
        
        
    }
    
    
    func buttonAction(sender: UIButton!) {
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        if(Ishomedata)
        {
            let point : CGPoint = sender.convert(CGPoint.zero, to:myCollectionView)
            var indexPath = myCollectionView!.indexPathForItem(at: point)
            print((homebutton?.tag)! as Int)
            print((morebutton?.tag)! as Int)
            let ds = (indexPath?.section)! as Int
            print(ds)
            print(collectionviewarray.object(at:ds) as AnyObject)
            print(((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag))
            
            let dic = ((collectionviewarray.value(forKey: "cat_cntn") as! NSArray).object(at:ds) as AnyObject).object(at: sender.tag) as! NSDictionary
            
            if((collectionviewarray.object(at: ds) as! NSDictionary).value(forKey: "cat_name") as! String == "Latest Content"  || (collectionviewarray.object(at: ds) as! NSDictionary).value(forKey: "cat_name") as! String == "Trending Content" )
            {
                
        
                if(Common.isNotNull(object: dic.value(forKey: "status") as AnyObject?))
                {
                    let type = dic.value(forKey: "status") as! String
                    print(type)
                    if(!Common.Isvideolvodtype(type: type))
                    {
                        if(Common.Isvideolivetype(type: type))
                        {
                            if(!Common.Islogin())
                            {
                                
                                Common.Showloginalert(view: self, text: "\(dic.value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                                
                                return
                            }
                        }
                        else
                        {
                            
                            EZAlertController.alert(title: "\(dic.value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                            
                            return
                        }
                        
                    }
                }
                
                
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                playerViewController.Video_url = ""
                if(Common.isNotNull(object: dic.value(forKey: "des") as AnyObject?))
                {
                    
                    playerViewController.descriptiontext = dic.value(forKey: "des") as! String
                    
                }
                else
                {
                    playerViewController.descriptiontext = ""
                    
                }
                playerViewController.liketext = dic.value(forKey: "likes_count") as! String
                
                
                
                playerViewController.fromdownload = "no"
                playerViewController.Download_dic = dic.mutableCopy() as! NSMutableDictionary
                
                if Common.isNotNull(object: dic.value(forKey: "download_path") as AnyObject?) {
                    
                    playerViewController.downloadVideo_url = dic.value(forKey: "download_path") as! String
                    
                }
                else
                {
                    playerViewController.downloadVideo_url = ""
                }
                playerViewController.tilttext = dic.value(forKey: "title") as! String
                playerViewController.catid = dic.value(forKey: "category_id") as! String
                playerViewController.cat_id = dic.value(forKey: "id") as! String
                
                if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
                {
                    self.navigationController?.pushViewController(playerViewController, animated: true)
                }
                
            }
            else
            {
                
                let point : CGPoint = sender.convert(CGPoint.zero, to:myCollectionView)
                var indexPath = myCollectionView!.indexPathForItem(at: point)
                print((indexPath?.section)! as Int)
                
             
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
                moreViewController.id = dic.value(forKey: "id") as! String
                moreViewController.moreorzoner = "more"
                moreViewController.headertext = dic.value(forKey: "name") as! String
                moreViewController.headerimageurl = (dic.value(forKey: "thumbnails") as! NSArray).object(at: 0) as! String
                self.navigationController?.pushViewController(moreViewController, animated: true)
                
                
              //self.callotherhomeaction(sender: sender)
            }
        }
            
        else
        {
            let point : CGPoint = sender.convert(CGPoint.zero, to:OtherCollectionview)
            var indexPath = OtherCollectionview!.indexPathForItem(at: point)
            print((indexPath?.section)! as Int)
            
            print(((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (indexPath?.section)!) as! NSDictionary).value(forKey: "children")) as? NSArray)?.object(at: sender.tag) as! NSDictionary)
            
            let dictnew  = ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (indexPath?.section)!) as! NSDictionary).value(forKey: "children")) as? NSArray)?.object(at: sender.tag) as! NSDictionary
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            moreViewController.id = dictnew.value(forKey: "id") as! String
            moreViewController.moreorzoner = "more"
            moreViewController.headertext = dictnew.value(forKey: "name") as! String
            moreViewController.headerimageurl = (dictnew.value(forKey: "thumbnails") as! NSArray).object(at: 0) as! String
            self.navigationController?.pushViewController(moreViewController, animated: true)
     
            
        }
    }
    
    
    
    func callotherhomeaction(sender:UIButton) {
        let point : CGPoint = sender.convert(CGPoint.zero, to:myCollectionView)
        var indexPath = myCollectionView!.indexPathForItem(at: point)
        print((indexPath?.section)! as Int)
        
        print(((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (indexPath?.section)!) as! NSDictionary).value(forKey: "children")) as? NSArray)?.object(at: sender.tag) as! NSDictionary)
        
        let dictnew  = ((((Slidermenusegment_dict.value(forKey: "children") as! NSArray).object(at: (indexPath?.section)!) as! NSDictionary).value(forKey: "children")) as? NSArray)?.object(at: sender.tag) as! NSDictionary
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreViewController.id = dictnew.value(forKey: "id") as! String
        moreViewController.moreorzoner = "more"
        moreViewController.headertext = dictnew.value(forKey: "name") as! String
        moreViewController.headerimageurl = (dictnew.value(forKey: "thumbnails") as! NSArray).object(at: 0) as! String
        self.navigationController?.pushViewController(moreViewController, animated: true)
    }
    
    
    //MARK:- Init Slider menu
    func setmenu()
    {
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: 65, width: self.view.frame.size.width-40, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        
        nextbutton  = UIButton.init(frame: CGRect.init(x: mXSegmentedPager.frame.size.width+10, y: 78, width: 25, height: 15))
        
        nextbutton.setImage(#imageLiteral(resourceName: "segmentforwaord"), for: .normal)
        nextbutton.imageView?.contentMode = .scaleAspectFit
        nextbutton.addTarget(self, action: #selector(taptosetnextsegment), for: .touchUpInside)
        mXSegmentedPager.segmentedControl.segmentWidthStyle = .dynamic
        mXSegmentedPager.segmentedControl.backgroundColor = UIColor.black
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.white
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(colorLiteralRed: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)]
        mXSegmentedPager.segmentedControl.segmentWidthStyle = .dynamic
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 110.0/255, green: 110.0/255, blue: 110.0/255, alpha: 1.0), NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 18.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.view.addSubview(mXSegmentedPager)
        self.view.addSubview(nextbutton)
        
    }
    
    
    func taptosetnextsegment(sender:UIButton)
    {
 
        if(sender.imageView?.image == #imageLiteral(resourceName: "segmentforwaord"))
        {
            mXSegmentedPager.pager.showPage(at: slidermenuarray.count-1, animated: true)
        }
        else
        {
            mXSegmentedPager.pager.showPage(at: 0, animated: true)
        }
        
        if(mXSegmentedPager.segmentedControl.selectedSegmentIndex==0)
        {
            sender.setImage(#imageLiteral(resourceName: "segmentforwaord"), for: .normal)
        }
            
        else if(mXSegmentedPager.segmentedControl.selectedSegmentIndex == slidermenuarray.count-1)
        {
            sender.setImage(#imageLiteral(resourceName: "segmentbackwaord"), for: .normal)
        }
        
        
        
        
        
        
    }
    
    
    
    //MARK:-   Slidermenu delegate method
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return slidermenuarray.count
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        
        return slidermenuarray.object(at: index) as! String
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        let label = UILabel()
        //label.text! = "Page #\(index)"
        // label.textAlignment = .Center
        //label.text = "Ashish"
        return label
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, willDisplayPage page: UIView, at index: Int) {
        print("ENd")
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        print("ENd")
        
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didEndDisplayingPage page: UIView, at index: Int) {
        print("ENd")
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didEndDraggingWith parallaxHeader: MXParallaxHeader) {
        print("ENd")
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        
        
        
        if(mXSegmentedPager.segmentedControl.selectedSegmentIndex==0)
        {
            nextbutton.setImage(#imageLiteral(resourceName: "segmentforwaord"), for: .normal)
        }
            
        else if(mXSegmentedPager.segmentedControl.selectedSegmentIndex == slidermenuarray.count-1)
        {
            nextbutton.setImage(#imageLiteral(resourceName: "segmentbackwaord"), for: .normal)
        }
   
        
        if(index == 0)
        {
            
            Homeview.isHidden = false
            OtherView.isHidden = true
            Channel_view.isHidden = true
            Ischannel = false
            Ishomedata = true
            Iscliptv = false
            Ismoviepromo = false
            //LoginCredentials.Display_offset_home = ""
           // self.featurebanner = NSArray()
            //self.HomeData_dict = dataBase.getDatabaseresponseinentity(entityname: "Homedata", key: "homedatadict")
          //  self.collectionviewarray.removeAllObjects()
            //callhomedatawebapi()
            //dataBase.deletedataentity(entityname: "Homedata")
            //  getdatabaseresponse()
            
            
            
        }
            
 
        else
        {
            
        
            
            
            Channel_view.isHidden = true
            Homeview.isHidden = true
            OtherView.isHidden = false
            Ishomedata = false
            Ischannel = false
            Iscliptv = false
            Ismoviepromo = false
            
            
            print(Slidermenulist_dict)
            Slidermenusegment_dict = ((Slidermenulist_dict.value(forKey: "vod") as! NSArray).object(at: index-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            print(Slidermenusegment_dict)
            self.OtherCollectionview.reloadData()
        }
        
        
        if(Ishomedata)
        {
            srollviewviewhgtconstrant.constant =  myCollectionView.collectionViewLayout.collectionViewContentSize.height-150
            myscrollview.setContentOffset(CGPoint.zero, animated: false)
        }
        else if(Ischannel)
        {
            srollviewviewhgtconstrant.constant = Channel_collectionview.collectionViewLayout.collectionViewContentSize.height-250
            self.Channel_view.frame.origin.y = 0.0
            myscrollview.setContentOffset(CGPoint.zero, animated: false)
        }
        else
        {
            srollviewviewhgtconstrant.constant = OtherCollectionview.collectionViewLayout.collectionViewContentSize.height-300
            self.OtherView.frame.origin.y = 0.0
            myscrollview.setContentOffset(CGPoint.zero, animated: false)
        }
        
        
        
        // myscrollview.scrollRectToVisible(CGRect(x: 0, y: 106, width: myscrollview.frame.size.width, height: myscrollview.frame.size.height), animated: true)
        //myscrollview.setContentOffset(CGPoint(x: 0, y: 106), animated: true)
        
        //myscrollview.setContentOffset(CGPoint.zero, animated: false)
        
        
        
        
    }
    
    
    
    //MARK:- Get channel
    
    func Getchannel()
    {
        
        
        let url = String(format: "%@%@", LoginCredentials.Channellistapi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                let dict = responseObject as! NSDictionary
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                var chaneeldata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptListapi)
                {
                    chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(chaneeldata_dict)
                
                dataBase.SaveChanneldata(data: chaneeldata_dict)
                
                
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }
    
    
    
    
    //MARK:- SetUp CarouselView
    
    
    func setimageincarouseview()
    {
        let arry = NSMutableArray()
        let arry1 = NSMutableArray()
        let arry2 = NSMutableArray()
        let arry3 = NSMutableArray()
        let arry4 = NSMutableArray()
        print(featurebanner)
        for i in 0..<featurebanner.count
        {
            var url = URL(string: "")
            
            if (Common.isNotNull(object: (featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
                if(((featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray).count>0)
                {
                    var str = (((((featurebanner.object(at: i) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium")) as! String
                    str = Common.getsplitbannerimageurl(url: str)
                    url = URL(string:  str)
                }
            }
            let status = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "status") as! String
            
            
            var text1 = String()
            var text2 = String()
            var text3 = String()
            
            if(Common.isNotNull(object: (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type")  as AnyObject?))
            {
                let type = (featurebanner.object(at: i) as! NSDictionary).value(forKey: "type") as! String
                if(type == "series")
                {
                    
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")  as AnyObject?)))
                    {
                        text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "series_type")   as! String)
                    }
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")  as AnyObject?)))
                    {
                        text2 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "category")   as! String)
                    }
                    
                    if(Common.isNotNull(object: ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")  as AnyObject?)))
                    {
                        text3 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "episode_number")   as! String)
                    }
                    else
                    {
                        text3 = "0"
                    }
                    
                    
                }
                else
                {
                    
                    text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                    text2 = ""
                }
                
                
            }
            else
            {
                
                text1 = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
                text2 = ""
            }
            
            
            // let text = "\(text1)\("\n")\(text2)"
            
            //let text = ((featurebanner.object(at: i) as! NSDictionary).value(forKey: "title")   as! String)
            arry.add(url)
            arry1.add(text1)
            arry2.add(text2)
            arry3.add(text3)
            arry4.add(status)
            
            
            
        }
        imageCarouselView.statusarray.removeLastObject()
        imageCarouselView.imageurlarry.removeAllObjects()
        imageCarouselView.textarray.removeAllObjects()
        imageCarouselView.textarraydes.removeAllObjects()
        imageCarouselView.episodearray.removeAllObjects()
        
        
        
        
        imageCarouselView.statusarray = arry4
        imageCarouselView.imageurlarry = arry
        imageCarouselView.textarray = arry1
        imageCarouselView.textarraydes = arry2
        imageCarouselView.episodearray = arry3
        print(imageCarouselView.statusarray)
        
        
    }
    
    //MARK:- coresal view delegate
    func scrolledToPage(_ page: Int)
    {
        
    }
    
    func clickonpage(_ page: Int)
    {
        print(page)
    }
    func clickcoresal(notification:NSNotification)
    {
        print(featurebanner)
        let index = notification.object as! Int
        if(Common.isNotNull(object: (featurebanner.object(at: index) as! NSDictionary).value(forKey: "status") as AnyObject?))
        {
            let type = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "status") as! String
            print(type)
            if(!Common.Isvideolvodtype(type: type))
            {
                if(Common.Isvideolivetype(type: type))
                {
                    if(!Common.Islogin())
                    {
                        Common.Showloginalert(view: self, text: "\((featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                        return
                    }
                }
                else
                {
                    EZAlertController.alert(title: "\((featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                    return
                }
                
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.Video_url = ""
        playerViewController.descriptiontext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "des") as! String
        playerViewController.liketext =  ""
        playerViewController.tilttext = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "title") as! String
        playerViewController.Download_dic = (featurebanner.object(at: index) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        playerViewController.fromdownload = "no"
        playerViewController.downloadVideo_url = ""
        
        
        
        
        let catdataarray = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        if(catdataarray.count == 0)
        {
            playerViewController.catid = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((featurebanner.object(at: index) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
        }
        
        
        playerViewController.cat_id = (featurebanner.object(at: index) as! NSDictionary).value(forKey: "id") as! String
        
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
        {
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
        
        
    }
    
    
    
    
    
    //MARK:- Covert datetime
    func compatedate(date:String) ->String {
        print(date)
        var uploadtime = String()
        let dateFormatter = DateFormatter()
        let userCalendar = NSCalendar.current
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = NSDate()
        let endTime = dateFormatter.date(from: date)
        
        let timeDifference = userCalendar.dateComponents(dayHourMinuteSecond, from: endTime!, to: startTime as Date)
        
        
        
        if(Common.isNotNull(object: timeDifference.month as AnyObject?))
        {
            uploadtime =  "\(timeDifference.month!.toString())\(" Month ago")"
            return uploadtime
        }
            
        else
        {
            
            
            if(timeDifference.day != 0)
            {
                
                uploadtime =  "\(timeDifference.day!.toString())\(" Days ago")"
                return uploadtime
                
            }
                
            else if(timeDifference.hour != 0)
            {
                
                uploadtime =  "\(timeDifference.hour!.toString())\(" Hours ago")"
                return uploadtime
            }
            else if(timeDifference.minute != 0)
            {
                
                uploadtime =  "\(timeDifference.minute!.toString())\(" Minut ago")"
                return uploadtime
            }
            
            
            
        }
        
        return uploadtime
        // dateLabelOutlet.text = "\(timeDifference.month) Months \(timeDifference.day) Days \(timeDifference.minute) Minutes \(timeDifference.second) Seconds"
    }
    
    
    //MARK:- Menu button Action
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    //MARK:- didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateControlBarsVisibility() {
        if self.miniMediaControlsViewEnabled && self.miniMediaControlsViewController.active {
        } else {
        }
        UIView.animate(withDuration: kCastControlBarsAnimationDuration, animations: {() -> Void in
            self.view.layoutIfNeeded()
        })
        self.view.setNeedsLayout()
    }
    
    // MARK: - GCKUIMiniMediaControlsViewControllerDelegate
    
    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                         shouldAppear: Bool) {
        self.updateControlBarsVisibility()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
//MARK:- SlideMenuControllerDelegate Action delegate
extension ViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
