//
//  CarouselPagerView.swift
//  Image Carousel
//
//  Created by Roberto Rumbaut on 8/8/16.
//  Copyright © 2016 Roberto Rumbaut. All rights reserved.
//

import UIKit

protocol ImageCarouselViewDelegate {
    func scrolledToPage(_ page: Int)
    
    func clickonpage(_ page: Int)
}

@IBDesignable
class ImageCarouselView: UIView {
    
    var delegate: ImageCarouselViewDelegate?
    var timer:Timer!
    var coresalwidth = CGFloat()
    
    
    @IBInspectable var showPageControl: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var pageControlMaxItems: Int = 10 {
        didSet {
            setupView()
        }
    }
    var pageLabel = UILabel()
    
    var carouselScrollView: UIScrollView!
    var textarray = NSMutableArray()
    var statusarray = NSMutableArray()
    var textarraydes = NSMutableArray()
    var imageurlarry = NSMutableArray()
    var episodearray = NSMutableArray()
        {
        didSet {
            setupView()
        }
    }
    
    var images = [UIImage]() {
        didSet {
            setupView()
        }
    }
    
    var pageControl = UIPageControl()
    
    var currentPage: Int! {
        return Int(round(carouselScrollView.contentOffset.x / self.bounds.width))
    }
    
    @IBInspectable var pageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var currentPageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        for view in subviews {
            view.removeFromSuperview()
        }
        carouselScrollView = UIScrollView(frame: bounds)
        carouselScrollView.showsHorizontalScrollIndicator = false
        
        addImages()
        
