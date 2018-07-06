//
//  LeftViewController.swift
//  SlideMenuControllerSwift


import UIKit

enum LeftMenu: Int {
    case main = 0
    case First
    case Second
    case Third
    case Fourth
    case fifth
    case Six
    case Seven
    case eight
    case nine
    case ten
    case eleven
 }

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {

    
    
    @IBOutlet weak var tableView: UITableView!
    var menus = [String]()
    var image = [String]()
    var identifier = [String]()
    var HomeViewController: UIViewController!
    var MyAccountViewController: UIViewController!
    var MyProfileViewController: UIViewController!
    var FavouriteViewController: UIViewController!
    var WatchListViewController: UIViewController!
    var PrivacyPolicyViewController: UIViewController!
    var InvitereferralView: UIViewController!
    var TermsofUseViewController: UIViewController!
    var DisclairmerViewController: UIViewController!
    var AboutViewController: UIViewController!
    var DownloadsViewController: UIViewController!
    var SignoutViewController: UIViewController!
    var SubscriptionViewController = UIViewController()
     var imageHeaderView: ImageHeaderView!
    var privacypocliy = String()
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(createsidemenu(data:)), name: NSNotification.Name(rawValue: "Sidemenunotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaptoProfile), name: NSNotification.Name(rawValue: "taptoprofile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginlogoutaction), name: NSNotification.Name(rawValue: "logoutaction"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(showWithoutloginalert), name: NSNotification.Name(rawValue: "Sidemenuloginalert"), object: nil)

        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
       // self.tableView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        self.tableView.backgroundColor = UIColor.black
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.HomeViewController = UINavigationController(rootViewController: homeViewController)
        
        let myAccountViewController = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        myAccountViewController.isprofilemakeupdate = false
        self.MyAccountViewController = UINavigationController(rootViewController: myAccountViewController)
        
        let favouriteViewController = storyboard.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
        self.FavouriteViewController = UINavigationController(rootViewController: favouriteViewController)
        
        
        let myProfileViewController = storyboard.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        self.MyProfileViewController = UINavigationController(rootViewController: myProfileViewController)
        
        let watchListViewController = storyboard.instantiateViewController(withIdentifier: "WatchListViewController") as! WatchListViewController
        self.WatchListViewController = UINavigationController(rootViewController: watchListViewController)
        
        let privacyPolicyViewController = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
        self.PrivacyPolicyViewController = UINavigationController(rootViewController: privacyPolicyViewController)
        
        let termsofUseViewController = storyboard.instantiateViewController(withIdentifier: "TermsofUseViewController") as! TermsofUseViewController
        self.TermsofUseViewController = UINavigationController(rootViewController: termsofUseViewController)
        
        let disclairmerViewController = storyboard.instantiateViewController(withIdentifier: "DisclairmerViewController") as! DisclairmerViewController
        self.DisclairmerViewController = UINavigationController(rootViewController: disclairmerViewController)
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.AboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        let downloadsViewController = storyboard.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
        self.DownloadsViewController = UINavigationController(rootViewController: downloadsViewController)
        
        
        let signoutViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.SignoutViewController = UINavigationController(rootViewController: signoutViewController)
        
        
        let subscriptionViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
        self.SubscriptionViewController = UINavigationController(rootViewController: subscriptionViewController)
        
        
        let inviteReferralViewController = storyboard.instantiateViewController(withIdentifier: "InviteReferralViewController") as! InviteReferralViewController
        self.InvitereferralView = UINavigationController(rootViewController: inviteReferralViewController)
        
        
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    
    
 
  

    
    func TaptoProfile()
    {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Updateprofiledata"), object: nil, userInfo: nil)
        LoginCredentials.faveprofileorother = "Myaccount"
        self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
    }
    func createsidemenu(data:Notification)
    {
        menus.removeAll()
        identifier.removeAll()
        image.removeAll()
        print(data.object as Any)
        let array = (data.object as! NSDictionary).value(forKey: "left_menu") as! NSArray
         for i in 0..<array.count {
            let str = (array.object(at: i) as! NSDictionary).value(forKey: "page_title") as! String
            let imageurl = (array.object(at: i) as! NSDictionary).value(forKey: "thumbnail") as! String
            let str1 = (array.object(at: i) as! NSDictionary).value(forKey: "identifier") as! String

           menus.append(str)
           image.append(imageurl)
           identifier.append(str1)
            
            if(str1 == "privacy")
            {
                privacypocliy = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
                LoginCredentials.Privacypolcy = privacypocliy
            }
             if(str1 == "tc")
            {
                LoginCredentials.Termsanduse = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
              if(str1 == "disclaimer")
            {
                LoginCredentials.Disclaimer = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
            if(str1 == "about")
            {
                LoginCredentials.About = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
            if(str1 == "faq")
            {
                LoginCredentials.Faq = (array.object(at: i) as! NSDictionary).value(forKey: "page_description") as! String
            }
            
            
        }
        self.tableView.reloadData()
        
      print(menus)
        
        
    }
  
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    func showWithoutloginalert()
    {
     
            let alertView = UIAlertController(title: "YUV", message: "Please login to access your profile", preferredStyle: .alert)
            let action = UIAlertAction(title: "Login", style: .default, handler: { (alert) in
              self.redirecttologinscreen()
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                
            })
            alertView.addAction(action)
            alertView.addAction(cancel)
            self.present(alertView, animated: true, completion: nil)
       
       
        
        
    }

    
    
    
    ///////Login/logout button Action////////////////
    
    func loginlogoutaction()
    {
     if (dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict").count>0)
          {
        let alertView = UIAlertController(title: "YUV", message: "Are you sure want to Signout?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Signout", style: .default, handler: { (alert) in
            dataBase.deletedataentity(entityname: "Logindata")
            LoginCredentials.UserSubscriptiondetail = NSArray()
             LoginCredentials.Allusersubscriptiondetail = NSDictionary()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
            self.redirecttologinscreen()
            dataBase.deletedataentity(entityname: "Downloadvideoid")
            Common.stopHeartbeat()
 
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        })
        alertView.addAction(action)
        alertView.addAction(cancel)
        self.present(alertView, animated: true, completion: nil)
        }
        else
          {
          redirecttologinscreen()
        }
      
        
        
    }
    
  func redirecttologinscreen()
  {
    
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    self.SignoutViewController = UINavigationController(rootViewController: loginViewController)
    self.slideMenuController()?.changeMainViewController(self.SignoutViewController, close: true)
  }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.HomeViewController, close: true)
        case .First:
            if(Common.Islogin())
            {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Updateprofiledata"), object: nil, userInfo: nil)
            LoginCredentials.faveprofileorother = "Myaccount"
             self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
            }
            else
            {
                self.showWithoutloginalert()
              }
        case .Second:
            if(Common.Islogin())
            {
                self.slideMenuController()?.changeMainViewController(self.WatchListViewController, close: true)
            }
            else
            {
              self.showWithoutloginalert()
            }
         case .Third:
            if(Common.Islogin())
            {
             self.slideMenuController()?.changeMainViewController(self.FavouriteViewController, close: true)
            }
            else
            {
              self.showWithoutloginalert()
            }
        case .Fourth:
            if(Common.Islogin())
            {
             
    let downloadsViewController = storyboard?.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
   self.DownloadsViewController = UINavigationController(rootViewController: downloadsViewController)
    self.slideMenuController()?.changeMainViewController(self.DownloadsViewController, close: true)
            }
            else
            {
              self.showWithoutloginalert()
            }
         case .fifth:
             LoginCredentials.headerlabeltext = "Privacy"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
         case .Six:
             LoginCredentials.headerlabeltext = "Terms"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
          case .Seven:
            LoginCredentials.headerlabeltext = "About"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
         case .eight:
             self.loginlogoutaction()
         case .nine:
            self.loginlogoutaction()
        case .ten:
            self.loginlogoutaction()
        case .eleven:
            self.loginlogoutaction()
          }
        
        
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .First, .Second, .Third, .Fourth, .fifth, .Six, .Seven, .eight, .nine, .ten, .eleven:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(identifier)
        if let menu = LeftMenu(rawValue: indexPath.row) {
           // self.changeViewController(menu)
            self.chageviewcontrooleracodingname(index: indexPath.row)

        }
    }
    
    
    func chageviewcontrooleracodingname(index:Int) {
        
        
        print(identifier)
        
        print(identifier[index])
        
        switch identifier[index] {
        case "home":
            self.slideMenuController()?.changeMainViewController(self.HomeViewController, close: true)
              break
        case "wishlist":
            if(Common.Islogin())
            {
         self.slideMenuController()?.changeMainViewController(self.WatchListViewController, close: true)
             }
            else
            {
                 self.showWithoutloginalert()
                
            }
            break
        case "favourite":
            if(Common.Islogin())
            {
            self.slideMenuController()?.changeMainViewController(self.FavouriteViewController, close: true)
            }
            else
            {
                self.showWithoutloginalert()
            }
            break
        case "downloads":
            if(Common.Islogin())
            {
                let downloadsViewController = storyboard?.instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
                self.DownloadsViewController = UINavigationController(rootViewController: downloadsViewController)
                self.slideMenuController()?.changeMainViewController(self.DownloadsViewController, close: true)
            }
            else
            {
                self.showWithoutloginalert()
                
            }
            
            break
        case "myaccount":
            if(Common.Islogin())
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Updateprofiledata"), object: nil, userInfo: nil)
                LoginCredentials.faveprofileorother = "Myaccount"
                self.slideMenuController()?.changeMainViewController(self.MyAccountViewController, close: true)
            }
            else
            {
                self.showWithoutloginalert()
            }
            break
        case "about":
            LoginCredentials.headerlabeltext = "About"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
            break
        case "subscription":
            if(Common.Islogin())
            {
               // Common.PresentSubscription(Viewcontroller: self)
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let subscriptionViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionView") as! SubscriptionView
                self.SubscriptionViewController = UINavigationController(rootViewController: subscriptionViewController)
         //       self.dismiss(animated: true, completion: nil)
               self.present(SubscriptionViewController, animated: true, completion: nil)
                
 //                if(Common.isuserseletedlocality()) {
//             self.dismiss(animated: true, completion: nil)
//            self.present(SubscriptionViewController, animated: true, completion: nil)
//                }
//                else
//                {
//                  Common.showuserlocationpopup(viewcontrooler: self)
//                }
            }
            else
            {
                
               self.showWithoutloginalert()
            }
            break
        case "tc":
            LoginCredentials.headerlabeltext = "Terms"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
            break
        case "faq":
            LoginCredentials.headerlabeltext = "FAQ"
            self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
            break
        case "privacy":
            LoginCredentials.headerlabeltext = "Privacy"
        self.slideMenuController()?.changeMainViewController(self.PrivacyPolicyViewController, close: true)
            break
        case "Invite":
            if(Common.Islogin()) {
            
                self.slideMenuController()?.present(self.InvitereferralView, animated: true, completion: nil)
           //  self.slideMenuController()?.changeMainViewController(self.InvitereferralView, close: true)
        }
        else
        {
            
            self.showWithoutloginalert()
        }
            break
            
         case "signout":
            self.loginlogoutaction()
            break
         default:
            break
            
            
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main, .First, .Second, .Third, .Fourth, .fifth, .Six, .Seven, .eight, .nine, .ten, .eleven:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
                if (indexPath.row == lastRowIndex - 1) {
                   if(Common.Islogin())
                   {
                    cell.setmenuimage(image[indexPath.row])
                    
                    }
                    else
                   {
                    cell.setsigninoutimage(nil)
                    }
                    
                    
                 }
                else
                {
                   cell.setmenuimage(image[indexPath.row])
                }
                
                
                //cell.backgroundColor =  UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                cell.backgroundColor =  UIColor.black

                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
