//
//  DownloadsViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 08/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MatomoTracker

class DownloadsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var menubutton: UIButton!
    @IBOutlet var nolabel: UILabel!
    @IBOutlet weak var mytableview: UITableView!
    var downloadarray:NSMutableArray = NSMutableArray()
    var timer:Timer!
    @IBOutlet var downloadcollectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadcollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(getinform), name: NSNotification.Name(rawValue: "Downloadingvideo"), object: nil)
    }
    

    func update() {
        if(Common.isInternetAvailable())
        {
            self.timer.invalidate()
            isrechable()
            
        }
        else{
            
        }
        
    }
    
    func isrechable()
    {
        
        let alert = UIAlertController(title: "YUV", message: "Internet connection is avilable now. Are you want to go online in this app.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Go Online", style: UIAlertActionStyle.destructive, handler: { action in
            self.Gohomeview()
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func Gohomeview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func getinform()
    {
        getdownloadvieo()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.downloadarray.count
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
        Common.getRounduiview(view: cell.timerview, radius: 5.0)
        
        Common.setlebelborderwidth(label: cell.timelabel, borderwidth: 1.0)
        cell.timelabel.layer.borderColor = UIColor.white.cgColor
        
        
        cell.titlelabel.text = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        cell.titlelabel.frame = CGRect.init(x: cell.titlelabel.frame.origin.x, y: cell.titlelabel.frame.origin.x, width:  cell.titlelabel.frame.size.width-40, height: cell.titlelabel.frame.size.height)
        let button: UIButton = UIButton()
        button.setImage(UIImage(named:"Cross"), for: .normal)
        button.frame = CGRect.init(x: self.view.frame.size.width - 30, y: cell.frame.origin.y+5, width: 25, height: 25)
        let downloadlabel: UILabel = UILabel()
        downloadlabel.frame = CGRect.init(x: self.view.frame.size.width - 80, y: cell.frame.size.height-24, width: 70, height: 13)
        downloadlabel.font = UIFont(name: "Ubuntu", size: CGFloat(10))
        downloadlabel.textAlignment = .center
        downloadlabel.layer.cornerRadius = 5.0
        downloadlabel.layer.borderWidth = 1.0
        downloadlabel.layer.borderColor = UIColor.white.cgColor
        downloadlabel.clipsToBounds = true
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let Id = (downloadarray.object(at: (indexPath.row)) as! NSDictionary).value(forKey: "id") as? String
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(Id!).mp4"))
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationURLForFile.path) {
            downloadlabel.text = "Completed"
            downloadlabel.textColor = UIColor.white
            cell.imageview.alpha = 1.0
        }
        else
        {
            
            cell.imageview.alpha = 0.5
            downloadlabel.text = "Downloading.."
            downloadlabel.textColor = UIColor.green
            let progressimageview: UIImageView = UIImageView()
            progressimageview.frame = CGRect.init(x: cell.imageview.frame.size.width/2-25, y: cell.imageview.frame.size.height/2-25, width: 25, height: 25)
            let image1:UIImage = UIImage(named: "1")!
            let image2:UIImage = UIImage(named: "2")!
            let image3:UIImage = UIImage(named: "3")!
            let image4:UIImage = UIImage(named: "4")!
            let image5:UIImage = UIImage(named: "5")!
            let image6:UIImage = UIImage(named: "6")!
            let image7:UIImage = UIImage(named: "7")!
            progressimageview.animationImages = [image1,image2,image3,image4,image5,image6,image7]
            progressimageview.animationDuration = 1.0
            progressimageview.startAnimating()
            cell.addSubview(progressimageview)
            
        }
        
        
        
        
        button.addTarget(self, action: #selector(taptoremove), for: .touchUpInside)
        var discriptiontext = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.desciptionlabel.text =  discriptiontext
        let url = ((((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
        
        
        DispatchQueue.global().async {
            let data = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "videoimage") as? NSData
            cell.imageview.image = UIImage(data:data! as Data)
        }
        
        // cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
        let videotime = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
        button.bringSubview(toFront: cell)
        cell.addSubview(button)
        cell.addSubview(downloadlabel)
        
        
        
        return cell
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.downloadarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.clipsToBounds = true
        if(Common.isNotNull(object: (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
        {
        let url = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
        
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
        let button: UIButton = UIButton()
        button.setImage(UIImage(named:"Cross"), for: .normal)
        button.frame = CGRect.init(x: cell.contentView.frame.size.width - 30, y: cell.contentView.frame.origin.y+5, width: 25, height: 25)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(taptoremove), for: .touchUpInside)
        cell.titilelabel.text = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
        var discriptiontext = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
        discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cell.Descriptionlabel.text = discriptiontext
         cell.viewlabel.text = ""
        cell.uploaddatelabel.text = ""
        //cell.viewlabel.text = "\((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let videotime = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
//        cell.uploaddatelabel.text = self.compatedate(date: videotime!)
 
        
        /////////show video is in downloading Mood////////////
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let downloadurl = NSURL(fileURLWithPath: path)
        let Id = (downloadarray.object(at: (indexPath.row)) as! NSDictionary).value(forKey: "id") as? String
        let filePath = downloadurl.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(Id!).mp4")?.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath!) {
            let progressimageview: UIImageView = UIImageView()
            progressimageview.frame = CGRect.init(x: cell.contentView.frame.size.width/2-25, y: cell.contentView.frame.size.height/2-25, width: 25, height: 25)
            let image1:UIImage = UIImage(named: "1")!
            let image2:UIImage = UIImage(named: "2")!
            let image3:UIImage = UIImage(named: "3")!
            let image4:UIImage = UIImage(named: "4")!
            let image5:UIImage = UIImage(named: "5")!
            let image6:UIImage = UIImage(named: "6")!
            let image7:UIImage = UIImage(named: "7")!
            progressimageview.animationImages = [image1,image2,image3,image4,image5,image6,image7]
            progressimageview.animationDuration = 1.0
            progressimageview.startAnimating()
            cell.addSubview(progressimageview)
        }
        
        cell.contentView.addSubview(button)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let downloadurl = NSURL(fileURLWithPath: path)
        let Id = (downloadarray.object(at: (indexPath.row)) as! NSDictionary).value(forKey: "id") as? String
        let filePath = downloadurl.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(Id!).mp4")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.descriptiontext =  (downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.tilttext =   (downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "yes"
            let catdataarray = (downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            if(catdataarray.count == 0)
            {
                playerViewController.catid = (downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
                
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                playerViewController.catid = ids
            }
            
            playerViewController.cat_id = (downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.Islogin())
            {
                  MatomoTracker.shared.track(eventWithCategory: "content", action: "offline_play", name: playerViewController.tilttext, value: 1)
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
            
        }
        else
        {
            EZAlertController.alert(title: "Can't play this video because its downloading")
            downloadcollectionview.reloadData()
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
    
    
    
    
    
    
    
    func taptoremove(sender:UIButton)
    {
        print(sender.tag)
        let buttonPosition = sender.convert(CGPoint.zero, to: downloadcollectionview)
        
        let indexPath: IndexPath? = downloadcollectionview.indexPathForItem(at: buttonPosition)
        let Id = (downloadarray.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "id") as? String
        print(Id)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        print(dict)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(Id!).mp4"))
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationURLForFile.path) {
            let alert = UIAlertController(title: (downloadarray.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "title") as? String, message: "Are you sure want to delete this video?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
                self.deletevideofromdocumentdirectry(id: Id!)
                // do something like...
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }
        else
        {
            
            
            let alert = UIAlertController(title: (downloadarray.object(at: (indexPath?.row)!) as! NSDictionary).value(forKey: "title") as? String, message: "Are you sure want to Cancel Downloading?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel Downloading", style: UIAlertActionStyle.destructive, handler: { action in
                self.deletevideofromdocumentdirectry(id: Id!)
                let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                dataBase.deletedownloadvideoid(videoid: Id!,user_id:(dict.value(forKey: "id") as! NSNumber).stringValue)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CancelDownloading"), object: nil, userInfo: nil)
                
                // do something like...
                
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    func deletevideofromdocumentdirectry(id:String)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        self.deletvideofromcoredata(video_id: id, user_id: (dict.value(forKey: "id") as! NSNumber).stringValue)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let videoDataPath = url.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(id).mp4")?.path
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: videoDataPath!)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        
    }
    
    
    func deletvideofromcoredata(video_id:String,user_id:String)
    {
        dataBase.deletedownloaddata(userid: user_id, videoid: video_id)
        getdownloadvieo()
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let downloadurl = NSURL(fileURLWithPath: path)
        let Id = (downloadarray.object(at: (indexPath.row)) as! NSDictionary).value(forKey: "id") as? String
        let filePath = downloadurl.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(Id!).mp4")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerViewController.Video_url = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            playerViewController.descriptiontext = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            
            if let likes_countnew = ((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as AnyObject) as? NSNumber
            {
                
                print("number ")
                playerViewController.liketext = ((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! NSNumber).stringValue
                
                
                
            }
            else
            {
                print("string")
                playerViewController.liketext = ((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! String)
                
            }
            
            
            
            
            // playerViewController.liketext = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! String
            
            playerViewController.tilttext = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "yes"
            
            if(((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count > 0)
            {
                var ids = String()
                for i in 0..<((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
                {
                    
                    
                    let str = ((self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                playerViewController.catid = ids
                
            }
            else
            {
                playerViewController.catid = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
                
            }
            
            
            playerViewController.cat_id = (self.downloadarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
            
        }
        else
        {
            EZAlertController.alert(title: "Can't play this video because its downloading")
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func getdownloadvieo()
    {
        
        downloadarray.removeAllObjects()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            downloadarray = dataBase.getdownloadlistdatabase(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
            if(downloadarray.count>0)
            {
                mytableview.isHidden = false
                downloadcollectionview.isHidden = false
                nolabel.isHidden = true
                // mytableview.reloadData()
                downloadcollectionview.reloadData()
                print(downloadarray)
                return
            }
            else
            {
                //mytableview.reloadData()
                downloadcollectionview.reloadData()
                downloadcollectionview.isHidden = true
                mytableview.isHidden = true
                nolabel.isHidden = false
                EZAlertController.alert(title: "Can't find any download video in your download list")
            }
        }
        else
        {
            mytableview.isHidden = true
            nolabel.isHidden = false
            mytableview.reloadData()
            
            Common.Showloginalert(view: self, text:"Please login to see your download")
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if(Common.isInternetAvailable())
        {
            self.menubutton.isHidden = false
        }
        else
        {
            self.menubutton.isHidden = true
            EZAlertController.alert(title: "Please Check your internet connection")
            
        }
        
        if(!Common.isInternetAvailable())
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        }
        
        
        
        
        getdownloadvieo()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(timer != nil)
        {
            self.timer.invalidate()
        }
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIView.setAnimationsEnabled(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
public extension String {
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
}
