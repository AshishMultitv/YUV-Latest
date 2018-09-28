//
//  ChanneldetailViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 18/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import MXSegmentedPager


class ChanneldetailViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet var notificatiobbutton: UIButton!
    @IBOutlet var myscrollview: UIView!
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet var videiotablelist: UITableView!
    @IBOutlet var Playlisttabelview: UITableView!
    @IBOutlet var numberofsubscriber: UILabel!
    @IBOutlet var issubscribeimageview: UIImageView!
    @IBOutlet var channelnamelabel: UILabel!
    @IBOutlet var channellogiimageview: UIImageView!
    @IBOutlet var channelimageview: UIImageView!
    @IBOutlet var headernamelabel: UILabel!
    var chanldict = NSDictionary()
    var channeldetaildict = NSDictionary()
    var playlistarray = NSArray()
    var videodata = NSArray()
    var mXSegmentedPager = MXSegmentedPager()
    
    @IBOutlet var subcribebutton: UIButton!
    var issubcribe:Bool = Bool()
    var isplaylist:Bool = Bool()
    var ischnlnotificationsubcribed:Bool = Bool()
    
    
    ////contraint outlate
    @IBOutlet var playlisttableviewheightcntrant: NSLayoutConstraint!
    @IBOutlet var videilisttableviewhghtcntrant: NSLayoutConstraint!
    @IBOutlet var scroolviewheightcontrant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.mycollectionview!.register(UINib(nibName: "UserRelatedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell1")
        Getchannelplaylist()
        getsubscriptiondetai()
        setmenu()
        isplaylist = true
        Common.getRoundImage(imageView: channellogiimageview, radius: 8.0)
        Common.setuiimageviewdborderwidth(imageView: channellogiimageview, borderwidth: 1.0)
        print(chanldict)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Taptosuscribechannelnotification(_ sender: UIButton) {
        
        
        if(Common.Islogin())
        {
            Common.startloderonplayer(view: self.view)
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            var url = String()
            if(ischnlnotificationsubcribed)
            {
                parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                               "channel_id":chanldict.value(forKey: "id") as! String,
                               "donot_notify":"0"
                ]
                url = String(format: "%@%@", LoginCredentials.Unsubscribeapi,Apptoken)
                
            }
            else
            {
                parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                               "channel_id":chanldict.value(forKey: "id") as! String,
                               "donot_notify":"1"
                ]
                url = String(format: "%@%@", LoginCredentials.Subscribeapi,Apptoken)
            }
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    Common.stoploderonplayer(view: self.view)
                    if(self.ischnlnotificationsubcribed)
                    {
                        self.ischnlnotificationsubcribed = false
                        self.notificatiobbutton.setImage(UIImage.init(named: "notificationdisable"), for: .normal)
                    }
                    else
                    {
                        self.ischnlnotificationsubcribed = true
                        self.notificatiobbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                        
                        
                    }
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
            
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func Taptosubcribechnl(_ sender: UIButton) {
        
        
        if(Common.Islogin())
        {
            
            if(issubcribe)
            {
                
                let alert = UIAlertController(title: "YUV", message: "Unsubscribe from \(self.channeldetaildict.value(forKey: "first_name") as! String)\(" ")\(self.channeldetaildict.value(forKey: "last_name") as! String) ?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
                    self.subscribechnl()
                }))
                self.present(alert, animated: true, completion: nil)
            }
                
            else
            {
                subscribechnl()
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
            
        }
        
        
    }
    
    
    
    func subscribechnl()
    {
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                       "channel_id":chanldict.value(forKey: "id") as! String,
        ]
        
        var url = String()
        if(issubcribe)
        {
            url = String(format: "%@%@", LoginCredentials.Unsubscribeapi,Apptoken)
            
        }
        else
        {
            url = String(format: "%@%@", LoginCredentials.Subscribeapi,Apptoken)
            
        }
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploder(view: self.view)
                if(self.issubcribe)
                {
                    self.issubcribe = false
                    self.issubscribeimageview.image = UIImage.init(named: "UnSubcribed")
                    self.notificatiobbutton.isHidden = true
                    
                }
                else
                {
                    self.notificatiobbutton.isHidden = true
                    self.ischnlnotificationsubcribed = true
                    self.notificatiobbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                    self.issubcribe = true
                    self.issubscribeimageview.image = UIImage.init(named: "Subcribed")
                    
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
    }
    
    
    @IBAction func Taptoback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func getsubscriptiondetai()
    {
        
        
        
        if(Common.Islogin())
        {
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            var url = String()
            
            if(LoginCredentials.IsencriptUserbehaviorapi)
            {
                
                url = String(format: "%@%@/device/ios/user_id/%@/ch_id/%@", LoginCredentials.Userbehaviorapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,chanldict.value(forKey: "id") as! String)
                
                // http://staging.multitvsolution.com:9000/api/v6/content/user_behavior/token/59ed85d805d3d/device/android/user_id/317747/ch_id/444
                
                
            }
            else
            {
                
                
                url = String(format: "%@%@/device/ios/user_id/%@/content_id", LoginCredentials.Userbehaviorapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue)
                
                
            }
            print(parameters)
            print(url)
            Common.startloder(view: self.view)
            // url = String(format: "%@%@", LoginCredentials.Userbehaviorapi,Apptoken)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploder(view: self.view)
                    let dict1 = responseObject as! NSDictionary
                    print(dict1)
                    let number = dict1.value(forKey: "code") as! NSNumber
                    
                    if(number == 0)
                    {
                    }
                    else
                    {
                        
                        var dict = NSMutableDictionary()
                        
                        
                        if(LoginCredentials.IsencriptUserbehaviorapi)
                        {
                            dict = (dict1.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                            
                        else
                        {
                            dict = Common.decodedresponsedata(msg: dict1.value(forKey: "result") as! String)
                            print(dict)
                        }
                        
                        if( (dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "is_subscriber") as! NSString == "0")
                        {
                            
                            self.issubscribeimageview.image = UIImage.init(named: "UnSubcribed")
                            self.issubcribe = false
                            self.notificatiobbutton.isHidden = true
                        }
                        else
                        {
                            self.notificatiobbutton.isHidden = true
                            self.issubscribeimageview.image = UIImage.init(named: "Subcribed")
                            self.issubcribe = true
                            if( (dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "notification") as! String == "0")
                            {
                                self.ischnlnotificationsubcribed = false
                                self.notificatiobbutton.setImage(UIImage.init(named: "notificationdisable"), for: .normal)
                                
                            }
                            else
                            {
                                self.ischnlnotificationsubcribed = true
                                self.notificatiobbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
                self.showalertinconnection()
                
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func Taptochanellinfo(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let channelInfoViewController = storyboard.instantiateViewController(withIdentifier: "ChannelInfoViewController") as! ChannelInfoViewController
        channelInfoViewController.channelinfo = self.channeldetaildict
        self.navigationController?.pushViewController(channelInfoViewController, animated: true)
        
        
    }
    
    func Getchannelplaylist()
    {
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        parameters = [ "content_partner":chanldict.value(forKey: "id") as! String,
                       "device":"ios",
        ]
        print(parameters)
        let url = String(format: "%@%@/device/ios/content_partner/%@", LoginCredentials.Playlistapi,Apptoken,chanldict.value(forKey: "id") as! String)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    self.playlistarray = NSArray()
                    self.Getchannelvideolist()
                }
                else
                {
                    var chaneeldata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptPlaylistapi)
                    {
                        chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    }
                    print(chaneeldata_dict)
                    self.playlistarray = chaneeldata_dict.value(forKey: "playlist") as! NSArray
                    self.channeldetaildict = chaneeldata_dict.value(forKey: "owner_info") as! NSDictionary
                    if(self.playlistarray.count == 0)
                    {
                        EZAlertController.alert(title: "No playlist yet.")
                    }
                    self.setchanneldetail()
                    self.Getchannelvideolist()
                    self.mycollectionview.reloadData()
           
                }
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
            
        }
        
        
        
    }
    
    
    
    func showalertinconnection()
    {
        let alert = UIAlertController(title: "", message: "Getting Some Error! Please Try Again.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func Getchannelvideolist()
    {
        //playlist_id //if i click on playlist
        var parameters = [String : Any]()
        
        parameters = [ "content_partner_id":chanldict.value(forKey: "id") as! String,
                       "device":"ios",
                       "max_counter": "100"
        ]
        
        
        let url = String(format: "%@%@/device/ios/current_offset/0/max_counter/100/content_partner_id/%@", LoginCredentials.Listapi,Apptoken,chanldict.value(forKey: "id") as! String)
        print(url)
        
        //http://staging.multitvsolution.com:9000/api/v6/content/list/token/59a942cd8175f/device/web/current_offset/0/max_counter/10/cat_id/99
        
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploder(view: self.view)
                
                let dict = responseObject as! NSDictionary
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    
                    self.videodata = NSArray()
                    
                }
                else
                {
                    var chaneeldata_dict =  NSMutableDictionary()
                    if(LoginCredentials.IsencriptListapi)
                    {
                        chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    }
                    
                    print(chaneeldata_dict)
                    self.videodata = chaneeldata_dict.value(forKey: "content") as! NSArray
                    
                    
                }
                
                
                
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }
    
    
    
    func setchanneldetail()
    {
        
        
        
        if(Common.isNotNull(object: channeldetaildict.value(forKey: "banner_image") as AnyObject?))
        {
            var str  = channeldetaildict.value(forKey: "banner_image") as! String
            if(str == "")
            {
                channelimageview.image = #imageLiteral(resourceName: "Placehoder")
                
            }
            else
            {
                str = Common.getsplitbannerimageurl(url: str)
                channelimageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
            }
        }
        
        if(Common.isNotNull(object: channeldetaildict.value(forKey: "prfile_pic") as AnyObject?))
        {
            let str1  = channeldetaildict.value(forKey: "prfile_pic") as! String
            if(str1 == "")
            {
                channelimageview.image = #imageLiteral(resourceName: "Placehoder")
            }
            else
            {
                channellogiimageview.setImageWith(URL(string: str1)!, placeholderImage: UIImage.init(named: "Placehoder"))
            }
        }
        
        channelnamelabel.text = "\(channeldetaildict.value(forKey: "first_name") as! String)\(" ")\(channeldetaildict.value(forKey: "last_name") as! String)"
        headernamelabel.text = "\(channeldetaildict.value(forKey: "first_name") as! String)\(" ")\(channeldetaildict.value(forKey: "last_name") as! String)"
        numberofsubscriber.text = "\(channeldetaildict.value(forKey: "total_subscriber") as! String)\(" Subscribers")"
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == Playlisttabelview {
            
            return playlistarray.count
        }
        else
        {
            return videodata.count
        }
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == videiotablelist)
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
            
            cell.titlelabel.text = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            
            cell.titletypwlabel.text = ""
            
            
            var discriptiontext = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            var url = ((((self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
            //  url = Common.getsplitnormalimageurl(url: url)
            cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            let videotime = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
        else
        {
            let SimpleTableIdentifier:NSString = "cell"
            var cell1:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
            cell1 = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[1] as! Custometablecell
            cell1.selectionStyle = .none
            var url = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumb") as! String
            //  url = Common.getsplitnormalimageurl(url: url)
            
            cell1.Channelimageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            cell1.channelnamelabel.text = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_title") as? String
            cell1.chaneelDeslabel.text = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as? String
            cell1.channelvideoCount.text = "\((playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "total_video") as! String)\(" Video")"
            cell1.cnoofvideolabel.text = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "total_video") as? String
            return cell1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == Playlisttabelview)
            
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playlistdetailViewController = storyboard.instantiateViewController(withIdentifier: "PlaylistdetailViewController") as! PlaylistdetailViewController
            playlistdetailViewController.playlistid =   ((playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "cat_id") as? String)!
            playlistdetailViewController.playlistname =   ((playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_title") as? String)!
            
            self.navigationController?.pushViewController(playlistdetailViewController, animated: true)
        }
        else
        {
            
            
            
            if(Common.isNotNull(object: (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            
                            Common.Showloginalert(view: self, text: "\((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "\((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                        return
                    }
                    
                }
            }
            
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.Video_url = ""
            
            if(Common.isNotNull(object: (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
                playerViewController.descriptiontext = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            }
            else
            {
                playerViewController.descriptiontext = ""
            }
            playerViewController.liketext =  ""
            playerViewController.tilttext = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            
            playerViewController.fromdownload = "no"
            playerViewController.Download_dic = (videodata.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if Common.isNotNull(object: (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                playerViewController.downloadVideo_url = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            
            
            var ids = String()
            for i in 0..<((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                
                
                let str = ((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
            
            
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if(isplaylist)
        {
            return playlistarray.count
        }
        else
        {
            return videodata.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        
        if(isplaylist)
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! UserRelatedCollectionViewCell
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.white.cgColor
            cell.clipsToBounds = true
            var url = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumb") as! String
            
            
            if(Common.isNotNull(object: url as AnyObject?))
            {
                //url = Common.getsplitnormalimageurl(url: url)
                
                cell.bannerimage.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            }
            else
            {
                cell.bannerimage.image = #imageLiteral(resourceName: "Placehoder")
            }
            
            cell.titlelabel.text = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            cell.countlabel.text = (playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "total_video") as? String
            
            return cell
        }
            
        else
        {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.white.cgColor
            cell.clipsToBounds = true
            
            let url = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
            if(url.count>0)
            {
                var str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                str = Common.getsplitnormalimageurl(url: str)
                cell.bannerimaheview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
            }
            else
            {
                cell.bannerimaheview.image = #imageLiteral(resourceName: "Placehoder")
            }
            
            cell.titilelabel.text = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            var discriptiontext = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.Descriptionlabel.text = discriptiontext
             cell.viewlabel.text = ""
              cell.uploaddatelabel.text = ""
           // cell.viewlabel.text = "\((self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "HH:mm:ss"
//            let videotime = (self.videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
//            cell.uploaddatelabel.text = self.compatedate(date: videotime!)
 
            return cell
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(isplaylist)
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playlistdetailViewController = storyboard.instantiateViewController(withIdentifier: "PlaylistdetailViewController") as! PlaylistdetailViewController
            playlistdetailViewController.playlistid =   ((playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as? String)!
            playlistdetailViewController.playlistname =   ((playlistarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String)!
            self.navigationController?.pushViewController(playlistdetailViewController, animated: true)
        }
        else
        {
            
            
            
            if(Common.isNotNull(object: (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "\((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "\((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                        return
                    }
                    
                }
            }
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.descriptiontext =  (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.tilttext =   (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "no"
            
            
            let catdataarray = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            if(catdataarray.count == 0)
            {
                playerViewController.catid = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
                
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                playerViewController.catid = ids
            }
            
            
            playerViewController.cat_id = (videodata.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-5, height: 141)
    }
    
    
    
    
    
    
    //MARK:- MXSegmentedPager Set menu
    
    func setmenu()
    {
        
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: numberofsubscriber.frame.origin.y+numberofsubscriber.frame.size.height-15, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor =  UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.white
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: Discriptioncolor, NSFontAttributeName: UIFont.init(name: "Ubuntu", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.myscrollview.addSubview(mXSegmentedPager)
        
    }
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int
    {
        return 2
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String
    {
        switch index {
        case 0:
            return "Playlist"
        case 1:
            return "More Videos"
        default:
            break
        }
        return ""
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView
    {
        let label = UILabel()
        //label.text! = "Page #\(index)"
        // label.textAlignment = .Center
        //label.text = "Ashish"
        return label
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int)
    {
        switch index {
        case 0:
            isplaylist = true
            if(self.playlistarray.count == 0)
            {
                EZAlertController.alert(title: "No playlist yet.")
            }
            self.mycollectionview.reloadData()
            
            //  mytableview.reloadData()
            print(index)
            
        case 1:
            isplaylist = false
            self.mycollectionview.reloadData()
            //  mytableview.reloadData()
            if(self.videodata.count == 0)
            {
                EZAlertController.alert(title: "No videos yet.")
            }
            
            print(index)
            
        default:
            break
        }
        
    }
    
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
        
        print("\(timeDifference.month) Months \(timeDifference.day) Days \(timeDifference.hour) Hours \(timeDifference.minute) Minutes ago")
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func TAptoshowmorevideo(_ sender: UIButton) {
        
        
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
