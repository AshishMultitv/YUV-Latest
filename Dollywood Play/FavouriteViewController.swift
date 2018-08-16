//
//  FavouriteViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 08/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import KRPullLoader


class FavouriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet var mytableview: UITableView!
    var dataarray = NSMutableArray()
    var display_offset = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        mycollectionview.addPullLoadableView(refreshView, type: .loadMore)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        display_offset = "0"
        if(Common.Islogin())
        {
            Common.startloder(view: self.view)
            self.dataarray = NSMutableArray()
            self.Getlikedlist()
        }
        else
        {
            self.dataarray = NSMutableArray()
            self.mycollectionview.reloadData()
            Common.Showloginalert(view: self, text:"Please login see your watchlist")
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        Getlikedlist()
    }
    func Getlikedlist()
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let parameters = [
            "device": "ios",
            "user_id": ((dict.value(forKey: "id") as! NSNumber).stringValue),
            "max_counter":"20",
            "type": "liked",
            "current_offset":display_offset
        ]
        // let url = String(format: "%@%@/device/cat_idios/user_id/%@/max_counter/20/type/liked/current_offset/%@", LoginCredentials.Userrelatedapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,display_offset)
        let url = String(format: "%@%@/device/ios/current_version/0.0/max_counter/20/current_offset/%@/user_id/%@/type/favorite", LoginCredentials.Userrelatedapi,Apptoken,display_offset,(dict.value(forKey: "id") as! NSNumber).stringValue)
        
        
        let manager = AFHTTPSessionManager()
        print(url)
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptUserrelatedapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    
                }
                
                print(Catdata_dict)
                let array = Catdata_dict.value(forKey: "content") as! NSArray
                for i in 0..<array.count {
                    self.dataarray.add(array.object(at: i) as! NSDictionary)
                }
                
                if(self.dataarray.count == 0)
                {
                    EZAlertController.alert(title: "No Videos found")
                }
                self.display_offset =   (Catdata_dict.value(forKey: "offset") as! NSNumber).stringValue
                self.mycollectionview.reloadData()
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
             EZAlertController.alert(title: error.localizedDescription)
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataarray.count
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
        
        cell.titlelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        
        
        if Common.isNotNull(object: ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
        {
            cell.titletypwlabel.text = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
        }
        else
        {
            cell.titletypwlabel.text = ""
        }
        
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text = discriptiontext
        var url = ((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
        url = Common.getsplitnormalimageurl(url: url)
        
        cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(Common.Islogin())
        {
            if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            
                            Common.Showloginalert(view: self, text: "\((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "\((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                        
                        return
                    }
                    
                }
            }
            
   
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.Video_url = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.liketext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! String
            playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.Download_dic = (dataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            playerViewController.fromdownload = "no"
            if Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                playerViewController.downloadVideo_url = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            
            var ids = String()
            for i in 0..<((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }        }
        else
        {
            Common.Showloginalert(view: self, text:"Please login to watch video")
            
        }
        
    }
    
    
    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.clipsToBounds = true
        if(Common.isNotNull(object: (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
        {
            let url = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
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
        }
        else
        {
            cell.bannerimaheview.image = #imageLiteral(resourceName: "Placehoder")
        }
        cell.titilelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.Descriptionlabel.text = discriptiontext
        cell.viewlabel.text = ""
        cell.uploaddatelabel.text = ""
      //  cell.viewlabel.text = "\((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
//         cell.uploaddatelabel.text = self.compatedate(date: videotime!)
  
        
        let unfavbutton = UIButton.init(frame: CGRect.init(x: cell.frame.size.width-40, y: 10, width: 30, height: 30))
         unfavbutton.setImage(#imageLiteral(resourceName: "favremove"), for: .normal)
        unfavbutton.tag = indexPath.row
         unfavbutton.addTarget(self, action: #selector(taptounfav(button:)), for: .touchUpInside)
        cell.contentView.addSubview(unfavbutton)
        return cell
    }
    
    
    
    func taptounfav(button: UIButton) {
        
        print(button.tag)
        
       let cat_id = (dataarray.object(at: button.tag) as! NSDictionary).value(forKey: "id") as! String
        
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
           Common.startloder(view: self.view)
            var parameters = [String:String]()
            parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"0",
                    "content_type":"video",
                     ]
        
            JYToast.init().isShow("Removed from favorite videos")
            
 
//                if let window = appDelegate?.window {
//                    Toast.displayMessage("Removed from favorite videos",
//                                         for: 1, in: window)
//                }
             let url = String(format: "%@%@", LoginCredentials.Favrioutapi,Apptoken)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    self.display_offset = "0"
                    self.dataarray.removeAllObjects()
                    self.Getlikedlist()
                    
                    
                 }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
 
            
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
   
         if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
        {
            let type = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
            print(type)
            if(!Common.Isvideolvodtype(type: type))
            {
                if(Common.Isvideolivetype(type: type))
                {
                    if(!Common.Islogin())
                    {
                        Common.Showloginalert(view: self, text: "\((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                        return
                    }
                }
                else
                {
                    EZAlertController.alert(title: "\((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                    return
                }
                
            }
        }
        
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.descriptiontext =  (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        playerViewController.tilttext =   (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        playerViewController.fromdownload = "no"
        
        
        let catdataarray = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        if(catdataarray.count == 0)
        {
            playerViewController.catid = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = ((dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
        }
        
        
        playerViewController.cat_id = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
        {
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-5, height: 141)
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
    
    
}
// MARK: - KRPullLoadView delegate -------------------

extension FavouriteViewController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
            }
        }
    }
}


