//
//  MyAccountViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 08/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import FormToolbar

class MyAccountViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var profile_view: UIView!
    @IBOutlet weak var BlurProfileimage_view: UIImageView!
    @IBOutlet weak var profileimage_view: UIImageView!
    @IBOutlet weak var User_namelabel: UILabel!
    @IBOutlet weak var user_emaillable: UILabel!
    @IBOutlet weak var scroll_view: UIView!
    @IBOutlet weak var myscroll: UIScrollView!
    @IBOutlet weak var Profiledetailview: UIView!
    @IBOutlet weak var favlikeview: UIView!
    @IBOutlet weak var mytableview: UITableView!
    
    
    
    
    @IBOutlet weak var firstname_tx: UITextField!
    @IBOutlet weak var lastname_tx: UITextField!
    @IBOutlet weak var phoneNo_tx: UITextField!
    @IBOutlet weak var email_tx: UITextField!
    @IBOutlet weak var DOb_tx: UITextField!
    @IBOutlet weak var maleimage_view: UIImageView!
    @IBOutlet weak var femaleimageview: UIImageView!
    @IBOutlet weak var submit_button: UIButton!
    
    
    
    var logindata = NSMutableDictionary()
    var watchingdatadict = NSMutableDictionary()
    var watchingdataarray = NSArray()
    var likedatadict = NSMutableDictionary()
    var likedataarray = NSArray()
    var favdatadict = NSMutableDictionary()
    var favdataarray = NSArray()
    var selectiontype = String()
    var toolbar = FormToolbar()
    var mXSegmentedPager = MXSegmentedPager()
    var malefemale = String()
    var datePickerView = UIDatePicker()
    var imagePicker = UIImagePickerController()
    var imagebase64str = String()
    var isprofileimagechange = Bool()
    
    
    
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        self.BlurProfileimage_view.contentMode = .scaleAspectFill
        Common.getRoundImage(imageView: profileimage_view, radius: profileimage_view.frame.size.height/2)
        isprofileimagechange = false
        
        
        ///view will apear////
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [firstname_tx, lastname_tx, phoneNo_tx,email_tx])
        setmenu()
        logindata = NSMutableDictionary()
        logindata = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        //selectiontype = "watching"
        setprofiledata()
        
    }
    
    @IBAction func Taptoeditprofile(_ sender: UIButton) {
        self.comefromsidemenu(str: "Myaccount")
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.comefromsidemenu(str: LoginCredentials.faveprofileorother)
    }
    
    func createdatepicker(sender: UITextField)
    {
        
        let inputView = UIView(frame: CGRect.init(x:0, y:0, width:self.view.frame.width, height:240))
        datePickerView  = UIDatePicker(frame: CGRect.init(x:0, y:40, width:0, height:0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect.init(x:(self.view.frame.size.width/2) - (100/2), y:0, width:100, height:50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(doneButton(sender:)), for: UIControlEvents.touchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        handleDatePicker(sender: datePickerView)
        
    }
    func doneButton(sender:UIButton)
    {
        DOb_tx.resignFirstResponder() // To resign the inputView on clicking done.
    }
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        DOb_tx.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func TAptoSubmit(_ sender: UIButton) {
        
        if logindata.count>0
            
        {
            updateprofiledata()
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login first to update profile")
            
            
        }
    }
    @IBAction func Taptochagneprofile(_ sender: UIButton) {
        
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
            
        })
        
        let deleteAction = UIAlertAction(title: "Gallery", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        
        
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func converimagetobase64(image:UIImage)
    {
        let tmpData: NSData? = UIImageJPEGRepresentation(image, 0.5) as NSData?;
        imagebase64str = (tmpData?.base64EncodedString(options: .lineLength64Characters))!
        
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Common.getRoundImage(imageView: profileimage_view, radius: profileimage_view.frame.size.height/2)
            //profileimage_view.contentMode = .scaleAspectFit
            profileimage_view.image = pickedImage
            BlurProfileimage_view.image = pickedImage
            isprofileimagechange = true
            profileimage_view.image =  profileimage_view.image?.fixOrientation()
            converimagetobase64(image: profileimage_view.image!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
        isprofileimagechange = false
        
    }
    
    func updateprofiledata()
    {
        
        Common.startloder(view: self.view)
        let uiimageview = UIImageView.init(image: UIImage(named: "userprofile"))
        
        var parameters = [String : String]()
        if(!isprofileimagechange)
        {
            parameters = [
                "device": "ios",
                "id": logindata.value(forKey: "id") as! String,
                "first_name": firstname_tx.text!,
                "last_name": lastname_tx.text!,
                "gender": malefemale,
                "contact_no": phoneNo_tx.text!,
                "dob": DOb_tx.text!,
                "ext": "",
                "pic":"",
                "address":""
            ]
        }
        else
        {
            parameters = [
                "device": "ios",
                "id": logindata.value(forKey: "id") as! String,
                "first_name": firstname_tx.text!,
                "last_name": lastname_tx.text!,
                "gender": malefemale,
                "contact_no": phoneNo_tx.text!,
                "dob": DOb_tx.text!,
                "ext": "jpg",
                "pic":imagebase64str,
                "address":""
            ]
        }
        
        
        let url = String(format: "%@%@", LoginCredentials.Editapi,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                var data = NSMutableDictionary()
                if(LoginCredentials.IsencriptEditapi)
                {
                    data = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    data = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                
                print(data)
                self.isprofileimagechange = false
                dataBase.deletedataentity(entityname: "Logindata")
                dataBase.Savedatainentity(entityname: "Logindata", key: "logindatadict", data: data)
                self.setprofiledata()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Setprofiledata"), object: nil, userInfo: nil)
                EZAlertController.alert(title: "Profile Update Successfully.")
                Common.stoploder(view: self.view)
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    
    @IBAction func Taptomalebuttonaction(_ sender: UIButton) {
        
        femaleimageview.image = UIImage.init(named: "unselectcircle")
        maleimage_view.image = UIImage.init(named: "Selectcircle")
        malefemale = "Male"
        
        
    }
    
    @IBAction func Taptofemalebuttonaction(_ sender: UIButton) {
        femaleimageview.image = UIImage.init(named: "Selectcircle")
        maleimage_view.image = UIImage.init(named: "unselectcircle")
        malefemale = "Female"
        
    }
    
    func comefromsidemenu(str:String)
    {
        
        if(str == "Myaccount")
        {
            self.Profiledetailview.isHidden  =  false
            self.favlikeview.isHidden  =  true
            mXSegmentedPager.segmentedControl.selectedSegmentIndex = 3
        }
        else if(str == "favorite")
        {
            
            self.Profiledetailview.isHidden  =  true
            self.favlikeview.isHidden  =  false
            selectiontype = "favorite"
            if(logindata.count>0)
            {
                self.getuserrelatedatalist(type: "favorite")
            }
            mXSegmentedPager.segmentedControl.selectedSegmentIndex = 1
            
        }
        else if(str == "watching")
        {
            
            
            self.Profiledetailview.isHidden  =  true
            self.favlikeview.isHidden  =  false
            selectiontype = "watching"
            if(logindata.count>0)
            {
                self.getuserrelatedatalist(type: "watching")
            }
            
            mXSegmentedPager.segmentedControl.selectedSegmentIndex = 0
            
            
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(textField == DOb_tx)
        {
            createdatepicker(sender: textField)
        }
        else
        {
            self.toolbar.update()
        }
        
    }
    
    
    
    func setprofiledata()
    {
        
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            
            
            
            if(!(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)) || !(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.User_namelabel.text =  "Enter Your Detail"
            }
                
            else if((Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)) || (Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.User_namelabel.text = "\(dict.value(forKey: "first_name") as! String)\(" ")\(dict.value(forKey: "last_name") as! String)"
            }
                
            else if((Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)))
            {
                
                self.User_namelabel.text = "\(dict.value(forKey: "first_name") as! String)"
            }
                
            else if((Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.User_namelabel.text = "\(dict.value(forKey: "last_name") as! String)"
            }
            
            if((Common.isNotNull(object: dict.value(forKey: "email") as AnyObject?)))
            {
                
                self.user_emaillable.text = "\(dict.value(forKey: "email") as! String)"
            }
            
            
            
            if Common.isNotNull(object: dict.value(forKey: "image") as AnyObject?)
            {
                //Common.getRoundImage(imageView: profileimage_view, radius: profileimage_view.frame.size.height/2)
                var url =  dict.value(forKey: "image") as! String
                // url = Common.getsplitnormalimageurl(url: url)
                profileimage_view.setImageWith(URL(string: url)!)
                BlurProfileimage_view.setImageWith(URL(string: url)!)
                
                
                
            }
            if((Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?)))
            {
                
                self.firstname_tx.text = "\(dict.value(forKey: "first_name") as! String)"
            }
            if((Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?)))
            {
                
                self.lastname_tx.text = "\(dict.value(forKey: "last_name") as! String)"
            }
            if((Common.isNotNull(object: dict.value(forKey: "email") as AnyObject?)))
            {
                
                self.email_tx.text = dict.value(forKey: "email") as! String?
            }
            
            
            if((Common.isNotNull(object: dict.value(forKey: "gender") as AnyObject?)))
            {
                
                
                if((dict.value(forKey: "gender") as! String) == "Male")
                {
                    
                    femaleimageview.image = UIImage.init(named: "unselectcircle")
                    maleimage_view.image = UIImage.init(named: "Selectcircle")
                }
                else if((dict.value(forKey: "gender") as! String) == "Female")
                {
                    
                    maleimage_view.image = UIImage.init(named: "unselectcircle")
                    femaleimageview.image = UIImage.init(named: "Selectcircle")
                    
                }
            }
            if((dict.value(forKey: "contact_no") as! String) == "")
            {
                
            }
            else
            {
                phoneNo_tx.text = dict.value(forKey: "contact_no") as? String
            }
            
            if((Common.isNotNull(object: dict.value(forKey: "dob") as AnyObject?)))
            {
                if((dict.value(forKey: "dob") as! String) == "0000-00-00")
                {
                    
                }
                else {
                    DOb_tx.text = dict.value(forKey: "dob") as? String
                }
                
                
            }
            
            
        }
        else
        {
            BlurProfileimage_view.image = nil
            self.User_namelabel.text  = "Enter Your Detail"
            user_emaillable.text = ""
            self.firstname_tx.text = ""
            self.lastname_tx.text = ""
            self.phoneNo_tx.text = ""
            self.email_tx.text = ""
            DOb_tx.text = ""
        }
    }
    
    func getuserrelatedatalist(type:String)
    {
        
        Common.startloder(view: self.view)
        let parameters = [
            "device": "ios",
            "type":type,
            "user_id":logindata.value(forKey: "id") as! String
        ]
        let url = String(format: "%@%@/device/ios/type/%@/user_id/%@", LoginCredentials.Userrelatedapi,Apptoken,type,logindata.value(forKey: "id") as! String)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                Common.stoploder(view: self.view)
                if(type == "watching")
                {
                    self.watchingdatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    self.watchingdataarray = self.watchingdatadict.value(forKey: "content") as! NSArray
                    if(self.watchingdataarray.count == 0)
                    {
                        EZAlertController.alert(title: "Data is not available")
                    }
                    
                    
                }
                else if(type == "favorite")
                {
                    self.favdatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    self.favdataarray = self.favdatadict.value(forKey: "content") as! NSArray
                    if(self.favdataarray.count == 0)
                    {
                        EZAlertController.alert(title: "Data is not available")
                    }
                }
                else if(type == "liked")
                {
                    self.likedatadict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    self.likedataarray = self.likedatadict.value(forKey: "content") as! NSArray
                    if(self.likedataarray.count == 0)
                    {
                        EZAlertController.alert(title: "Data is not available")
                    }
                }
                self.mytableview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
    }
    
    
    //
    
    
    
    
    func setmenu()
    {
        
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: profile_view.frame.size.height, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor = UIColor.black
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.red
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "Ubuntu", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.segmentedControl.segmentWidthStyle = .dynamic
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.scroll_view.addSubview(mXSegmentedPager)
        
    }
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int
    {
        return 4
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String
    {
        switch index {
        case 0:
            return "Watch List"
        case 1:
            return "Favourite"
        case 2:
            return "Likes"
        case 3:
            return "Personal details"
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
            
            EZAlertController.alert(title: "This section is in progress")
            //
            //            self.Profiledetailview.isHidden  =  true
            //            self.favlikeview.isHidden  =  false
            //            selectiontype = "watching"
            //            if(logindata.count>0)
            //            {
            //                self.getuserrelatedatalist(type: "watching")
            //            }
            //            else{
            //                EZAlertController.alert(title: "Please login to access this section")
            //            }
            
            
        case 1:
            
            
            EZAlertController.alert(title: "This section is in progress")
            
            //            self.Profiledetailview.isHidden  =  true
            //            self.favlikeview.isHidden  =  false
            //            selectiontype = "favorite"
            //            if(logindata.count>0)
            //            {
            //                self.getuserrelatedatalist(type: "favorite")
            //            } else{
            //                EZAlertController.alert(title: "Please login to access this section")
            //            }
            
        case 2:
            
            EZAlertController.alert(title: "This section is in progress")
            
            //            self.Profiledetailview.isHidden  =  true
            //            self.favlikeview.isHidden  =  false
            //            selectiontype = "liked"
            //            if(logindata.count>0)
            //            {
            //                self.getuserrelatedatalist(type: "liked")
            //            } else{
            //                EZAlertController.alert(title: "Please login to access this section")
            //            }
            
        case 3:
            self.Profiledetailview.isHidden  =  false
            self.favlikeview.isHidden  =  true
        default:
            break
        }
        
    }
    
    
    @IBAction func Taptomenu(_ sender: UIButton)
    {
        slideMenuController()?.openLeft()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight: Float = Float(scrollView.frame.size.height)
        let scrollContentSizeHeight: Float = Float(scrollView.contentSize.height)
        let scrollOffset: Float = Float(scrollView.contentOffset.y)
        print(scrollOffset)
        if scrollOffset == 230 {
            myscroll.bounces = false
            
            // then we are at the top
        }
        else if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
            myscroll.bounces = true
            // then we are at the end
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(selectiontype == "watching")
        {
            return watchingdataarray.count
            
        }
        else if(selectiontype == "favorite")
        {
            return favdataarray.count
            
            
        }
        else if(selectiontype == "liked")
        {
            return likedataarray.count
            
            
        }
        
        
        return 0
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
        
        if(selectiontype == "watching")
        {
            cell.titlelabel.text = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            if isNotNull(object: ((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = ((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
            
            var discriptiontext = (self.watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            var url = ((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
            url = Common.getsplitnormalimageurl(url: url)
            cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            let videotime = (self.watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
            
        }
        else if(selectiontype == "favorite")
        {
            cell.titlelabel.text = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            if isNotNull(object: ((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = ((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
            
            
            var discriptiontext = (self.favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            var url = ((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
            url = Common.getsplitnormalimageurl(url: url)
            cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            
            let videotime = (self.favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
            
        }
        else if(selectiontype == "liked")
        {
            cell.titlelabel.text = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            if isNotNull(object: ((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as AnyObject)
            {
                cell.titletypwlabel.text = ((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "meta") as! NSDictionary).value(forKey: "genre") as? String
            }
            else
            {
                cell.titletypwlabel.text = ""
            }
            
            
            var discriptiontext = (self.likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.desciptionlabel.text = discriptiontext
            var url = ((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail") as! NSDictionary).value(forKey: "medium") as! String
            url = Common.getsplitnormalimageurl(url: url)
            
            cell.imageview.setImageWith(URL(string: url)!, placeholderImage: UIImage.init(named: "Placehoder"))
            
            let videotime = (self.likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "duration") as? String
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
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let playerViewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        
        
        
        if(selectiontype == "watching")
        {
            
            
            
            if(Common.isNotNull(object: (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "Please Login to see video")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "Can't see upcoming video")
                        return
                    }
                    
                }
            }
            
            
            
            
            
            
            playerViewController.Video_url = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            playerViewController.descriptiontext = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.liketext = ((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! NSNumber).stringValue
            playerViewController.tilttext = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "no"
            
            playerViewController.Download_dic = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if Common.isNotNull(object: (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                playerViewController.downloadVideo_url = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            var ids = String()
            for i in 0..<((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                
                
                let str = ((watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (watchingdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
            
        }
        else if(selectiontype == "favorite")
        {
            
            
            if(Common.isNotNull(object: (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "Please Login to see video")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "Can't see upcoming video")
                        return
                    }
                    
                }
            }
            
            
            
            
            
            playerViewController.Video_url = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            playerViewController.descriptiontext = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.liketext = ((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! NSNumber).stringValue
            playerViewController.tilttext = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "no"
            playerViewController.Download_dic = (favdataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if Common.isNotNull(object: (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                playerViewController.downloadVideo_url = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            
            var ids = String()
            for i in 0..<((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                
                
                let str = ((favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (favdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
        }
        else if(selectiontype == "liked")
        {
            
            
            
            if(Common.isNotNull(object: (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "Please Login to see video")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "Can't see upcoming video")
                        return
                    }
                    
                }
            }
            
            
            playerViewController.Video_url = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "url") as! String
            playerViewController.descriptiontext = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            playerViewController.liketext = ((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes_count") as! NSNumber).stringValue
            playerViewController.tilttext = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            playerViewController.fromdownload = "no"
            playerViewController.Download_dic = (likedataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if Common.isNotNull(object: (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                
                playerViewController.downloadVideo_url = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "download_path") as! String
                
            }
            else
            {
                playerViewController.downloadVideo_url = ""
            }
            var ids = String()
            for i in 0..<((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).count
            {
                
                
                let str = ((likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                ids = ids + str + ","
                
            }
            ids = ids.substring(to: ids.index(before: ids.endIndex))
            playerViewController.catid = ids
            playerViewController.cat_id = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            playerViewController.favornot = (likedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "favorite") as! String
            if(Common.CheckUserloginandsubscribtion(viewcontrolerl: self))
            {
                self.navigationController?.pushViewController(playerViewController, animated: true)
            }
        }
        
        
    }
    
    
    func isNotNull(object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
    func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    func isNotStringNull(object:AnyObject) -> Bool {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        myscroll.contentInset = contentInsets
        myscroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        myscroll.contentInset = .zero
        myscroll.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

