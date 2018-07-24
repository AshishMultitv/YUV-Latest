//
//  UserintersetViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 15/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import SpriteKit
import Magnetic
import AFNetworking

class UserintersetViewController: UIViewController,MagneticDelegate {
    
    
    public func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        
        print(node.label.text)
        for i in 0..<dataarray.count
        {
            if((dataarray.object(at: i) as! NSDictionary).value(forKey: "title") as? String == node.label.text)
            {
                seletednode.add(dataarray.object(at: i))
            }
        }
        
        
        print(seletednode)
        
        
    }
    public func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        
        print(node.label.text)
        print(seletednode)
        for i in 0..<seletednode.count
        {
            if((seletednode.object(at: i) as! NSDictionary).value(forKey: "title") as? String == node.label.text)
            {
                seletednode.removeObject(at: i)
                return
            }
        }
        print(seletednode) 
        
    }
    
    var dataarray = NSArray()
    var seletednode = NSMutableArray()
    
    
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            #if DEBUG
                magneticView.showsFPS = true
                magneticView.showsDrawCount = true
                magneticView.showsQuadCount = true
            #endif
        }
    }

    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    
    func gotoforgotview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getuserintesetedapi()
    }
    
    
    func makeloopincontant()
    {
        for i in 0..<dataarray.count {
            setmagnetview(name: (dataarray.object(at: i) as! NSDictionary).value(forKey: "title") as! String)
        }
    }
    
    @IBAction func TaptoDone(_ sender: UIButton) {
        if(seletednode.count<5)
        {
            EZAlertController.alert(title: "Please select atleast 5 intreset")
        }
        else
        {
            var ids = String()
            for i in 0..<seletednode.count
            {
                let str = (seletednode.object(at: i) as! NSDictionary).value(forKey: "id") as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            
            self.setuserintersetofuser(userintresetedid: ids)
        }
    }
    
    func gotohomeview()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func setuserintersetofuser(userintresetedid:String)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        
        parameters = [ "user_id":((dict.value(forKey: "id") as! NSNumber).stringValue),
                       "device":"ios",
                       "id": userintresetedid
        ]
        
        let url = String(format: "%@/interest/add/token/%@", LoginCredentials.BaseUrl,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    EZAlertController.alert(title: "Server Error")
                }
                else
                {
                    
                    
                    self.gotohomeview()
                    
                    
                }
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
  
    }
    
    
    
    func getuserintesetedapi()
    {
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        parameters = [ "user_id":"",
                       "device":"ios",
        ]
        let url = String(format: "%@/interest/list/token/%@", LoginCredentials.BaseUrl,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    EZAlertController.alert(title: "Server Error")
                }
                else
                {
                    
                    self.dataarray = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "interests") as! NSArray
                    self.makeloopincontant()
                    
                    
                    
                }
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    
    func setmagnetview(name:String)
    {
        let namecontant = name
        let name = UIImage.names.randomItem()
        let color = UIColor.colors.randomItem()
        let node = Node(text: namecontant, image: UIImage(named: name), color: color, radius: 40)
        magnetic.addChild(node)

        
    }
    //    @IBAction func add(_ sender: UIControl?) {
    //        let name = UIImage.names.randomItem()
    //        let color = UIColor.colors.randomItem()
    //        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
    //        magnetic.addChild(node)
    //        
    //        // Image Node: image displayed by default
    //        // let node = ImageNode(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
    //        // magnetic.addChild(node)
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//// MARK: - MagneticDelegate
//extension ViewController: MagneticDelegate {
//    
//    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
//        print("didSelect -> \(node)")
//    }
//    
//    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
//        print("didDeselect -> \(node)")
//    }
//    
//}
// MARK: - ImageNode
class ImageNode: Node {
    override var image: UIImage? {
        didSet {
            sprite.texture = image.map { SKTexture(image: $0) }
        }
    }
    override func selectedAnimation() {}
    override func deselectedAnimation() {}
}
