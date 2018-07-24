//
//  Custometablecell.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 19/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit

class Custometablecell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var titletypwlabel: UILabel!
    @IBOutlet weak var desciptionlabel: UILabel!
    @IBOutlet var timerview: UIView!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var cellouterview: UIView!
    
    /////////////Channel IBOutlet
    
    @IBOutlet weak var Channelimageview: UIImageView!
    @IBOutlet weak var channelnamelabel: UILabel!
    @IBOutlet weak var chaneelDeslabel: UILabel!
    @IBOutlet weak var channelvideoCount: UILabel!
    @IBOutlet weak var cnoofvideolabel: UILabel!
    
    
    //////Comment_view outlate
    @IBOutlet weak var abusebutton: UIButton!
    @IBOutlet weak var commentuserimageview: UIImageView!
    @IBOutlet weak var commentnamelabel: UILabel!
    @IBOutlet weak var commentdes_label: UILabel!
    @IBOutlet weak var commenttimelabel: UILabel!
    
    
    //////Subscription outlate
    @IBOutlet weak var subscriptionview: UIView!
    @IBOutlet weak var subscriptionname: UILabel!
    @IBOutlet weak var subscriptionprice: UILabel!
    @IBOutlet weak var subscriptiondatelabel: UILabel!
    @IBOutlet weak var issubscribebutton: UIButton!
    @IBOutlet weak var subscriptioncellbutton: UIButton!
    //////Free Trail video outlate
    
    @IBOutlet weak var freetrailouterview: UIView!
    
    //////Autosuggstion in searchview outlate
    @IBOutlet weak var Autosuggestontitle: UILabel!
    
    
    /////Subscription Package Call
    
    @IBOutlet weak var profileSubscriptionPkgname: UILabel!
    @IBOutlet weak var profileSubscriptionexpdate: UILabel!
    @IBOutlet weak var profileSubscriptionamount: UILabel!
    @IBOutlet weak var profileSubscriptioninvoicebutton: UIButton!
    @IBOutlet weak var profilesubscriptioncellview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