        if showPageControl {
            addPageControl()
            carouselScrollView.delegate = self
        }
    }
    
    func update()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }
        
        
        if(currentPage == imageurlarry.count-1)
        {
            coresalwidth = 0
            carouselScrollView.contentOffset.x = 0
            
        }
        else
        {
            coresalwidth = (carouselScrollView.contentSize.width / CGFloat(imageurlarry.count)) + coresalwidth
            carouselScrollView.scrollRectToVisible(CGRect.init(x: coresalwidth, y: carouselScrollView.contentOffset.y, width: bounds.width, height: carouselScrollView.contentSize.height), animated: true)
            
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
        
    }
    func addImages() {
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.contentSize = CGSize(width: bounds.width * CGFloat(imageurlarry.count), height: bounds.height)
          print(textarray)
          print(textarraydes)
          print(episodearray)
        for i in 0..<imageurlarry.count {
            let imageView = UIImageView(frame: CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height))
            print(episodearray)
            if(Common.isNotNull(object: imageurlarry.object(at: i) as AnyObject?))
            {
                
            let url = imageurlarry.object(at: i) as! URL
             imageView.setImageWith(url)
            }
            else
            {
               imageView.image = #imageLiteral(resourceName: "Placehoder1")
            }
            //  imageView.image = images[i]
            imageView.contentMode = .scaleToFill
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            
            ////////make upcoming label////////////
             let upcominglabel = UILabel.init(frame: CGRect.init(x: ((bounds.width * CGFloat(i))+10), y: 10, width: 70, height: 20))
            upcominglabel.backgroundColor = UIColor.black
            upcominglabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(11))
            upcominglabel.textColor = UIColor.white
            Common.getRoundLabel(label: upcominglabel, borderwidth: 10.0)
            upcominglabel.layer.borderColor=UIColor.white.cgColor
            upcominglabel.layer.borderWidth=1.0
          
            upcominglabel.textAlignment = .center
            
            
            

            if((statusarray.object(at: i) as! String) == "0")
            {
                upcominglabel.isHidden = true
              
            }
            else if((statusarray.object(at: i) as! String) == "1")
            {
                upcominglabel.text = "LIVE"
                upcominglabel.isHidden = false
               
            }
            else if((statusarray.object(at: i) as! String) == "2")
            {
                upcominglabel.text = "UPCOMING"
                upcominglabel.isHidden = false
            }
            
            
            ////////end upcoming label////////////
            
            
            let label = UILabel.init(frame: CGRect.init(x: ((bounds.width * CGFloat(i))+50), y: bounds.height-70, width: bounds.width-50, height: 50))
            let label1 = UILabel.init(frame: CGRect.init(x: ((bounds.width * CGFloat(i))+50), y: label.frame.origin.y+15, width: bounds.width-50, height: 50))
            let label2 = UILabel.init(frame: CGRect.init(x: ((bounds.width * CGFloat(i))+50), y: label1.frame.origin.y+15, width: bounds.width-50, height: 50))
            label.text = textarray.object(at: i) as? String
            label.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
            label.textColor = UIColor.white
            label.numberOfLines = 1
            label1.text = textarraydes.object(at: i) as? String
            label1.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(18))
            label1.textColor = UIColor.white
            label1.numberOfLines = 1
            if(episodearray.object(at: i) as? String == "0" || episodearray.object(at: i) as? String == "")
            {
             label2.text = ""
            }
            else
            {
            label2.text = "\("Episode ")\(episodearray.object(at: i) as! String)"
            }
            label2.font = UIFont(name: "HelveticaNeue", size: CGFloat(15))
            label2.textColor = UIColor.white
            label2.numberOfLines = 1
            //imageView.addSubview(label)
            var playerimageview = UIImageView()
            
            if(textarraydes.object(at: i) as? String == "" && episodearray.object(at: i) as? String == "")
            {
               playerimageview = UIImageView(frame: CGRect.init(x: bounds.width * CGFloat(i) + 25, y: bounds.height-55, width: 20, height: 20))
            }
           else if(textarraydes.object(at: i) as? String == "")
            {
             
                label.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(18))
                playerimageview = UIImageView(frame: CGRect.init(x: bounds.width * CGFloat(i) + 25, y: bounds.height-45, width: 20, height: 20))
            }
            else
            {
                playerimageview = UIImageView(frame: CGRect.init(x: bounds.width * CGFloat(i) + 25, y: bounds.height-40, width: 20, height: 20))
            }
            playerimageview.image = UIImage.init(named: "Newplayicon")
            let gradiantimageview = UIImageView(frame: CGRect.init(x: bounds.width * CGFloat(i), y: bounds.height-35, width: bounds.width, height: 35))
            gradiantimageview.image = UIImage.init(named:"coresalgradiant")
            
            
            let button = UIButton(frame: CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height))
            button.addTarget(self, action: #selector(clickoncoresal), for: .touchUpInside)
            
            
            carouselScrollView.addSubview(imageView)
            carouselScrollView.addSubview(playerimageview)
            carouselScrollView.addSubview(gradiantimageview)
            carouselScrollView.addSubview(label)
            carouselScrollView.addSubview(label1)
            carouselScrollView.addSubview(label2)
            carouselScrollView.addSubview(button)
            carouselScrollView.addSubview(upcominglabel)
            print("Added")
        }
        
        self.addSubview(carouselScrollView)
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
    }
    
    
    func taptocoresal()
    {
        
    }
    
    func addPageControl() {
        if imageurlarry.count <= pageControlMaxItems {
            pageControl.numberOfPages = imageurlarry.count
            pageControl.sizeToFit()
            pageControl.currentPage = 0
            pageControl.center = CGPoint(x: self.center.x, y: bounds.height  - 8)
            
            if let pageColor = self.pageColor {
                pageControl.pageIndicatorTintColor = pageColor
            }
            if let currentPageColor = self.currentPageColor {
                pageControl.currentPageIndicatorTintColor = currentPageColor
            }
            
            self.addSubview(pageControl)
        } else {
            pageLabel.text = "1 / \(imageurlarry.count)"
            pageLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightLight)
            pageLabel.frame.size = CGSize(width: 40, height: 20)
            pageLabel.textAlignment = .center
            pageLabel.layer.cornerRadius = 10
            pageLabel.layer.masksToBounds = true
            pageLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            pageLabel.textColor = UIColor.white
            pageLabel.center = CGPoint(x: self.center.x, y: bounds.height - pageLabel.bounds.height/2 - 8)
            
            self.addSubview(pageLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
}

extension ImageCarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = self.currentPage
        self.pageLabel.text = "\(self.currentPage+1) / \(imageurlarry.count)"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrolledToPage(self.currentPage)
    }
    
    func clickoncoresal(_ scrollView: UIScrollView)
    {
        self.delegate?.clickonpage(self.currentPage)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickoncoresal"), object: self.currentPage)
        
    }
    
}
