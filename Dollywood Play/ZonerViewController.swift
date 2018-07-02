//
//  ZonerViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 16/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking


class ZonerViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mycollectionview: UICollectionView!
    var ZonerData_arry:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        //layout.minimumInteritemSpacing = 0
        //layout.minimumLineSpacing = 0
        // mycollectionview!.collectionViewLayout = layout
        Common.startloder(view: self.view)
        self.getZonerlist()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Taptosearch(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    @IBAction func Backbuttonaction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    func getZonerlist()
    {
        let parameters = [
            "device": "ios",
            ]
        let url = String(format: "%@/content/getGenre/token/%@", LoginCredentials.BaseUrl,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                
                self.ZonerData_arry = dict.value(forKey: "result") as! NSArray
                print(self.ZonerData_arry)
                self.mycollectionview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.ZonerData_arry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ZonerCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ZonerCollectionViewCell)
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.clipsToBounds = true
        cell?.label.text = (ZonerData_arry.object(at: indexPath.item) as! NSDictionary).value(forKey: "genre_name") as? String
        var str = (ZonerData_arry.object(at: indexPath.item) as! NSDictionary).value(forKey: "thumb") as! String
        str = Common.getsplitnormalimageurl(url: str)
        cell?.imageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let moreViewController = storyboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        print(((ZonerData_arry.object(at: (indexPath.item)) as! NSDictionary).value(forKey: "id") as! String))
        moreViewController.id = ((ZonerData_arry.object(at: (indexPath.item)) as! NSDictionary).value(forKey: "id") as! String)
        moreViewController.moreorzoner = "zoner"
        moreViewController.headertext = ((ZonerData_arry.object(at: (indexPath.item)) as! NSDictionary).value(forKey: "genre_name") as! String)
        self.navigationController?.pushViewController(moreViewController, animated: true)
        
    }
    
}
