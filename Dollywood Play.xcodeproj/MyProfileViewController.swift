//
//  MyProfileViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 15/07/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import FTPopOverMenu
import FormToolbar
import AFNetworking
import JCTagListView
import GooglePlacesSearchController
import Kingfisher
import SDWebImage
import PTPopupWebView
import MatomoTracker



class MyProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var myprofileimageview: UIImageView!
    @IBOutlet var name_txfield: UITextField!
    @IBOutlet var email_txfiled: UITextField!
    @IBOutlet var gender_txfiled: UITextField!
    @IBOutlet var genderlabel: UILabel!
    @IBOutlet var dob_tx: UITextField!
    @IBOutlet var contact_numbertx: UITextField!
    @IBOutlet var location_tx: UITextField!
    
 
    @IBOutlet weak var subscriptionheaderlabel: UILabel!
    @IBOutlet weak var Subscriptionview: UIView!
    @IBOutlet weak var freesubscriptionlabel: UILabel!
    
    @IBOutlet weak var scrollviewhghtcntrnt: NSLayoutConstraint!
    @IBOutlet weak var subscriptionheightcnstrnt: NSLayoutConstraint!
    var toolbar = FormToolbar()
    @IBOutlet var myscroolview: UIScrollView!
    @IBOutlet var Zonarbutton: UIButton!
    
    var datePickerView = UIDatePicker()
    var isprofileimagechange = Bool()
    var imagePicker = UIImagePickerController()
    var imagebase64str = String()
    var isprofilemakeupdate = Bool()
    
    @IBOutlet var UserIntresetedlabel: JCTagListView!
    let GoogleMapsAPIServerKey = "AIzaSyAG4YEhCbm63GjZyU_94vHsq8DBP4SWU_M"
    
    @IBOutlet weak var subscriptiontableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setprofiledata), name: NSNotification.Name(rawValue: "Updateprofiledata"), object: nil)
        name_txfield.maxLength = 20
        self.setbordercolor()
        isprofilemakeupdate = false
        Common.getRoundImage(imageView: myprofileimageview, radius: myprofileimageview.frame.size.height/2)
        myprofileimageview.contentMode = .scaleAspectFill
        isprofileimagechange = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        self.toolbar = FormToolbar(inputs: [name_txfield, email_txfiled, dob_tx,contact_numbertx,contact_numbertx,location_tx])
        UserIntresetedlabel.canSelectTags = true
        UserIntresetedlabel.tagSelectedTextColor = UIColor.black
        UserIntresetedlabel.tagCornerRadius = 5.0
        UserIntresetedlabel.layer.borderColor = UIColor.black.cgColor
        UserIntresetedlabel.layer.cornerRadius = 5.0
        UserIntresetedlabel.layer.borderWidth = 1.0
        UserIntresetedlabel.layer.masksToBounds = true
  
        // Do any additional setup after loading the view.
    }
    
    
    
    func setbordercolor()
    {
        Common.settextfieldborderwidth(textfield: name_txfield, borderwidth: 1.0)
        Common.settextfieldborderwidth(textfield: email_txfiled, borderwidth: 1.0)
        Common.settextfieldborderwidth(textfield: dob_tx, borderwidth: 1.0)
        Common.settextfieldborderwidth(textfield: contact_numbertx, borderwidth: 1.0)
        Common.settextfieldborderwidth(textfield: location_tx, borderwidth: 1.0)
        Common.setbuttonborderwidth(button: Zonarbutton, borderwidth: 1.0)
        Common.setuiviewdborderwidth(View: self.Subscriptionview, borderwidth: 1.0)
    }
    
    
    func Taptoinvoice(invoicebutton:UIButton) {
        
        let popupvc = PTPopupWebViewController()
        let subscription_dict = LoginCredentials.UserSubscriptiondetail.object(at: invoicebutton.tag) as! NSDictionary
        if let _  = subscription_dict.value(forKey: "invoice_url") {
            if(Common.isNotNull(object: subscription_dict.value(forKey: "invoice_url") as AnyObject)) {
                     let url = (subscription_dict.value(forKey: "invoice_url") as! String).url
                     popupvc.popupView.URL(url)
                     popupvc.show()
            }
        }
 
    }
    
    @IBAction func Taptoagegroup(_ sender: UIButton)
    {
        let agearry = ["Below 18", "18-24", "25-34","35-44","Above 45"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: agearry, doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.dob_tx.text = agearry[selectedIndex]
        }) {
            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
     {
         self.toolbar.update()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.navigationController?.isNavigationBarHidden = true
        if(!isprofilemakeupdate)
        {
            if(Common.Islogin())
            {
                self.setprofiledata()
            }
        }
        
    }
    
  
    func setprofiledata()
    {
        
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            print(dict)
            
            
            ///Set User Intreseted
            //
            //        let Userinseted = NSMutableArray()
            //
            //
            //         for i in 0..<(dict.value(forKey: "interest") as! NSArray).count {
            //
            //            let intreset = ((dict.value(forKey: "interest") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "title") as! String
            //            Userinseted.add(intreset)
            //
            //        }
            //
            //        UserIntresetedlabel.tags = Userinseted
            
            /// set email
            if(Common.isNotNull(object: dict.value(forKey: "email") as AnyObject?))
            {
                email_txfiled.text = dict.value(forKey: "email") as? String
            }
            else
            {
                email_txfiled.text = ""
            }
            //set name
            var name = String()
            
            if(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?))
            {
                name = dict.value(forKey: "first_name") as! String
            }
            else if(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?))
            {
                name = dict.value(forKey: "last_name") as! String
            }
            else if(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?) &&  Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?))
            {
                name = "\(dict.value(forKey: "first_name") as! String)\(" ")\(dict.value(forKey: "last_name") as! String)"
            }
            else
            {
                name = ""
            }
            
            
            name_txfield.text = name
            
            if(Common.isNotNull(object: dict.value(forKey: "gender") as AnyObject?))
            {
                
                gender_txfiled.text = dict.value(forKey: "gender") as? String
                
            }
            else
            {
                gender_txfiled.text = ""
                
            }
            if(Common.isNotNull(object: dict.value(forKey: "age_group") as AnyObject?))
            {
                if(dict.value(forKey: "age_group") as? String == "0-17")
                {
                    dob_tx.text = "Below 18"
                }
                else if(dict.value(forKey: "age_group") as? String == "45-70")
                {
                    dob_tx.text = "Above 45"
                }
                else
                {
                    dob_tx.text = dict.value(forKey: "age_group") as? String
                }
            }
            
            if(Common.isNotNull(object: dict.value(forKey: "contact_no") as AnyObject?))
            {
                contact_numbertx.text = dict.value(forKey: "contact_no") as? String
            }
            else
            {
                contact_numbertx.text = ""
            }
            
            if(Common.isNotNull(object: dict.value(forKey: "address") as AnyObject?))
                
            {
                location_tx.text = dict.value(forKey: "address") as? String
            }
            else
            {
                location_tx.text = ""
            }
            if Common.isNotNull(object: dict.value(forKey: "image") as AnyObject?)
            {
                
                var url =  dict.value(forKey: "image") as! String
                if(url == "")
                {
                    myprofileimageview.image = #imageLiteral(resourceName: "userprofile")
                }
                else
                {
                    
                    let urlImg = URL(string:url)
                    
                    // myprofileimageview.kf.setImage(with: urlImg)
                    myprofileimageview.sd_setImage(with: urlImg, placeholderImage: nil, options: .highPriority, completed: nil)
                    
                    
                    //                myprofileimageview.kf.setImage(with: urlImg,
                    //                                                    placeholder: nil,
                    //                                                    options: [.transition(ImageTransition.fade(1))],
                    //                                                    progressBlock: { receivedSize, totalSize in
                    //                },
                    //                                                    completionHandler: { image, error, cacheType, imageURL in
                    //                })
                }
            }
            else
            {
                myprofileimageview.image = UIImage.init(named: "userprofile")
            }
        }
        
        freesubscriptionlabel.isHidden = true
        hideallsubscriptiondetail()
        
      scrollviewhghtcntrnt.constant =  650
        
        
        print(LoginCredentials.Allusersubscriptiondetail)
        if(LoginCredentials.Allusersubscriptiondetail.count>0)
        {
            
            if let _ = LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days")
            {
                let freedatys = Int(LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days") as! String) as! Int
                print(freedatys)
                if(freedatys>0)
                {
                    freesubscriptionlabel.isHidden = false
                    freesubscriptionlabel.text = "\(LoginCredentials.Allusersubscriptiondetail.value(forKey: "free_days") as! String) free days"
                }
                else
                {
                    hideallsubscriptiondetail()
                }
            }
            else
            {
                hideallsubscriptiondetail()
            }
            
        }
        
        
        if(LoginCredentials.UserSubscriptiondetail.count>0)
        {
            let subscription_dict = LoginCredentials.UserSubscriptiondetail.object(at: 0) as! NSDictionary
            Subscriptionview.isHidden = false
            subscriptionheaderlabel.isHidden = false
            subscriptionheightcnstrnt.constant = CGFloat(100 * LoginCredentials.UserSubscriptiondetail.count)
            scrollviewhghtcntrnt.constant =  650 + CGFloat(100 * LoginCredentials.UserSubscriptiondetail.count)
            subscriptiontableview.reloadData()
            
        }
        
        
        
        
        
    }
    
    
    func hideallsubscriptiondetail()
    {
        Subscriptionview.isHidden = true
       subscriptionheaderlabel.isHidden = true
        subscriptionheightcnstrnt.constant = 0.0
        
    }
    @IBAction func TAptolocation(_ sender: UIButton)
    {
        
        let controller = GooglePlacesSearchController(
            apiKey: GoogleMapsAPIServerKey,
            placeType: PlaceType.address
        )
        controller.didSelectGooglePlace { (place) -> Void in
            print(place.description)
            self.location_tx.text = place.formattedAddress
            
            //Dismiss Search
            controller.isActive = false
        }
        
        present(controller, animated: true, completion: nil)
        
        
    }
    @IBAction func TAptoimage(_ sender: UIButton) {
        
        MatomoTracker.shared.track(eventWithCategory: "User", action: "click", name: "edit_profile_pic", value: 1)
        isprofilemakeupdate = true
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
    
    @IBAction func TaptosaveProfile(_ sender: UIButton) {
            MatomoTracker.shared.track(eventWithCategory: "User", action: "click", name: "edit_profile", value: 1)
        self.updateprofiledata()
    }
    
    @IBAction func Taptomenu(_ sender: UIButton) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func Taptogender(_ sender: UIButton) {
        
        let genderarray = ["Male", "Female"]
        FTPopOverMenu.show(forSender: sender, withMenuArray: genderarray, doneBlock: { (selectedIndex) in
            print(selectedIndex)
            self.gender_txfiled.text = genderarray[selectedIndex] as String
            
            
        }) {
            
        }
        
        
        
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
        dob_tx.resignFirstResponder() // To resign the inputView on clicking done.
    }
 
    func updateprofiledata()
    {

        var age = dob_tx.text
        var addresh = location_tx.text
        if(age == "Below 18")
        {
            age = "0-17"
        }
        else if(age == "Above 45")
        {
            age = "45-70"
        }
        
        if(age == "Age")
        {
            age = ""
        }
        if(addresh == "Location")
        {
            addresh = ""
        }
        if(Common.Islogin())
        {
            Common.startloder(view: self.view)
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            var parameters = [String : String]()
            self.view.endEditing(true)
            if(!isprofileimagechange)
            {
                parameters = [
                    "device": "ios",
                    "id": ((dict.value(forKey: "id") as! NSNumber).stringValue),
                    "first_name": name_txfield.text!,
                    "last_name": "",
                    "gender": gender_txfiled.text!,
                    "contact_no": contact_numbertx.text!,
                    "age_group": age!,
                    "ext": "",
                    "pic":"",
                    "address":addresh!
                ]
            }
            else
            {
                parameters = [
                    "device": "ios",
                    "id": ((dict.value(forKey: "id") as! NSNumber).stringValue),
                    "first_name": name_txfield.text!,
                    "last_name": "",
                    "gender": gender_txfiled.text!,
                    "contact_no": contact_numbertx.text!,
                    "age_group": age!,
                    "ext": "jpg",
                    "pic":imagebase64str,
                    "address":addresh!
                ]
            }
            
            print(parameters)
            let url = String(format: "%@%@", LoginCredentials.Editapi,Apptoken)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    Common.stoploder(view: self.view)
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                        EZAlertController.alert(title: "\(dict.value(forKey: "error") as! String)")
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
      
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
               
                Common.stoploder(view: self.view)
                 EZAlertController.alert(title: error.localizedDescription)
             }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login first to update profile")
            
        }
        
    }
    
    func converimagetobase64(image:UIImage)
    {
        // image.resizeByByte(maxByte: 100)
        let tmpData: NSData? = image.jpeg(.lowest) as NSData?
        imagebase64str = (tmpData?.base64EncodedString(options: .lineLength64Characters))!
        
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Common.getRoundImage(imageView: profileimage_view, radius: profileimage_view.frame.size.height/2)
            //profileimage_view.contentMode = .scaleAspectFit
            myprofileimageview.image = pickedImage
            isprofileimagechange = true
            myprofileimageview.image =  myprofileimageview.image?.fixOrientation()
            converimagetobase64(image: myprofileimageview.image!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
        isprofileimagechange = false
        
    }
    
    
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dob_tx.text = dateFormatter.string(from: sender.date)
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return LoginCredentials.UserSubscriptiondetail.count
    }
    // cell height
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       print(indexPath.row)
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[5] as! Custometablecell
        cell.selectionStyle = .none
        
        
        let subscription_dict = LoginCredentials.UserSubscriptiondetail.object(at: indexPath.row) as! NSDictionary
        cell.profileSubscriptionPkgname.text = (subscription_dict.value(forKey: "title") as! String)
         cell.profileSubscriptionamount.text =  "\("@ ")\(subscription_dict.value(forKey: "currency") as! String) \(" ")\(subscription_dict.value(forKey: "price") as! String)"
         if(subscription_dict.value(forKey: "package_type") as? String == "0") {
            cell.profileSubscriptionexpdate.text = ""
        }
        else{
             cell.profileSubscriptionexpdate.text = "\("Valid upto ") \(subscription_dict.value(forKey: "subscription_end") as! String)"
        }
        
        
        Common.setuiviewdborderwidth(View: cell.profilesubscriptioncellview, borderwidth: 1.0)
        Common.getRounduibutton(button: cell.profileSubscriptioninvoicebutton, radius: 5.0)
        Common.setbuttonborderwidth(button: cell.profileSubscriptioninvoicebutton, borderwidth: 1.0)
        
         if(Common.isNotNull(object: (subscription_dict.value(forKey: "invoice_url") as! String as AnyObject))) {
            let url = (subscription_dict.value(forKey: "invoice_url") as! String)
            if(url == "")
            {
                cell.profileSubscriptioninvoicebutton.isHidden = true
            }
            else
            {
                cell.profileSubscriptioninvoicebutton.isHidden = false
        
               
            }
            
        }
        else
        {
            cell.profileSubscriptioninvoicebutton.isHidden = true
        }
        cell.profileSubscriptioninvoicebutton.tag = indexPath.row
        
        if let _  = subscription_dict.value(forKey: "invoice_url") {
            if(Common.isNotNull(object: subscription_dict.value(forKey: "invoice_url") as AnyObject)) {
                let url = subscription_dict.value(forKey: "invoice_url") as! String
                cell.profileSubscriptioninvoicebutton.addTarget(self, action: #selector(Taptoinvoice(invoicebutton:)), for: .touchUpInside)
             }
            
        }
        
        return cell
        
    }
    

    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        myscroolview.contentInset = contentInsets
        myscroolview.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        myscroolview.contentInset = .zero
        myscroolview.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
