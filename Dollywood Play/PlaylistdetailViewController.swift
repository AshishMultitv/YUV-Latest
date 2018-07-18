//
//  PlaylistdetailViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 18/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import KRPullLoader


class PlaylistdetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet var headerlabel: UILabel!
    @IBOutlet var mytableview: UITableView!
    var playlistid = String()
    var playlistname = String()
    var dataarray = NSMutableArray()
    var display_offset = String()
    let refreshView = KRPullLoadView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display_offset = "0"
        mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        refreshView.delegate = self
        mycollectionview.addPullLoadableView(refreshView, type: .loadMore)
        headerlabel.text = playlistname
        Common.startloder(view: self.view)
        getPlaylist()
  
        // Do any additional setup after loading the view.
    }
    @IBAction func Taptoback(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        getPlaylist()
    }
    
    func getPlaylist()
    {
        //playlist_id //if i click on playlist
        
        var parameters = [String : Any]()
        var url = String()
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            let user_id = (dict.value(forKey: "id") as! NSNumber).stringValue
            parameters = [ "playlist_id":playlistid,
                           "device":"ios",
                           "user_id":user_id
            ]
            
            url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/10/playlist_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,playlistid)
            
            
        }
        else
        {
            parameters = [ "playlist_id":playlistid,
                           "device":"ios",
            ]
            url = String(format: "%@%@/device/ios/current_offset/%@/max_counter/10/playlist_id/%@", LoginCredentials.Listapi,Apptoken,display_offset,playlistid)
            
            
            
        }
        
       // http://staging.multitvsolution.com:9000/api/v6/content/list/token/59a942cd8175f/device/web/current_offset/0/max_counter/10/cat_id/99
        // url = String(format: "%@%@", LoginCredentials.Listapi,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploder(view: self.view)
                
                let dict = responseObject as! NSDictionary
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    
                    self.mycollectionview.reloadData()
                    //self.mytableview.reloadData()
                    
                }
                else
                {
                    var chaneeldata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptListapi)
                    {
                        chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    }
                    
                    
                    self.display_offset =   (chaneeldata_dict.value(forKey: "offset") as! NSNumber).stringValue
                    let array = chaneeldata_dict.value(forKey: "content") as! NSArray
                    
                    for i in 0..<array.count {
                        self.dataarray.add(array.object(at: i) as! NSDictionary)
                    }
                    
                    print(chaneeldata_dict)
                    self.mycollectionview.reloadData()
                    
                    //self.mytableview.reloadData()
                    
                }
                
                
                
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataarray.count
    }
    
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
        
        
        
        cell.titletypwlabel.text = ""
        
        
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text = discriptiontext
        
        var url = ((((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        
        
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
        playerViewController.Video_url = ""
        
        if(Common.isNotNull(object: (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
        {
            playerViewController.descriptiontext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        }
        else
        {
            playerViewController.descriptiontext = ""
        }
        playerViewController.liketext =  ""
        playerViewController.tilttext = (dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        
        playerViewController.fromdownload = "no"
        playerViewController.Download_dic = (dataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
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
        
        cell.titilelabel.text = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        var discriptiontext = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.Descriptionlabel.text = discriptiontext
         cell.viewlabel.text = ""
      //  cell.viewlabel.text = "\((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
        let videotime = (self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
        cell.uploaddatelabel.text = self.compatedate(date: videotime!)
        
        
        return cell
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
        
        
        var ids = String()
        for i in 0..<catdataarray.count
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
        }    }
    
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
    
    override func viewDidDisappear(_ animated: Bool)
    {
        mycollectionview.removePullLoadableView(refreshView)
    }
    
    
    
}
// MARK: - KRPullLoadView delegate -------------------

extension PlaylistdetailViewController: KRPullLoadViewDelegate {
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


