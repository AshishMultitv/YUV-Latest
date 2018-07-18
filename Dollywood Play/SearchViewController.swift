//
//  SearchViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 22/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

class SearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var mycollectionview: UICollectionView!
    @IBOutlet weak var resultcountlabel: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var resultlistview: UIView!
    @IBOutlet weak var showviewheightconstrant: NSLayoutConstraint!
    @IBOutlet weak var showcollectionview: UICollectionView!
    @IBOutlet weak var suggestionview: UIView!
    
    @IBOutlet weak var contentlable: UILabel!
    
    var issegmentselectshow:Bool = true
     var dataarray = NSArray()
    var showsarray = NSArray()
    var sectiondataarray = NSArray()
    var autosuggectionaarray = NSArray()
    var headerimageview  = UIImageView()
    var headertextlabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchbar.layer.borderColor = UIColor.blue.cgColor
        // searchbar.layer.borderWidth = 1.0
        self.mycollectionview!.register(UINib(nibName: "MyAppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
           self.showcollectionview!.register(UINib(nibName: "ShowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "showchnl")
        // mycollectionview.register(Searchheaderview.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "Searchheader")
        //        searchbar.isTranslucent = true
        //        searchbar.alpha = 1
        //        searchbar.backgroundColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
        //        searchbar.barTintColor = UIColor.init(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
        //        searchbar.backgroundImage = UIImage()
        //        searchbar.barTintColor = UIColor.clear
        
        // Do any additional setup after loading the view.
        suggestionview.isHidden = true
        resultlistview.isHidden = true
        self.mytableview.estimatedRowHeight = 30
    }
    
    @IBAction func Taptosegment(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            if(showsarray.count == 0)
            {
                if let window = appDelegate?.window {
          
                  Toast.displayMessage("No show found",
                                       for: 1, in: window)
                }
             
            }
            issegmentselectshow = true
         }
        else
        {
           issegmentselectshow = false
            if(autosuggectionaarray.count == 0)
            {
                if let window = appDelegate?.window {
                    Toast.displayMessage("No result found",
                                         for: 1, in: window)
                }
                
            }
        }
        
        self.suggestionview.isHidden = false
        mytableview.reloadData()
        
        
    }
    @IBAction func Taptoback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func Getautosuggestion(searchkey:String)
    {
        self.mytableview.reloadData()
        self.resultlistview.isHidden = true
        self.suggestionview.isHidden = false
        var url = String(format: "%@%@/title/%@", LoginCredentials.Autosuggestapi,Apptoken,searchkey)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    self.autosuggectionaarray = NSArray()
                }
                else
                {
                    self.autosuggectionaarray = dict.value(forKey: "result") as! NSArray
                }
                
                
                if(self.autosuggectionaarray.count == 0 && self.showsarray.count == 0 )
                {
                    self.suggestionview.isHidden = true
                }
                else
                {
                    self.mytableview.reloadData()
                    self.resultlistview.isHidden = true
                    self.suggestionview.isHidden = false
                    
                    
                }
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    
    func getshowsearch(text:String) {
        
        let showlistarry = (((LoginCredentials.Showlist.value(forKey: "children") as! NSArray).value(forKey: "children") as! NSArray).object(at: 0) as! NSArray)
        print(showlistarry)
        let predicate = NSPredicate(format: "name contains[cd] %@", text)
        let newList = showlistarry .filtered(using: predicate)
        showsarray = newList as NSArray
        print(newList as NSArray)
 
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.view.endEditing(true)
    }
    
    func searchwithstring(searchkey:String)
    {
        Common.startloder(view: self.view)
        var url = String(format: "%@%@/device/ios/current_offset/0/max_counter/30/search_tag/%@", LoginCredentials.Searchapi,Apptoken,searchkey)
        print(url)
        url =  url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptSearchapi)
                {
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                        self.dataarray = NSArray()
                        self.sectiondataarray = NSArray()
                    }
                    else
                    {
                        Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        self.dataarray = Catdata_dict.value(forKey: "content") as! NSArray
                        self.sectiondataarray = self.dataarray.value(forKey: "cntn") as! NSArray
                    }
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    self.dataarray = Catdata_dict.value(forKey: "content") as! NSArray
                    self.sectiondataarray = self.dataarray.value(forKey: "cntn") as! NSArray
                    
                }
                print(Catdata_dict)
                
                self.resultcountlabel.text = "Total results:\(self.dataarray.count)"
                if(self.dataarray.count == 0)
                {
                     self.contentlable.isHidden = true
                }
                else
                {
                 self.contentlable.isHidden = false
                }
                print(self.dataarray.count)
                print(self.showsarray.count)
                
                if(self.dataarray.count == 0 && self.showsarray.count == 0)
                {
                    EZAlertController.alert(title: "No content found")
                }
                //  self.mytableview.reloadData()
                
                if(self.showsarray.count == 0)
                {
                    self.showviewheightconstrant.constant = 0.0
                }
                else
                {
                   self.showviewheightconstrant.constant = 166.0
                }
               
                 self.showcollectionview.reloadData()
                 self.mycollectionview.reloadData()
                 self.suggestionview.isHidden = true
                 self.resultlistview.isHidden = false
                Common.stoploder(view: self.view)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            EZAlertController.alert(title: "No result found")
            Common.stoploder(view: self.view)
        }
        
    }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.suggestionview.isHidden = true
        searchwithstring(searchkey: searchBar.text!)
        getshowsearch(text: searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.autosuggectionaarray = NSArray()
        self.mytableview.reloadData()
        
        if(searchText.length > 2)
        {
            Getautosuggestion(searchkey: searchText)
            getshowsearch(text: searchText)
            
            
        }
        else
        {
            self.suggestionview.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(issegmentselectshow) {
            return showsarray.count
        }
        else
        {
        return self.autosuggectionaarray.count
        }
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
 
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[3] as! Custometablecell
         if(issegmentselectshow) {
            if(showsarray.count>0)
            {
            cell.Autosuggestontitle.text = (showsarray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "name") as? String
            }
         }
        else
         {
        if(autosuggectionaarray.count>0)
        {
            cell.Autosuggestontitle.text = autosuggectionaarray.object(at: indexPath.row) as? String
        }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        self.suggestionview.isHidden = true
            if(issegmentselectshow) {
                if(showsarray.count>0)
                {
                searchwithstring(searchkey: ((showsarray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "name") as? String)!)
                    
                    getshowsearch(text: ((showsarray.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "name") as? String)!)
                
                }
                
        }
            else{
                if(autosuggectionaarray.count>0)
                {
          searchwithstring(searchkey: (autosuggectionaarray.object(at: indexPath.row) as? String)!)
          getshowsearch(text: (autosuggectionaarray.object(at: indexPath.row) as? String)!)
                }
        }
        searchbar.resignFirstResponder()
    }
    
    
    
    
    //MARK:collection View delegate method
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
      if(collectionView == showcollectionview)
      {
         return 1
        }
      else {
        return sectiondataarray.count
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        
        var header : UICollectionReusableView! = nil
        if(collectionView == showcollectionview)
        {
                if kind == UICollectionElementKindSectionHeader {
                header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "chnlheader", for: indexPath as IndexPath)
            }
                return header
        }
        
        else
        {
        if kind == UICollectionElementKindSectionHeader {
            
            
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headersection", for: indexPath as IndexPath)
            if header.subviews.count == 0 {
                header.backgroundColor  =  UIColor.init(colorLiteralRed: 11/255, green: 11/255, blue: 11/255, alpha: 1.0)
                headerimageview = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 45, height: 25))
                headertextlabel = UILabel.init(frame: CGRect.init(x: 70, y: 17, width: 200, height: 15))
                headertextlabel.textColor = UIColor.white
                Common.getRoundImage(imageView: headerimageview, radius: 8.0)
                Common.setuiimageviewdborderwidth(imageView: headerimageview, borderwidth: 1.0)
                
                header.addSubview(headertextlabel)
                header.addSubview(headerimageview)
                
            }
            let lab = header.subviews[0] as! UILabel
            let str1  = (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "name") as! String
            lab.text = str1
            let imageview = header.subviews[1] as! UIImageView
            var imageurl  = (dataarray.object(at: indexPath.section) as! NSDictionary).value(forKey: "image") as! String
            //imageurl = Common.getsplitnormalimageurl(url: imageurl)
            if(imageurl == "")
            {
                imageview.image = #imageLiteral(resourceName: "Placehoder")
            }
            else
            {
                imageview.setImageWith(URL(string: imageurl)!, placeholderImage: UIImage.init(named: "Placehoder"))
            }
            
            
        }
        
         return header
        }
        
     
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
     
        return CGSize.init(width: 0, height: 0.0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
           if(collectionView == showcollectionview)
           {
            return CGSize(width: view.frame.width/3-15, height: 141)
        }
        else
           {
         return CGSize(width: view.frame.width/2-5, height: 141)
        }
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == showcollectionview)
        {
            return showsarray.count
        }
        
        else
        {
        if(sectiondataarray.count>0)
        {
            
            return ((self.dataarray.value(forKey: "cntn") as! NSArray).object(at: section) as! NSArray).count
        }
        else
        {
            return 0
        }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == showcollectionview)
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showchnl", for: indexPath) as! ShowCollectionViewCell
             var url = String()
            if(Common.isNotNull(object: (showsarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnails") as AnyObject))
            {
                  url  = ((showsarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnails") as! NSArray).object(at: 0) as! String
                if(url == "")
                {
                   cell.showimageview.image = #imageLiteral(resourceName: "Placehoder")
                }
                else
                {
                  cell.showimageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
            }
            else
            {
                cell.showimageview.image = #imageLiteral(resourceName: "Placehoder")
            }
            
            
          return cell
            
           
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyAppCollectionViewCell
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.white.cgColor
            cell.clipsToBounds = true
            if(Common.isNotNull(object: ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject)) {
                let url = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
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
            cell.titilelabel.text = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            var discriptiontext = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.Descriptionlabel.text = discriptiontext
            //cell.viewlabel.text = "\((self.dataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
            cell.viewlabel.text = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let videotime = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
            
            cell.uploaddatelabel.text = self.compatedate(date: videotime!)
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if(collectionView == showcollectionview)
        {
            
           
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
            moreViewController.id = (showsarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            moreViewController.moreorzoner = "more"
            moreViewController.headertext = (showsarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String
            moreViewController.headerimageurl = ((showsarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnails") as! NSArray).object(at: 0) as! String
            self.navigationController?.pushViewController(moreViewController, animated: true)
            
        }
        else
        {
        
        if(Common.isNotNull(object: ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
        {
            let type = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
            print(type)
            if(!Common.Isvideolvodtype(type: type))
            {
                if(Common.Isvideolivetype(type: type))
                {
                    if(!Common.Islogin())
                    {
                        Common.Showloginalert(view: self, text: "\(((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                        return
                    }
                }
                else
                {
                    EZAlertController.alert(title: "\(((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                    return
                }
                
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        playerViewController.descriptiontext =  ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
        playerViewController.tilttext =   ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
        playerViewController.fromdownload = "no"
        
        
        let catdataarray = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        if(catdataarray.count == 0)
        {
            playerViewController.catid = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
        }
        else
        {
            
            var ids = String()
            for i in 0..<catdataarray.count
            {
                
                let str = (((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
        }
        
        
        playerViewController.cat_id = ((sectiondataarray.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
        if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
        {
            self.navigationController?.pushViewController(playerViewController, animated: true)
        }
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
