//
//  ChannelInfoViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 29/08/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import AFNetworking
import MessageUI

class ChannelInfoViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet var Headernamelabel: UILabel!
    @IBOutlet var totalsubcriptionlabel: UILabel!
    @IBOutlet var totalviewlabel: UILabel!
    @IBOutlet var Chaneelcreatedatelabel: UILabel!
    @IBOutlet var Chaneldeslabel: UILabel!
    @IBOutlet var Emaillabel: UILabel!
    @IBOutlet var Phonenumberlabel: UILabel!
    
    @IBOutlet var scroolviewhgtconstrant: NSLayoutConstraint!
    
    
    var channelinfo = NSDictionary()
    var fburl = String()
    var twitterurl = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Getchannelinfodetail()
        //  self.setchanneldetail(Channelinfo: channelinfo)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    func Getchannelinfodetail()
    {
        
        
        
        Common.startloder(view: self.view)
        var parameters = [String : Any]()
        
        parameters = [ "user_id":channelinfo.value(forKey: "id") as! String,
                       "device":"ios",
        ]
        
        print(parameters)
        let url = String(format: "%@%@/device/ios/user_id/%@", LoginCredentials.Channellistapi,Apptoken,channelinfo.value(forKey: "id") as! String)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploder(view: self.view)
                
                let dict = responseObject as! NSDictionary
                
                if((dict.value(forKey: "code") as! NSNumber) == 0)
                {
                    
                }
                else{
                    
                    var chaneeldata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptChannellistapi)
                    {
                        chaneeldata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        chaneeldata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    }
                    
                    
                    print(chaneeldata_dict)
                    self.setchanneldetail(Channelinfo: (chaneeldata_dict.value(forKey: "channels") as! NSArray).object(at: 0) as! NSDictionary)
                    
                    
                    
                }
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func TaptoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func setchanneldetail(Channelinfo:NSDictionary)
    {
        Headernamelabel.text = "\(Channelinfo.value(forKey: "first_name") as! String)\(Channelinfo.value(forKey: "last_name") as! String)"
        totalsubcriptionlabel.text = "\(Channelinfo.value(forKey: "total_subscriber") as! String)\(" Subscribers")"
        totalviewlabel.text = ""
        // Chaneelcreatedatelabel.text = "\(Channelinfo.value(forKey: "created_on") as! String)"
        Chaneldeslabel.text = "\(Channelinfo.value(forKey: "description") as! String)"
        let deshght =  self.calculateContentHeight(str: Chaneldeslabel.text!)
        print(deshght)
        scroolviewhgtconstrant.constant = deshght + 500
        Emaillabel.text = "\(Channelinfo.value(forKey: "email") as! String)"
        Phonenumberlabel.text = "\(Channelinfo.value(forKey: "phone") as! String)"
        fburl = Channelinfo.value(forKey: "facebook_url") as! String
        twitterurl = Channelinfo.value(forKey: "twitter_url") as! String
        
        
        
    }
    func calculateContentHeight(str:String) -> CGFloat{
        let maxLabelSize: CGSize = CGSize.init(width: self.view.frame.size.width - 26, height: 9999)
        let contentNSString = str as NSString
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: CGFloat(14))! as UIFont], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
        
    }
    @IBAction func Taptoemail(_ sender: UIButton) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            EZAlertController.alert(title: "Mail services are not available")
            return
        }
        sendEmail()
    }
    
    @IBAction func taptophone(_ sender: UIButton) {
        print(Phonenumberlabel.text!)
        if let url = URL(string: "tel://\(Phonenumberlabel.text!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
        
    }
    
    @IBAction func TaptoFacebook(_ sender: UIButton) {
        
        guard let url = URL(string: fburl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func TaptoTwitter(_ sender: UIButton) {
        guard let url = URL(string: twitterurl) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
    
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([Emaillabel.text!])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
