//
//  InviteReferralViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 07/06/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit

class InviteReferralViewController: UIViewController {
    
    @IBOutlet weak var Invitebutton: UIButton!
    @IBOutlet weak var RefrralCodelabel: UILabel!
    @IBOutlet weak var refrelview: UIView!
    var refreltext = String()
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        super.viewDidLoad()
        Common.setuiviewdborderwidth(View: refrelview, borderwidth: 1.0)
        Common.setlebelborderwidth(label: RefrralCodelabel, borderwidth: 1.0)
        Common.setbuttonborderwidth(button: Invitebutton, borderwidth: 1.0)
        Common.getRounduibutton(button: Invitebutton, radius: 5.0)
        Common.getRounduiview(view: refrelview, radius: 10.0)
        //  refrelview.dropShadow(color: UIColor.green, opacity: 0.6, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
        //   Invitebutton.dropShadow(color: UIColor.green, opacity: 0.6, offSet: CGSize(width: -1, height: 1), radius: 20, scale: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if let _ = dict.value(forKey: "referral_code") {
            refreltext = dict.value(forKey: "referral_code") as! String
            print(refreltext)
           }
        RefrralCodelabel.text = refreltext
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        //   slideMenuController()?.openLeft()
        
    }
    @IBAction func Taptoinvite(_ sender: UIButton) {
        
        
        
        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/yuv/id1295744587?mt=8")
        
        let text = "Hey I'm using YUV. Use my code \(refreltext) to sign up & lets enjoy. \n Visit YUV app on App Store"
        let textToShare:Array = [text, myWebsite] as [Any]
        // let textToShare = [ text,myWebsite ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.copyToPasteboard,UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
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
