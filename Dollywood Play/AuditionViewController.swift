//
//  AuditionViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 05/09/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import AFNetworking
import FormToolbar


class AuditionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableviewhightcontanr: NSLayoutConstraint!
    @IBOutlet weak var scrollviewheightcontrant: NSLayoutConstraint!
    @IBOutlet weak var mytableview: UITableView!
    
    @IBOutlet weak var name_tx: UITextField!
    @IBOutlet weak var email_tx: UITextField!
    @IBOutlet weak var mobileno_tx: UITextField!
    @IBOutlet weak var description_txview: UITextView!
    
    var imagePicker = UIImagePickerController()
    let imagearray = NSMutableArray()
    var imageurlArray = NSMutableArray()
    var toolbar = FormToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        description_txview.textColor = UIColor.lightGray
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        setui()
        // Do any additional setup after loading the view.
    }

    
    func setui() {
        
        self.toolbar = FormToolbar(inputs: [name_tx, email_tx,mobileno_tx,description_txview])
        name_tx.setLeftPaddingPoints(5)
        email_tx.setLeftPaddingPoints(5)
        mobileno_tx.setLeftPaddingPoints(5)
        
        Common.setuiviewdbordercolor(View: name_tx, borderwidth: 1.0, bordercolor: .white)
        Common.getRounduiview(view: name_tx, radius: 10.0)
        
        Common.setuiviewdbordercolor(View: email_tx, borderwidth: 1.0, bordercolor: .white)
        Common.getRounduiview(view: email_tx, radius: 10.0)
        
        Common.setuiviewdbordercolor(View: mobileno_tx, borderwidth: 1.0, bordercolor: .white)
        Common.getRounduiview(view: mobileno_tx, radius: 10.0)
        
        Common.setuiviewdbordercolor(View: description_txview, borderwidth: 1.0, bordercolor: .white)
        Common.getRounduiview(view: description_txview, radius: 10.0)
        
        Common.setuiviewdbordercolor(View: mytableview, borderwidth: 1.0, bordercolor: .white)
        Common.getRounduiview(view: mytableview, radius: 10.0)
        
    }
    
    
    @IBAction func Taptouploadimage(_ sender: UIButton) {
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
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        var name = "Demo"
        let ticks = Date().ticks
        print(ticks)
        print(ticks.description)
        name = ticks.description

         if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadimageonaws(uploadimage: pickedImage, name: name)
            imagearray.add("\(name).jpg")
             let imagename  = "https://s3-ap-south-1.amazonaws.com/s3-yuv/Audition/\(name).jpg"
            let dict = ["url" : imagename]
            imageurlArray.add(dict)
            tableviewhightcontanr.constant = CGFloat(imagearray.count * 74)
            scrollviewheightcontrant.constant = 660 + tableviewhightcontanr.constant
            mytableview.reloadData()
            
          }
        dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }

    func uploadimageonaws(uploadimage:UIImage,name:String) {
        
        let accessKey = "AKIAICDJB6PNXRFFII5Q"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region:AWSRegionType.APSouth1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let S3BucketName = "s3-yuv/Audition"
        let remoteName = "\(name).jpg"
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        let data = UIImageJPEGRepresentation(uploadimage, 0.9)
        do {
            try data?.write(to: fileURL)
        }
        catch {}
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.body = fileURL
        uploadRequest.key = remoteName
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.acl = .publicRead
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { [weak self] (task) -> Any? in
            DispatchQueue.main.async {
             }
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                if let absoluteString = publicURL?.absoluteString {
                    print("Uploaded to:\(absoluteString)")
                  }
            }
            
            return nil
        }
        
    }
    
    
    func deletefilefromaws(name:String,index:Int) {
        
        print(self.imageurlArray)
        self.imageurlArray.remove(at: index)
        print(self.imageurlArray)
        let s3 = AWSS3.default()
        let deleteObjectRequest = AWSS3DeleteObjectRequest()
        deleteObjectRequest?.bucket = "s3-yuv/Audition"
        deleteObjectRequest?.key = name
        s3.deleteObject(deleteObjectRequest!).continueWith { (task:AWSTask) -> AnyObject? in
            if let error = task.error {
                print("Error occurred: \(error)")
                return nil
            }
            print("Deleted successfully.")
              return nil
        }
    }
    
    
    @IBAction func taptoback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
     }
    @IBAction func Taptosubmit(_ sender: UIButton) {
        let trimmedString = email_tx.text?.trimmingCharacters(in: .whitespaces)

        print(description_txview.text)
        if(!Common.Islogin()) {
            EZAlertController.alert(title: "Please Login To Submit Audition")
            return
        }
        
         if(!Common.isEmptyOrWhitespace(testStr: name_tx.text!)) {
            EZAlertController.alert(title: "Please enter name")
            return
        }
        else if(!Common.isValidEmail(testStr: trimmedString!)) {
            EZAlertController.alert(title: "Please enter valid email")
            return
        }
        if(!Common.isEmptyOrWhitespace(testStr: mobileno_tx.text!)) {
            EZAlertController.alert(title: "Please enter mobile")
            return
        }
        if(!Common.isEmptyOrWhitespace(testStr: description_txview.text!) || description_txview.text == "Brief") {
            EZAlertController.alert(title: "Please enter description")
            return
        }
        submitapi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func delete(button: UIButton) {
        
        let filename = imagearray.object(at: button.tag)
        let alert = UIAlertController(title: title, message: "Are You Sure Delete file image_ \(button.tag+1)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
             self.imagearray.removeObject(at: button.tag)
            self.tableviewhightcontanr.constant = CGFloat(self.imagearray.count * 60)
            self.scrollviewheightcontrant.constant = 660 + self.tableviewhightcontanr.constant
            if(self.imagearray.count == 0) {
                self.tableviewhightcontanr.constant = 0.0
                self.scrollviewheightcontrant.constant = 660
            }
            self.mytableview.reloadData()
            self.deletefilefromaws(name: filename as! String, index: button.tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        print(imagearray.object(at: button.tag))
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 74
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imagearray.count
    }
    // cell height
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[6] as! Custometablecell
        cell.Imagename.text = "image_\(indexPath.row+1)"
        cell.deleteimagebutton.tag = indexPath.row
        cell.deleteimagebutton.addTarget(self, action: #selector(delete(button:)), for: .touchUpInside)

         return cell
        
    }
    
 
    func textViewDidBeginEditing(_ textView: UITextView) {
         self.toolbar.update()
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Brief"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.toolbar.update()
    }
    

    func submitapi() {
         self.view.endEditing(true)
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
       Common.startloder(view: self.view)
                   let parameters  = [
                        "userid": ((dict.value(forKey: "id") as! NSNumber).stringValue),
                        "name": name_tx.text!,
                        "email":email_tx.text!,
                        "phone":mobileno_tx.text!,
                        "description": description_txview.text,
                        "image": Common.convertarrayinyijasondata(data: imageurlArray)
                        ] as [String : Any]
               print(parameters)
        print(LoginCredentials.Feedbackapi)
                let url = String(format: "%@%@", LoginCredentials.Feedbackapi,Apptoken)
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
                        
                        self.clearalltx()
                        let alert = UIAlertController(title: "Feedback submitted successfully", message: "", preferredStyle: UIAlertControllerStyle.alert)
                         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
                            self.dismiss(animated: true, completion: nil)
                          }))
                         self.present(alert, animated: true, completion: nil)
                 
                    }
                }) { (task: URLSessionDataTask?, error: Error) in
                    print("POST fails with error \(error)")
                    Common.stoploder(view: self.view)
                    EZAlertController.alert(title: error.localizedDescription)
                }
            }
    
    
    func clearalltx() {
        name_tx.text = ""
        email_tx.text = ""
        mobileno_tx.text = ""
        description_txview.text = "Brief"
        imageurlArray.removeAllObjects()
        imagearray.removeAllObjects()
        self.mytableview.reloadData()
        tableviewhightcontanr.constant = 0
        scrollviewheightcontrant.constant = 660
     }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y = -20
        //  myscroll.contentInset = contentInsets
        // myscroll.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0.0
        // myscroll.contentInset = .zero
        //  myscroll.scrollIndicatorInsets = .zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
