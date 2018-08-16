
//
//  PlayerViewController.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 23/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import MXSegmentedPager
import AFNetworking
import AVKit
import AVFoundation
import M3U8Kit2
import Photos
import PhotosUI
import SwiftMessages
import Fuzi
import SAVASTParser
import SAJsonParser
import SAVideoPlayer
import SANetworking
import SAUtils
import SAModelSpace
import CoreTelephony
import AARatingBar
import FormToolbar
import Pantomime
import Kingfisher
import GoogleInteractiveMediaAds
import KRPullLoader
import GoogleCast
import Sugar
import Toast_Swift

var kPrefMediaListURL: String = "media_list_url"





enum PlaybackMode: Int {
    case none = 0
    case local
    case remote
}



class PlayerViewController: UIViewController,MXSegmentedPagerDataSource,MXSegmentedPagerDelegate,UIActionSheetDelegate,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,IMAAdsLoaderDelegate, IMAAdsManagerDelegate,AVPictureInPictureControllerDelegate, GCKSessionManagerListener,
GCKRemoteMediaClientListener, GCKRequestDelegate  {
    
    @IBOutlet var scrollviewheighltcontrant: NSLayoutConstraint!
    @IBOutlet weak var myscroll: UIScrollView!
    @IBOutlet weak var myscroolview: UIView!
    @IBOutlet weak var titlenamelabel: UILabel!
    @IBOutlet weak var likelabel: UILabel!
    @IBOutlet var dislikelabel: UILabel!
    
    @IBOutlet var expenddownarroe: UIButton!
    @IBOutlet weak var contantdiscriptionlabel: UILabel!
    @IBOutlet weak var expandbutton: UIButton!
    @IBOutlet weak var downloadbutton: UIButton!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet var dislikebutton: UIButton!
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var Resolutionbutton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet weak var forword10secbutton: UIButton!
    @IBOutlet weak var forwardbutton: UIButton!
    @IBOutlet weak var backwordbutton: UIButton!
    @IBOutlet weak var backwordbuttonuppercnstraint: NSLayoutConstraint!
    @IBOutlet weak var discriptionlabeheightcontraint: NSLayoutConstraint!
    @IBOutlet var downloadprogressimghgtcnsrnt: NSLayoutConstraint!
    @IBOutlet var dwnldprgswdthconstrant: NSLayoutConstraint!
    
    @IBOutlet weak var Bottomviewuppercnstraint: NSLayoutConstraint!
    @IBOutlet var totalviewlabel: UILabel!
    @IBOutlet var notificationbutton: UIButton!
    @IBOutlet var Mycollectionview: UICollectionView!
    
    @IBOutlet var newcommentview: UIView!
    @IBOutlet var newcommentviewhightconstrant: NSLayoutConstraint!
    @IBOutlet var commenttextview: UITextView!
    @IBOutlet var commenttextviewhghtconstrant: NSLayoutConstraint!
    
    @IBOutlet weak var Favroutbutton: UIButton!
    var Video_url = String()
    var Dfp_url = String()
    var tilttext = String()
    var liketext = String()
    var descriptiontext = String()
    var cat_id = String()
    var catid = String()
    var cat_idarray = NSArray()
    var likeornot = String()
    var favornot = String()
    var mXSegmentedPager = MXSegmentedPager()
    var downloadVideo_url = String()
    var shareurlnew = String()
    var fromdownload = String()
    var Download_dic:NSMutableDictionary=NSMutableDictionary()
    var Channeldict:NSDictionary=NSDictionary()
    var Isfromdeeplinking:Bool = false
    var Nextvideoindex:Int = 0
    
    var singletap = UITapGestureRecognizer()
    var videoPlayer:AVPlayer!
    var lblEnd:UILabel = UILabel()
    var avLayer:AVPlayerLayer!
    var timer:Timer!
    var bEnlarge:Bool = Bool()
    var playbackSlider:UISlider!
    var soundbackSlider:UISlider!
    var lblLeft:UILabel = UILabel()
    var securitylabel:UILabel = UILabel()
    var tempView:UIView!
    var soundcontrolbutton:UIButton = UIButton()
    var expandBtn:UIButton = UIButton()
    var Skipbutton:UIButton = UIButton()
    var bFirstTime:Bool = Bool()
    var enlargeBtn:UIButton = UIButton()
    var settingbutton:UIButton = UIButton()
    var enlargeBtnLayer:UIButton = UIButton()
    var activityIndicator:UIActivityIndicatorView=UIActivityIndicatorView()
    var bPlay:Bool = Bool()
    var bHideControl:Bool = Bool()
    var bSlideBar:Bool = Bool()
    var checkcontantenable:Bool = Bool()
    var isshowmore:Bool = Bool()
    var moredataarray = NSArray()
    var recomdentdedataarray = NSArray()
    var ismore:Bool = Bool()
    var islike:Bool = Bool()
    var isfav:Bool = Bool()
    var isdislike:Bool = Bool()
    var videoresoulationtypearray:NSMutableArray=NSMutableArray()
    var videoresoulationurlarray:NSMutableArray=NSMutableArray()
    
    var midrolequepointarray = NSArray()
    var midroleurl = String()
    var toolbar = FormToolbar()
    var securitykeytimer: Timer!
    
    @IBOutlet var channelview: UIView!
    @IBOutlet var chanelimageview: UIImageView!
    @IBOutlet var progressdownloadimageview: UIImageView!
    @IBOutlet var chanelname: UILabel!
    @IBOutlet var chaneelsubscribebutton: UIButton!
    
    @IBOutlet var ratingview: UIView!
    @IBOutlet var inratingview: UIView!
    @IBOutlet var cancelratingbutton: UIButton!
    @IBOutlet var submitratingbutton: UIButton!
    @IBOutlet var showratingbar: AARatingBar!
    @IBOutlet var submitratingbar: AARatingBar!
    
    @IBOutlet var commentbottomview: UIView!
    @IBOutlet var Commentview: UIView!
    @IBOutlet var commenttableview: UITableView!
    @IBOutlet var comment_tx: UITextField!
    var commentdataarray = NSMutableArray()
    var Iscommentloadmore:Bool = Bool()
    var nextcommenturl = String()
    
    
    
    ////Download Video File////////
    
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    ////sav parser
    var Event_dict:NSDictionary=NSDictionary()
    var isplayadd:Bool = Bool()
    var skiptimer = Timer()
    var skiptime:Int = 0
    var vastarray = NSArray()
    var ismidrolepresent:Bool = Bool()
    var isprerole:Bool = Bool()
    var midroletime = Float()
    var totalvideoDurationtime = Float()
    var likecount = Int()
    var dislikecount = Int()
    
    var channeldetaildict = NSMutableDictionary()
    var ischnlsucribe:Bool = Bool()
    var ischnlnotificationsubcribed:Bool = Bool()
    
    var chnl_id = String()
    var isviewwillappear:Bool = Bool()
    
    var Playeraddtime:Timer!
    var toast = JYToast()
    var seletetedresoltionindex:Int = 0
    var Isendcomment:Bool = Bool()
    
    let volume = SubtleVolume(style: .plain)
    
    //////////////Google Ima Object////////
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?
    // IMA SDK handles.
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    var companionSlot: IMACompanionAdSlot?
    var isplaydfturl:Bool = Bool()
    
    
    ///////////Google CAST
    private var sessionManager: GCKSessionManager!
    private var castSession: GCKCastSession?
    private var castMediaController: GCKUIMediaController!
    private var volumeController: GCKUIDeviceVolumeController!
    private var streamPositionSliderMoving: Bool = false
    private var playbackMode = PlaybackMode.none
    private var queueButton: UIBarButtonItem!
    private var showStreamTimeRemaining: Bool = false
    private var localPlaybackImplicitlyPaused: Bool = false
    private var actionSheet: ActionSheet?
    private var queueAdded: Bool = false
    private var gradient: CAGradientLayer!
    @IBOutlet var castButton: GCKUICastButton!
    var mediaList: MediaListModel?
    var cromecastimageurl = String()
    var cromecastplayerurl = String()
    var isplaycromecast:Bool = Bool()
    
    /* Whether to reset the edges on disappearing. */
    var isResetEdgesOnDisappear: Bool = false
    // The media to play.
    var mediaInfo: GCKMediaInformation? {
        didSet {
            print("setMediaInfo")
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.sessionManager = GCKCastContext.sharedInstance().sessionManager
        self.castMediaController = GCKUIMediaController()
        self.volumeController = GCKUIDeviceVolumeController()
        
    }
    
    
    
    
    override func viewDidLoad()
    {
        checkcontantenable = true
        super.viewDidLoad()
        if(!checkinterconnection())
        {
            return
        }
        
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopdownloadprogress), name: NSNotification.Name(rawValue: "CancelDownloading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backactionnotofication), name: NSNotification.Name(rawValue: "backactionnotofication"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(Taptoback), name: NSNotification.Name(rawValue: "Pushback"), object: nil)
 
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        backgroundSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
        /////GOOGLE CAST
        NotificationCenter.default.addObserver(self, selector: #selector(self.castDeviceDidChange),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener), name: .AVAudioSessionRouteChange, object: nil)
        
        
        self.setmenu()
        self.getplayerurl()
        commenttableview.separatorColor = UIColor.gray
        LoginCredentials.ischaneelviewappear = true
        LoginCredentials.Videoid = cat_id
        
        ///new comment secttion
        commenttextview.delegate = self
        newcommentview.layer.borderWidth = 1.0
        newcommentview.layer.borderColor = UIColor.white.cgColor
        newcommentview.clipsToBounds = true
        
        commenttableview.estimatedRowHeight = 43.0
        commenttableview.rowHeight = UITableViewAutomaticDimension
        LoginCredentials.Ispressback = false
        // Do any additional setup after loading the view.
        
        
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        commenttableview.addPullLoadableView(refreshView, type: .loadMore)
        isplaycromecast = false
        
        ///Add vOlume
        
        volume.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 0)
        view.addSubview(volume)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.isNavigationBarHidden = true
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.perform(#selector(callrotationaftercast), with: self, afterDelay: 1)
        
        
        //////GOOGLE CAST
        print("viewWillAppear; mediaInfo is \(String(describing: self.mediaInfo)), mode is \(self.playbackMode)")
        appDelegate?.isCastControlBarsEnabled = true
        // but now have a session, then switch to remote playback mode.
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode != .remote) {
            self.switchToRemotePlayback()
        } else if (self.sessionManager.currentSession == nil) && (self.playbackMode != .local) {
            self.switchToLocalPlayback()
        }
        
        self.sessionManager.add(self)
        
        
        
        
        if(self.videoPlayer != nil)
        {
            if(isplaydfturl)
            {
                if(isplaycromecast)
                {
                    self.videoPlayer.pause()
                }
                else
                {
                    bPlay = true
                    expandBtnAction()
                }
                
            }
            else
            {
                
                if(isplaycromecast)
                {
                    self.videoPlayer.pause()
                }
                else
                {
                    bPlay = true
                    expandBtnAction()
                    
                }
                
            }
        }
        
        
        if(LoginCredentials.ischaneelviewappear)
        {
            isshowmore = false
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
            
            ismore = true
            if(!Common.isInternetAvailable())
            {
                
                self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
                self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
                
            }
            else
            {
                self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
            }
        }
        else
        {
            
            LoginCredentials.ischaneelviewappear = true
        }
        
        
    }
    
    
    func willResignActive(_ notification: Notification) {
        
        
        
        if(isplaycromecast)
        {
            
        }
        else
        {
            
            
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                
                self.expandBtn.isHidden = true
                self.isplayorpause()
            }
        }
        // code to execute
    }
    
    
    
    func audioRouteChangeListener(notification: Notification) {
        
        
        if(isplaycromecast)
        {
            
        }
        else
        {
            
            guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? Int else { return }
            
            switch audioRouteChangeReason {
                
            case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
                //plugged out
                
                if(self.videoPlayer == nil)
                {
                    
                }
                else
                {
                    self.expandBtn.isHidden = true
                    self.isplayorpause()
                    
                }
                break
                
            default:
                break
                
            }
        }
    }
    
    
    func castDeviceDidChange(_ notification: Notification) {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
            // You can present the instructions on how to use Google Cast on
            // the first time the user uses you app
            GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce()
        }
    }
    
    
    
    func getcromecasturl()
    {
        let url = String(format: "%@%@", LoginCredentials.Chromecastapi,Apptoken)
        var parameters = [String:String]()
        parameters = [
            "device": "ios",
            "secure": "1",
            "cid":cat_id
        ]
        print(url)
        
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                var detaildict = NSMutableDictionary()
                detaildict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                print(detaildict)
                self.cromecastplayerurl = detaildict.value(forKey: "url") as! String
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails Cromecast with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
    }
    
    
    func callrotationaftercast()
    {
        forcefullylandscape()
        self.rotateddd()
        
    }
    
    @IBAction func taptocast(_ sender: Any) {
        
        //self.perform(#selector(callrotationaftercast), with: self, afterDelay: 1)
        forcefullylandscape()
        self.rotateddd()
        
        if(!(Common.isNotNull(object: cromecastplayerurl as AnyObject)  || (cromecastplayerurl == "" )))
        {
            return
        }
        
        if(videoresoulationurlarray.count<1 )
        {
            return
        }
        
        bPlay = false
        expandBtnAction()
        // self.tempView.isUserInteractionEnabled = false
        // AppUtility.lockOrientation(.portrait)
        loadMediaList1()
        
    }
    
    
    
    func stopplayerifcastingenable()
    {
        
        bPlay = false
        expandBtnAction()
        self.playbackSlider.isUserInteractionEnabled = false
        self.enlargeBtn.isUserInteractionEnabled = false
        self.enlargeBtnLayer.isUserInteractionEnabled = false
        backwordbutton.isUserInteractionEnabled = false
        forwardbutton.isUserInteractionEnabled = false
        forword10secbutton.isUserInteractionEnabled = false
        Resolutionbutton.isUserInteractionEnabled = false
        self.expandBtn.isUserInteractionEnabled = false
        self.soundcontrolbutton.isUserInteractionEnabled = false
        soundbackSlider.isUserInteractionEnabled = false
        settingbutton.isUserInteractionEnabled = false
    }
    
    
    func resumeplayerifcastingdisable()
    {
        
        bPlay = true
        expandBtnAction()
        self.playbackSlider.isUserInteractionEnabled = true
        self.enlargeBtn.isUserInteractionEnabled = true
        self.enlargeBtnLayer.isUserInteractionEnabled = true
        backwordbutton.isUserInteractionEnabled = true
        forwardbutton.isUserInteractionEnabled = true
        forword10secbutton.isUserInteractionEnabled = true
        Resolutionbutton.isUserInteractionEnabled = true
        self.expandBtn.isUserInteractionEnabled = true
        self.soundcontrolbutton.isUserInteractionEnabled = true
        soundbackSlider.isUserInteractionEnabled = true
        settingbutton.isUserInteractionEnabled = true
        
    }
    
    
    
    
    
    
    func loadMediaList() {
        self.stoploader()
        // Look up the media list URL.
        
        
        isplaycromecast = true
        let metadata = GCKMediaMetadata()
        metadata.setString(tilttext, forKey: kGCKMetadataKeyTitle)
        metadata.setString(descriptiontext,
                           forKey:kGCKMetadataKeySubtitle)
        let url = NSURL(string:self.cromecastimageurl)
        metadata.addImage(GCKImage(url: url as! URL, width: 480, height: 360))
        
        mediaInfo =  GCKMediaInformation(
            contentID:
            videoresoulationurlarray.object(at: videoresoulationurlarray.count-2) as! String,
            streamType: GCKMediaStreamType.none,
            contentType: "video/mp4",
            
            
            metadata: metadata,
            streamDuration: 0,
            mediaTracks: [],
            textTrackStyle: nil,
            customData: nil
        )
        
        
        
        
        //        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        //        if hasConnectedSession && (self.playbackMode == .remote) {
        //            //castSession?.remoteMediaClient?.loadMedia(mediaInfo!)
        //         }
        //        else
        //        {
        //            castSession?.remoteMediaClient?.loadMedia(mediaInfo!)
        //
        //        }
        
        
        
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            
            self.stopplayerifcastingenable()
            if (remoteMediaClient.mediaStatus != nil) {
                // castSession?.remoteMediaClient?.stop()
                // let request = remoteMediaClient.queueInsert(item(), beforeItemWithID: kGCKMediaQueueInvalidItemID)
                //request.delegate = self
            } else {
                
                //castSession?.remoteMediaClient?.stop()
                castSession?.remoteMediaClient?.loadMedia(mediaInfo!)
                //                  let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .single
                //                let request = castSession?.remoteMediaClient?.queueLoad([item()], start: 0, playPosition: 0, repeatMode: repeatMode, customData: nil)
                //                request?.delegate = self
            }
        }
        
    }
    
    
    
    
    
    func loadMediaList1() {
        // Look up the media list URL.
        
        
        // castSession?.remoteMediaClient?.stop()
        
        if(!(Common.isNotNull(object: cromecastplayerurl as AnyObject)  || (cromecastplayerurl == "" )))
        {
            return
        }
        
        isplaycromecast = true
        
        let metadata = GCKMediaMetadata()
        metadata.setString(tilttext, forKey: kGCKMetadataKeyTitle)
        metadata.setString(descriptiontext,
                           forKey:kGCKMetadataKeySubtitle)
        let url = NSURL(string:self.cromecastimageurl)
        metadata.addImage(GCKImage(url: url as! URL, width: 480, height: 360))
        
        mediaInfo =  GCKMediaInformation(
            contentID:
            videoresoulationurlarray.object(at: videoresoulationurlarray.count-2) as! String,
            streamType: GCKMediaStreamType.none,
            contentType: "video/mp4",
            metadata: metadata,
            streamDuration: 0,
            mediaTracks: [],
            textTrackStyle: nil,
            customData: nil
        )
        
        
        castSession?.remoteMediaClient?.loadMedia(mediaInfo!)
        
        
        //        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
        //            self.stopplayerifcastingenable()
        //            forcefullylandscape()
        //            let builder = GCKMediaQueueItemBuilder()
        //            builder.mediaInformation = mediaInfo
        //            builder.autoplay = true
        //            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
        //            let item = builder.build
        //            let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .single
        //            castSession?.remoteMediaClient?.loadMedia(mediaInfo)
        //           let request = castSession?.remoteMediaClient?.queueLoad([item()], start: 0, playPosition: 0,
        //                                                                        repeatMode: repeatMode, customData: nil)
        //            request?.delegate = self
        //
        //        }
        
    }
    
    
    
    
    
    
    
    
    
    func switchToRemotePlayback() {
        print("switchToRemotePlayback; mediaInfo is \(String(describing: self.mediaInfo))")
        if self.playbackMode == .remote {
            return
        }
        if self.sessionManager.currentSession is GCKCastSession {
            self.castSession = (self.sessionManager.currentSession as? GCKCastSession)
        }
        
        self.castSession?.remoteMediaClient?.add(self)
        self.playbackMode = .remote
    }
    
    func switchToLocalPlayback() {
        print("switchToLocalPlayback")
        if self.playbackMode == .local {
            return
        }
        var playPosition: TimeInterval = 0
        var paused: Bool = false
        var ended: Bool = false
        if self.playbackMode == .remote {
            playPosition = self.castMediaController.lastKnownStreamPosition
            paused = (self.castMediaController.lastKnownPlayerState == .paused)
            ended = (self.castMediaController.lastKnownPlayerState == .idle)
            print("last player state: \(self.castMediaController.lastKnownPlayerState), ended: \(ended)")
        }
        self.castSession?.remoteMediaClient?.remove(self)
        self.castSession = nil
        self.playbackMode = .local
    }
    
    
    
    
    func clearMetadata() {
        
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil,
                                cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
    // MARK: - Local playback UI actions
    
    func startAdjustingStreamPosition(_ sender: Any) {
        self.streamPositionSliderMoving = true
    }
    
    func finishAdjustingStreamPosition(_ sender: Any) {
        self.streamPositionSliderMoving = false
    }
    
    func togglePlayPause(_ sender: Any) {
    }
    // MARK: - GCKSessionManagerListener
    
    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        print("MediaViewController: sessionManager didStartSession \(session)")
        self.switchToRemotePlayback()
        self.loadMediaList1()
        
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        print("MediaViewController: sessionManager didResumeSession \(session)")
        self.switchToRemotePlayback()
        
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        print("session ended with error: \(String(describing: error))")
        let message = "The Casting session has ended.\n\(String(describing: error))"
        self.resumeplayerifcastingdisable()
        AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        isplaycromecast = false
        
        if let window = appDelegate?.window {
            toast = JYToast()
            Toast.displayMessage(message, for: 3, in: window)
        }
        self.switchToLocalPlayback()
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        if let error = error {
            self.showAlert(withTitle: "Failed to start a session", message: error.localizedDescription)
            isplaycromecast = false
            self.resumeplayerifcastingdisable()
            AppUtility.lockOrientation([.portrait,.landscapeRight,.landscapeLeft])
            NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            
        }
    }
    
    func sessionManager(_ sessionManager: GCKSessionManager,
                        didFailToResumeSession session: GCKSession, withError error: Error?) {
        if let window = UIApplication.shared.delegate?.window {
            toast = JYToast()

            Toast.displayMessage("The Casting session could not be resumed.",
                                 for: 3, in: window)
        }
        self.switchToLocalPlayback()
    }
    // MARK: - GCKRemoteMediaClientListener
    
    func remoteMediaClient(_ player: GCKRemoteMediaClient, didUpdate mediaStatus: GCKMediaStatus?) {
        self.mediaInfo = mediaStatus?.mediaInformation
    }
    
    /* Play has been pressed in the LocalPlayerView. */
    
    func continueAfterPlayButtonClicked() -> Bool {
        let hasConnectedCastSession = GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession
        if (self.mediaInfo != nil) && hasConnectedCastSession() {
            // Display an alert box to allow the user to add to queue or play
            // immediately.
            if self.actionSheet == nil {
                self.actionSheet = ActionSheet(title: "Play Item", message: "Select an action", cancelButtonText: "Cancel")
                self.actionSheet?.addAction(withTitle: "Play Now", target: self,
                                            selector: #selector(self.playSelectedItemRemotely))
                self.actionSheet?.addAction(withTitle: "Add to Queue", target: self,
                                            selector: #selector(self.enqueueSelectedItemRemotely))
            }
            self.actionSheet?.present(in: self, sourceView: self.view)
            return false
        }
        return true
    }
    
    func playSelectedItemRemotely() {
        self.loadSelectedItem(byAppending: false)
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
    
    func enqueueSelectedItemRemotely() {
        self.loadSelectedItem(byAppending: true)
        let message = "Added \"\(self.mediaInfo?.metadata?.string(forKey: kGCKMetadataKeyTitle) ?? "")\" to queue."
        if let window = UIApplication.shared.delegate?.window {
            Toast.displayMessage(message, for: 3, in: window)
        }
    }
    /**
     * Loads the currently selected item in the current cast media session.
     * @param appending If YES, the item is appended to the current queue if there
     * is one. If NO, or if
     * there is no queue, a new queue containing only the selected item is created.
     */
    
    func loadSelectedItem(byAppending appending: Bool) {
        print("enqueue item \(String(describing: self.mediaInfo))")
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = self.mediaInfo
            builder.autoplay = true
            builder.preloadTime = TimeInterval(UserDefaults.standard.integer(forKey: kPrefPreloadTime))
            let item = builder.build()
            if ((remoteMediaClient.mediaStatus) != nil) && appending {
                let request = remoteMediaClient.queueInsert(item, beforeItemWithID: kGCKMediaQueueInvalidItemID)
                request.delegate = self
            } else {
                let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
                let request = remoteMediaClient.queueLoad([item], start: 0, playPosition: 0,
                                                          repeatMode: repeatMode, customData: nil)
                request.delegate = self
            }
        }
    }
    // MARK: - GCKRequestDelegate
    
    func requestDidComplete(_ request: GCKRequest) {
        print("request \(Int(request.requestID)) completed")
    }
    
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        print("request \(Int(request.requestID)) failed with error \(error)")
    }
    
    
    
    
    @IBAction func Taptocomment(_ sender: UIButton) {
        //        if(self.videoPlayer != nil)
        //        {
        //        self.videoPlayer.pause()
        //        }
        
        Commentview.isHidden = false
        self.view.bringSubview(toFront: self.Commentview)
        
        
    }
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
        print(newFrame.height)
        if(newFrame.height<160)
        {
            newcommentviewhightconstrant.constant = newFrame.height
        }
        commenttextviewhghtconstrant.constant = newFrame.height
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Comment" {
            textView.text = ""
            
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Comment"
            
        }
    }
    
    
    
    @IBAction func Taptohiddenratingview(_ sender: UIButton) {
        self.view.endEditing(true)
        ratingview.isHidden = true
    }
    @IBAction func TaptoHideencommentview(_ sender: UIButton) {
        
        self.view.endEditing(true)
        //        if(self.videoPlayer != nil)
        //        {
        //           self.videoPlayer.play()
        //        }
        Commentview.isHidden = true
    }
    @IBAction func Taptopostcomment(_ sender: UIButton) {
        self.postcomment(button: sender)
    }
    
    @IBAction func TaptoRaingbutton(_ sender: UIButton) {
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        self.intialalertview()
    }
    
    @IBAction func TaptoChannelview(_ sender: UIButton) {
        if(!isplaydfturl)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let channeldetailViewController = storyboard.instantiateViewController(withIdentifier: "ChanneldetailViewController") as! ChanneldetailViewController
            LoginCredentials.ischaneelviewappear = false
            channeldetailViewController.chanldict =  Channeldict
            self.navigationController?.pushViewController(channeldetailViewController, animated: true)
        }
        
    }
    @IBAction func Taptosubmitratingview(_ sender: UIButton) {
        
        ratingview.isHidden = true
        self.Submitrating()
        
    }
    @IBAction func Taptocancelratingview(_ sender: UIButton) {
        
        
        ratingview.isHidden = true
        
        
    }
    
    
    func Submitrating()
    {
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            var parameters = [String : Any]()
            parameters = [ "content_id":cat_id,
                           "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                           "device":"ios",
                           "rating": self.submitratingbar.value,
                           "type": "video"
            ]
            
            let url = String(format: "%@%@", LoginCredentials.Ratingapi,Apptoken)
            print(url)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                    {
                        EZAlertController.alert(title: "Error!")
                    }
                    else
                    {
                        self.showratingbar.setvalue = CGFloat((dict.value(forKey: "result") as! NSString).floatValue)
                        EZAlertController.alert(title: "Thanks for rating")
                    }
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to add a comment")
            
        }
    }
    
    
    
    
    func postcomment(button:UIButton)
    {
        self.view.endEditing(true)
        if(Common.Islogin())
        {
            if(!checkinterconnection())
            {
                return
            }
            
            
            if(commenttextview.text.isEmpty || commenttextview.text == "Write Comment")
            {
                EZAlertController.alert(title: "Please Enter Comment")
                return
            }
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            
            var name = String()
            var imageurl = String()
            
            if(Common.isNotNull(object: dict.value(forKey: "image") as AnyObject?))
            {
                imageurl = dict.value(forKey: "image") as! String
            }
            else
            {
                imageurl = ""
            }
            name = ""
            if(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?))
            {
                name = dict.value(forKey: "first_name") as! String
            }
            else if(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?))
            {
                name = "\(name)\(" ")\(dict.value(forKey: "last_name") as! String)"
            }
            
            
            
            
            //            if(Common.isNotNull(object: dict.value(forKey: "first_name") as AnyObject?))
            //            {
            //                if(Common.isNotNull(object: dict.value(forKey: "last_name") as AnyObject?))
            //                {
            //                    name = "\(dict.value(forKey: "first_name") as! String)\(" ")\(dict.value(forKey: "last_name") as! String)"
            //                }
            //                else
            //                {
            //                name = dict.value(forKey: "first_name") as! String
            //                }
            //            }
            //            else
            //            {
            //              name = ""
            //            }
            
            button.isUserInteractionEnabled = false
            
            var parameters = [String : Any]()
            
            parameters = [ "content_id":cat_id,
                           "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                           "device":"ios",
                           "comment": commenttextview.text!,
                           "name":name,
                           "image":imageurl
                
            ]
            var url = ""
            
            url = String(format: "%@%@", LoginCredentials.CommentaddAPi,Apptoken)
            
            print(url)
            print(parameters)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    button.isUserInteractionEnabled = true
                    
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    self.commenttextview.text = "Write Comment"
                    if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
                    {
                        EZAlertController.alert(title: "Error!")
                    }
                    else
                    {
                        self.toast.isShow("successfully post comment")
                        self.Iscommentloadmore = false
                        self.commentdataarray = NSMutableArray()
                        self.getusercomment()
                    }
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                self.toast.isShow("error in post comment")
                Common.stoploderonplayer(view: self.view)
                button.isUserInteractionEnabled = true
                
            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to place a comment")
            
        }
    }
    
    func getusercomment()
    {
        
        var parameters = [String : Any]()
        var url = ""
        if(Iscommentloadmore)
        {
            url = nextcommenturl
            parameters = [String : Any]()
            
        }
        else
        {
            if(LoginCredentials.IsencriptCommentlistapi)
            {
                parameters = [
                    "content_id":cat_id,
                    "offset":"0",
                    "max_record":"11"
                ]
                
                
                url = String(format: "%@%@/content_id/%@/offset/0/max_record/11", LoginCredentials.Commentlistapi,Apptoken,cat_id)
                
                
            }
            else
            {
                parameters = [
                    "content_id":cat_id,
                    "device":"ios",
                    "offset":"0",
                    "max_record":"11"
                ]
                
                url = String(format: "%@%@/content_id/%@/device/ios/offset/0/max_record/11", LoginCredentials.Commentlistapi,Apptoken,cat_id)
                
            }
            // url = String(format: "%@%@", LoginCredentials.Commentlistapi,Apptoken)
            
        }
        
        print(parameters)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                let dict = responseObject as! NSDictionary
                if let val = dict["code"]
                {
                    
                }
                else
                {
                    return
                }
                
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    //EZAlertController.alert(title: "Error")
                }
                else
                {
                    var detaildict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptCommentlistapi)
                    {
                        detaildict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        detaildict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                        
                    }
                    print(detaildict)
                    let array = detaildict.value(forKey: "content") as! NSArray
                    if(array.count == 0)
                    {
                        self.Isendcomment = true
                    }
                    for i in 0..<array.count {
                        self.commentdataarray.add(array.object(at: i) as! NSDictionary)
                    }
                    self.commenttableview.reloadData()
                    
                    self.nextcommenturl = detaildict.value(forKey: "next_page") as! String
                }
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
    }
    
    @IBAction func Taptoenablenotification(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
            Common.startloderonplayer(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
            var parameters = [String : Any]()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            
            var url = String()
            if(ischnlnotificationsubcribed)
            {
                parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                               "channel_id":chnl_id,
                               "donot_notify":"0"
                ]
                url = String(format: "%@%@", LoginCredentials.Subscribeapi,Apptoken)
                
            }
            else
            {
                parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                               "channel_id":chnl_id,
                               "donot_notify":"1"
                ]
                url = String(format: "%@%@", LoginCredentials.Unsubscribeapi,Apptoken)
                
            }
            print(url)
            
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploderonplayer(view: self.view)
                    if(self.ischnlnotificationsubcribed)
                    {
                        self.ischnlnotificationsubcribed = false
                        self.notificationbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                        
                    }
                    else
                    {
                        self.ischnlnotificationsubcribed = true
                        self.notificationbutton.setImage(UIImage.init(named: "notificationdisable"), for: .normal)
                        
                        
                    }
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
            
        }
        else
        {
            
            Common.Showloginalert(view: self, text: "Please login to acess this sction")
            
            
        }
        
        
        
        
        
    }
    
    
    @IBAction func Taptoplayermenu(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
            let optionMenuController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
            
            // Create UIAlertAction for UIAlertController
            
            let addAction = UIAlertAction(title: "Add Rating", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                print("File has been Add")
                self.intialalertview()
            })
            let saveAction = UIAlertAction(title: "Report", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                EZAlertController.alert(title: "Content Reporting")
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            // Add UIAlertAction in UIAlertController
            optionMenuController.addAction(addAction)
            //  optionMenuController.addAction(saveAction)
            optionMenuController.addAction(cancelAction)
            // Present UIAlertController with Action Sheet
            self.present(optionMenuController, animated: true, completion: nil)
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to acess this sction")
            
        }
    }
    
    
    
    func intialalertview()
    {
        
        if(Common.Islogin())
        {
            Common.setuiviewdborderwidth(View: inratingview, borderwidth: 1.0)
            Common.getRounduiview(view: inratingview, radius: 1.0)
            ratingview.isHidden = false
            self.view.bringSubview(toFront: self.ratingview)
            
        }
        else
            
        {
            Common.Showloginalert(view: self, text: "Please login to rate video")
        }
        
    }
    
    
    func getplayerurl() {
        
        Isendcomment = false
        castButton.isUserInteractionEnabled = false
        //self.getcromecasturl()
        self.Iscommentloadmore = false
        self.commentdataarray = NSMutableArray()
        
        Common.startloderonplayer(view: self.view)
        UIApplication.shared.endIgnoringInteractionEvents();
        LoginCredentials.Addtime = 0
        LoginCredentials.VideoPlayingtime = 0
        var parameters = [String : Any]()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        
        var url = String()
        
        if(Common.Islogin())
        {
            parameters = [ "content_id":cat_id,
                           "device":"ios",
                           "owner_info":"1",
                           "user_id": (dict.value(forKey: "id") as! NSNumber).stringValue
            ]
            
            url = String(format: "%@%@/device/ios/content_id/%@/owner_info/1/user_id/%@/secure/1", LoginCredentials.Detailapi,Apptoken,cat_id,(dict.value(forKey: "id") as! NSNumber).stringValue)
            
            
            
            
            
        }
        else
        {
            parameters = [ "content_id":cat_id,
                           "device":"ios",
                           "owner_info":"1",
                           "user_id": ""]
            
            
            url = String(format: "%@%@/device/ios/content_id/%@/owner_info/1/secure/1", LoginCredentials.Detailapi,Apptoken,cat_id)
            
            
            //http://staging.multitvsolution.com:9000/api/v6/content/detail/token/59a942cd8175f/device/android/content_id/1615/owner_info/1/secure/1
            
            
            
            
        }
        print(parameters)
        // url = String(format: "%@%@", LoginCredentials.Detailapi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                LoginCredentials.Videoid = self.cat_id
                Common.stoploderonplayer(view: self.view)
                let dict = responseObject as! NSDictionary
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                var detaildict = NSMutableDictionary()
                if(LoginCredentials.IsencriptDetailapi)
                {
                    
                    detaildict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                  detaildict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                
                print(detaildict)
                if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "title") as AnyObject))
                {
                    self.tilttext = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "title") as! String
                }
                if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des") as AnyObject))
                {
                    self.descriptiontext = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "des") as! String
                }
                
                
                let catdataarray = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "category_ids") as! NSArray
                if(catdataarray.count == 0)
                {
                    self.catid = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "category_id") as! String
                }
                else
                {
                    
                    var ids = String()
                    for i in 0..<catdataarray.count
                    {
                        let str = catdataarray.object(at: i) as! String
                        ids = ids + str + ","
                    }
                    ids = ids.substring(to: ids.index(before: ids.endIndex))
                    self.catid = ids
                }
                
                print(self.catid)
                
                if(Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs") as AnyObject))
                {
                    let url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "thumbs") as! NSArray
                    print(url)
                    if(url.count>0)
                    {
                        self.cromecastimageurl = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    }
                }
                
                self.Download_dic = (detaildict.value(forKey: "content") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.likelabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes_count") as! String)"
                self.totalviewlabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "watch") as! String)\(" views")"
                self.likecount = Int((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "likes_count") as! String)!
                self.dislikecount = Int((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "dislike_count") as! String)!
                self.shareurlnew = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "share_url") as! String
                self.showratingbar.setvalue =  (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "rating") as! CGFloat
                // self.showratingbar.value  = 3
                //    self.showratingbar.value = CGFloat(((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "rating") as! NSString).floatValue)
                
                self.dislikelabel.text = "\((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "dislike_count") as! String)"
                
                //  self.Video_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "url") as! String
                
                if Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as AnyObject?) {
                    self.Channeldict = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary
                    self.Getchanneldeltail(name: "\(((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "first_name") as! String)\(" ")\(((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "last_name") as! String)", issubcribe: ((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "is_subscriber") as! String, chanellurl: ((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "prfile_pic") as! String,notification:((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "notification") as! String)
                    self.chnl_id = ((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "owner_info") as! NSDictionary).value(forKey: "id") as! String
                    
                    
                }
                
                if Common.isNotNull(object: (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as AnyObject?) {
                    
                    if((detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_expiry") as! String == "0")
                    {
                        self.downloadVideo_url = ""
                        
                    }
                    else
                    {
                        self.downloadVideo_url = (detaildict.value(forKey: "content") as! NSDictionary).value(forKey: "download_path") as! String
                    }
                    
                    
                }
                else
                {
                    self.downloadVideo_url = ""
                }
                
                
                
                
                if(self.fromdownload == "yes" || self.downloadVideo_url == "")
                {
                    self.downloadbutton.setImage(UIImage.init(named: "downloaddisable"), for: .normal)
                    self.downloadbutton.isUserInteractionEnabled = false
                }
                else
                {
                    self.downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
                    self.downloadbutton.isUserInteractionEnabled = true
                }
                
                
                if(Common.Islogin())
                {
                    self.Chekvideoisdownloading()
                }
                
                Common.startloderonplayer(view: self.view)
                UIApplication.shared.endIgnoringInteractionEvents();
                DispatchQueue.global(qos: .background).async {
                    self.GetVasthurl()
                }
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
            if(self.fromdownload != "yes")
            {
                let alert = UIAlertController(title: "", message: "Something went wrong please try again.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                }))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    
    
    func CheckUserloginandsubscribtion() -> Bool
    {
        
        if(!Common.Islogin()) {
            
            let alert = UIAlertController(title: "", message: "Please Login to watch Video", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) in
                Common.gotologinpage(view: self)
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
                self.contantdisablebackaction()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else
        {
            
            if(Common.Isuserissubscribe(Userdetails: self))
            {
                return true
            }
            else
            {
  
                let alert = UIAlertController(title: "", message: "Please Subscribe to watch our great video", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Subscribe", style: UIAlertActionStyle.default, handler: { (action) in
                    Common.PresentSubscription(Viewcontroller: self)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
    }
    

    func ChekUsersecceion(dictDetail:NSDictionary) -> Bool
    {
 
        print(dictDetail)
        if(checkcontantenable)
        {
            // self.getUsersession()
            if(Common.isNotNull(object: dictDetail.value(forKey: "is_playback_allowed") as AnyObject?))
            {
                if((dictDetail.value(forKey: "is_playback_allowed") as! String) == "1")
                {
                    print("Enable User Session")

                    if(self.checkcontantenable)
                    {
                        Common.ActivateUsersession()
                    }
                    return true

                }
                else
                {
                    print("Disable User Session")
                    disableappsessionalert()
                    return false
                }
            }
        }

        return true
    }
    
    
    
    
    func checkinterconnection() -> Bool
    {
        if(self.fromdownload == "yes")
        {
            return true
        }
        
        if(!Common.isInternetAvailable())
        {
            let alert = UIAlertController(title: "", message: "Please check internet connection", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                if(self.videoPlayer == nil)
                {
                    
                }
                else
                {
                    self.avLayer.removeFromSuperlayer()
                    self.videoPlayer.pause()
                    self.videoPlayer = nil
                }
                if (self.adsManager != nil)
                {
                    self.adsManager!.destroy()
                    self.adsManager = nil
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func getsubscriptiondetai()
    {
        
        
        
        if(Common.Islogin())
        {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            var url = String()
            
            
            
            url = String(format: "%@%@/device/ios/user_id/%@/content_id/%@/content_ch_id/%@", LoginCredentials.Userbehaviorapi,Apptoken,(dict.value(forKey: "id") as! NSNumber).stringValue,cat_id,self.chnl_id)
            
            print(url)
            
            Common.startloderonplayer(view: self.view)
            UIApplication.shared.endIgnoringInteractionEvents();
            // url = String(format: "%@%@", LoginCredentials.Userbehaviorapi,Apptoken)
            print(url)
            
            let manager = AFHTTPSessionManager()
            manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    
                    Common.stoploderonplayer(view: self.view)
                    let dict1 = responseObject as! NSDictionary
                    print(dict1)
                    let number = dict1.value(forKey: "code") as! NSNumber
                    
                    if(number == 0)
                    {
                    }
                    else
                    {
                        var dict = NSMutableDictionary()
                        
                        if(LoginCredentials.IsencriptUserbehaviorapi)
                        {
                            dict = (dict1.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                        else
                        {
                            dict = Common.decodedresponsedata(msg: dict1.value(forKey: "result") as! String)
                            
                        }
                        print(dict)
                        
                        
                        
                        if(Common.Islogin())
                        {
                            
                            
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "is_disliked") as! NSString == "0")
                            {
                                
                                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
                                self.isdislike = false
                                
                            }
                            else
                            {
                                self.dislikebutton.setImage(UIImage.init(named: "dislike"), for: .normal)
                                self.isdislike = true
                                
                                
                            }
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "likes") as! NSString == "0")
                            {
                                
                                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                                self.islike = false
                                
                            }
                            else
                            {
                                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                                self.islike = true
                                
                                
                            }
                            
                            if((dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "favorite") as! NSString == "0")
                            {
                                
                                self.Favroutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                                self.isfav = false
                                
                            }
                            else
                            {
                                self.Favroutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                                self.isfav = true
                                
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        if( (dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "is_subscriber") as! NSString == "0")
                        {
                            
                            self.chaneelsubscribebutton.setImage(UIImage.init(named: "UnSubcribed"), for: .normal)
                            self.ischnlsucribe = false
                            self.notificationbutton.isHidden = true
                        }
                        else
                        {
                            self.chaneelsubscribebutton.setImage(UIImage.init(named: "Subcribed"), for: .normal)
                            self.ischnlsucribe = true
                            self.notificationbutton.isHidden = false
                            if( (dict.value(forKey: "behaviour") as! NSDictionary).value(forKey: "notification") as! NSString == "0")
                            {
                                self.ischnlnotificationsubcribed = false
                                self.notificationbutton.setImage(UIImage.init(named: "notificationdisable"), for: .normal)
                                
                            }
                            else
                            {
                                self.ischnlnotificationsubcribed = true
                                self.notificationbutton.setImage(UIImage.init(named: "notificationenable"), for: .normal)
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
            }
                )
            { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploder(view: self.view)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func TaptoSubcribechannel(_ sender: UIButton) {
        
        if(Common.Islogin())
        {
            print(Channeldict)
            
            if(ischnlsucribe)
            {
                
                
                let alert = UIAlertController(title: "YUV", message: "Unsubscribe from \(Channeldict.value(forKey: "first_name") as! String)\(" ")\(Channeldict.value(forKey: "last_name") as! String) ?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
                    self.subscribechnl()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.subscribechnl()
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to acess this sction")
            
        }
        
    }
    
    
    
    func subscribechnl()
    {
        Common.startloderonplayer(view: self.view)
        UIApplication.shared.endIgnoringInteractionEvents();
        var parameters = [String : Any]()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        parameters = [ "customer_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                       "channel_id":chnl_id,
        ]
        
        var url = String()
        if(!ischnlsucribe)
            
        {
            url = String(format: "%@%@", LoginCredentials.Subscribeapi,Apptoken)
            
        }
        else
        {
            url = String(format: "%@%@", LoginCredentials.Unsubscribeapi,Apptoken)
            
        }
        print(url)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                
                Common.stoploderonplayer(view: self.view)
                if(self.ischnlsucribe)
                {
                    self.ischnlsucribe = false
                    self.chaneelsubscribebutton.setImage(UIImage.init(named: "UnSubcribed"), for: .normal)
                    self.notificationbutton.isHidden = true
                    
                    
                    
                }
                else
                {
                    self.ischnlsucribe = true
                    self.chaneelsubscribebutton.setImage(UIImage.init(named: "Subcribed"), for: .normal)
                    self.ischnlnotificationsubcribed = true
                    self.notificationbutton.isHidden = false
                    
                    
                }
                
                
            }
        }
            )
        { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
        
    }
    
    
    func Getchanneldeltail(name:String,issubcribe:String,chanellurl:String,notification:String)
    {
        chanelname.text = name
        Common.getRoundImage(imageView: chanelimageview, radius: 8.0)
        
        if(!Common.isNotNull(object: chanellurl as AnyObject) ||  chanellurl == "")
        {
            chanelimageview.image = #imageLiteral(resourceName: "Placehoder")
        }
        else
        {
            var chanellurl1 = chanellurl
            // chanellurl1 = Common.getsplitnormalimageurl(url: chanellurl1)
            chanelimageview.setImageWith(URL(string: chanellurl1)!, placeholderImage: UIImage.init(named: "Placehoder"))
        }
    }
    
    
    func Chekvideoisdownloading()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        if(array.contains(cat_id))
        {
            animatedownloadbutton()
        }
        else
        {
            // self.downloadbutton.imageView?.stopAnimating()
            // self.downloadbutton.setImage(UIImage.init(named: "download"), for: .normal)
            stopanimatedownliadbutton()
        }
        
    }
    
    
    
    
    
    func animatedownloadbutton()
    {
        downloadbutton.isHidden = true
        let jeremyGif = UIImage.gifImageWithName(name: "down_update")
        progressdownloadimageview = UIImageView(image: jeremyGif)
        progressdownloadimageview.frame = CGRect(x: downloadbutton.frame.origin.x, y: downloadbutton.frame.origin.y, width: downloadbutton.frame.size.width, height: downloadbutton.frame.size.height)
        self.myscroolview.addSubview(progressdownloadimageview)
    }
    
    
    func stopanimatedownliadbutton()
    {
        if(progressdownloadimageview != nil)
        {
            progressdownloadimageview.image = nil
            progressdownloadimageview.removeFromSuperview()
            progressdownloadimageview.isHidden = true
            downloadbutton.isHidden = false
            downloadbutton.bringSubview(toFront: self.myscroolview)
        }
    }
    
    
    //MARK:- Get parse data with url
    
    func GetVasthurl()
    {
        
        self.setvideodescription(titile: tilttext, like: liketext, des: descriptiontext, url: Video_url)
        
        let url = String(format: "%@device/ios/secure/1/cid/%@/token/%@", LoginCredentials.Addetailapi,cat_id,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    Common.stoploderonplayer(view: self.view)
                    return
                }
                
                if(Common.isNotNull(object: dict.value(forKey: "result") as AnyObject?))
                {
                    
                    var decodedata_dict = NSMutableDictionary()
                    if(LoginCredentials.IsencriptAddetailapi)
                    {
                        decodedata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        
                        decodedata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                        
                    }
                    
                    print(decodedata_dict)
                    if(Common.isNotNull(object: decodedata_dict.value(forKey: "url") as AnyObject?))
                    {
                       self.Video_url = (decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "abr") as! String
                        if(Common.isNotNull(object: decodedata_dict.value(forKey: "url") as AnyObject?))
                        {
                            if(Common.isNotNull(object: ((decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "dfp_url") as AnyObject?)))
                            {
                                self.Dfp_url = (decodedata_dict.value(forKey: "url") as! NSDictionary).value(forKey: "dfp_url") as! String
                                self.isplaydfturl = true
                            }
                            else
                            {
                                
                                self.isplaydfturl = false
                                
                            }
                        }
                        else
                            
                        {
                            self.isplaydfturl = false
                        }
                        
                   
                        self.setvideodata(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                        self.setvideodescription(titile: self.tilttext, like: self.liketext, des: self.descriptiontext, url:self.Video_url)
                        dispatch(queue: .background, closure: {
                            //self.setvideoinwatchlist()
                            self.getmorevideo()
                            self.getuserrelatedvideo()
                            self.getusercomment()
                            self.getsubscriptiondetai()
                        })
          
                    }
                    else
                    {
                        
                        let alert = UIAlertController(title: "", message: "Something went wrong please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert) in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploderonplayer(view: self.view)
        }
        
        
    }
    
    
    //MARK:- Call event api on playing ad
    
    func calladdeventurl(url:String)
    {
        
        
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
        
    }
    
    
    
    
    func convertToDictionary(text: String) -> NSDictionary {
        let asd = NSDictionary()
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return asd
    }
    
    
    
    
    
    
    
    //MARK:- Start Download Method
    
    
    func stopdownloadprogress()
    {
        
        if downloadTask != nil{
            downloadTask.cancel()
        }
    }
    
    
    func downloadwithurl(urlstr:String)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let url = URL(string: urlstr)!
        downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
        dataBase.savedownloadvideoid(id: cat_id, userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        
    }
    
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        else
        {
            
            //  urlData.write(toFile: filePath, atomically: true)
            
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL){
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let fileManager = FileManager.default
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
        print(array)
        let videoid = array.object(at: 0) as! String
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(videoid).mp4"))
        do
        {
            try fileManager.moveItem(at: location, to: destinationURLForFile)
            self.Showpopupmsg(msg: "video downloading completed")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Downloadingvideo"), object: nil, userInfo: nil)
            print(videoid)
            self.stopanimatedownliadbutton()
            let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
            print(array)
            dataBase.deletedownloadvideoid(videoid: videoid,user_id:(dict.value(forKey: "id") as! NSNumber).stringValue)
            let array1 = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
            print(array1)
            
        }
        catch
        {
            print("Getting issue in downloading")
        }
        
        
    }
    
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64){
        
        print(downloadTask.taskIdentifier)
        print(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        
        //  progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    //MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        downloadTask = nil
        if (error != nil) {
            print(error!.localizedDescription)
        }else{
            print("The task finished transferring data successfully")
        }
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    
    //MARK:- End Download Method
    func chekUserislogin()
    {
        
        if !Common.Islogin()
        {
            downloadbutton.isUserInteractionEnabled = false
            likebutton.isUserInteractionEnabled = false
        }
        else
        {
            
            downloadbutton.isUserInteractionEnabled = true
            likebutton.isUserInteractionEnabled = true
        }
        
        
        
    }
    
    
    //MARK:- TAptoExpenddiscriptiontext
    
    @IBAction func TAptoExpenddiscriptiontext(_ sender: UIButton)
    {
        
        
        
        if !isshowmore
        {
            isshowmore = true
            let height =  self.calculateContentHeight(str: descriptiontext)
            print(height)
            //self.discriptionlabeheightcontraint.constant = height - 50
            self.discriptionlabeheightcontraint.constant = height
            scrollviewheighltcontrant.constant =  scrollviewheighltcontrant.constant + height
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
            
        }
        else
        {
            self.discriptionlabeheightcontraint.constant = 20.0
            scrollviewheighltcontrant.constant =  570
            isshowmore = false
            self.perform(#selector(changeUI), with: self, afterDelay: 0.01)
            
            
            
        }
        
        
        
        
    }
    
    
    
    func changeUI() {
        
        mXSegmentedPager.frame.origin.y = channelview.frame.origin.y+channelview.frame.size.height
        
    }
    
    func calculateContentHeight(str:String) -> CGFloat{
        let maxLabelSize: CGSize = CGSize.init(width: self.view.frame.size.width - 26, height: 9999)
        let contentNSString = str as NSString
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: CGFloat(14))! as UIFont], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
        
    }
    
    
    
    func calculatecommentContentHeight(str:String) -> CGFloat{
        let maxLabelSize: CGSize = CGSize.init(width: self.view.frame.size.width - 26, height: 9999)
        let contentNSString = str as NSString
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: CGFloat(12))! as UIFont], context: nil)
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height
        
    }
    
    
    
    //MARK:- Set Video data description data
    
    
    func setvideodescription(titile:String,like:String,des:String,url:String)
    {
        
        if(self.fromdownload == "yes")
        {
            self.settingbutton.isHidden = true
        }
        else
        {
            //self.self.settingbutton.isHidden = false
        }
        
        self.titlenamelabel.text = titile
        var discriptiontext = des
        discriptiontext = discriptiontext.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // discriptiontext.remove(at: (discriptiontext.startIndex))
        self.contantdiscriptionlabel.text = discriptiontext
        
    }
    
    
    func setvideodata(titile:String,like:String,des:String,url:String)
    {
        
  
        if(ChekUsersecceion(dictDetail: Download_dic))
        {
            
            if(Common.isInternetAvailable())
            {
                getallresolutionview(url: url)
                self.playvideo(url: url)
            }
            else
            {
                if(self.fromdownload == "yes")
                {
                    self.playvideo(url: url)
                    
                }
            }
        }
        
        
        
//        if(self.CheckUserloginandsubscribtion()) {
//
//            if(ChekUsersecceion(dictDetail: Download_dic))
//            {
//
//                if(Common.isInternetAvailable())
//                {
//                    getallresolutionview(url: url)
//                    self.playvideo(url: url)
//                }
//                else
//                {
//                    if(self.fromdownload == "yes")
//                    {
//                        self.playvideo(url: url)
//
//                    }
//                }
//            }
//        }
        
    }
    
    
    
    //MARK:- One user one Session
    
    func playvideoaftercheckingcontantsession()
    {
        if(Common.isInternetAvailable())
        {
            getallresolutionview(url: Video_url)
            self.playvideo(url: Video_url)
        }
        
    }
    
    
    func disableappsessionalert()
    {
        let alert = UIAlertController(title: "", message: "You are currently accessing YUV content with same account on some other device.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Watch Here", style: UIAlertActionStyle.default, handler: { (action) in
            Common.ActivateUsersession()
            self.playvideoaftercheckingcontantsession()
        }))
        alert.addAction(UIAlertAction(title: "Continue There Only", style: UIAlertActionStyle.default, handler: { (action) in
               //Common.Pushback()
            

             self.contantdisablebackaction()
//             DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
//             self.backstoppalyer()
//            })
   //         return
        }))
        if(!LoginCredentials.Issociallogin)
        {
            alert.addAction(UIAlertAction(title: "Reset Password", style: UIAlertActionStyle.default, handler: { (action) in
                self.forgotpassword()
                return
                
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    func forgotpassword()
    {
        Common.startloder(view: self.view)
        var parameters = [String : String]()
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        parameters = [
            "email": (dict.value(forKey: "email") as? String)!,
            "device": "ios"
        ]
        
        let url = String(format: "%@%@", LoginCredentials.Forgotapi,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    EZAlertController.alert(title: "This email id is not register, please enter register email id.")
                }
                else
                {
                    
                    Common.appLogout()
                    
                    
                }
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.stoploder(view: self.view)
        }
        
        
    }
    
    
    
    func contantdisablebackaction()
    {
        // let sender = UIButton()
        // self.Taptoback(sender)
      
         let _ =  self.navigationController?.popViewController(animated: true)
         NotificationCenter.default.removeObserver(self)
         self.viewWillDisappear(true)
        //  self.view = nil
        
    }
    
    
    
    
    
    
    //MARK:- view will Disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if(Common.Islogin())
        {
            if(downloadbutton.imageView?.isAnimating)!
            {
                downloadbutton.imageView?.stopAnimating()
            }
            
            if(!isplayadd)
            {
                if(self.videoPlayer != nil)
                {
                    if(playbackSlider.maximumValue != self.playbackSlider.value && self.playbackSlider.value > 10.0)
                        
                    {
                        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                        dataBase.Savecontinuewatching(id: (dict.value(forKey: "id") as! NSNumber).stringValue, seektime: self.playbackSlider.value, data: Download_dic)
                        
                    }
                    
                }
            }
        }
        if(LoginCredentials.ischaneelviewappear)
        {
            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            AppUtility.lockOrientation(.portrait)
            
        }
        else
        {
            
        }
        
        //        if(self.videoPlayer == nil)
        //        {
        //
        //        }
        //        else
        //        {
        //            avLayer.removeFromSuperlayer()
        //            self.videoPlayer.pause()
        //            self.videoPlayer = nil
        //        }
        
        
    }
    
    
    //MARK:- Parse All Resolution
    func getallresolutionview(url:String)
    {
        DispatchQueue.global(qos: .background).async {
            self.parseallsteme(url: url)
        }
        
        
    }
    
    
    //MARK:- Play video with url
    func playvideo(url:String)
    {
        var videoURL = URL(string:url)
        DispatchQueue.main.async { () -> Void in
            let rect = CGRect(origin: CGPoint(x: 0,y :-10), size: CGSize(width: self.view.frame.size.width, height: 200))
            if(self.fromdownload == "yes")
            {
                let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                let videoDataPath = url.appendingPathComponent("\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4")?.path
                videoURL = URL(fileURLWithPath: videoDataPath!)
            }
            let playerItem:AVPlayerItem = AVPlayerItem(url: videoURL!)
            
            //            if self.avLayer != nil
            //            {
            //                self.avLayer.removeFromSuperlayer()
            //                self.avLayer = nil
            //            }
            //            if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
            //            {
            //                self.videoPlayer = nil
            //            }
            //            if self.videoPlayer != nil
            //            {
            //             self.videoPlayer = nil
            //            }
            
            
            self.videoPlayer = AVPlayer(playerItem: playerItem)
            self.avLayer = AVPlayerLayer(player:self.videoPlayer)
            self.avLayer.frame = rect
            self.avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch {
                // report for an error
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.videoPlayer.currentItem)
            
            self.view.layer.addSublayer(self.avLayer)
            if(!self.isplaydfturl)
            {
                self.videoPlayer.play()
                
            }
            
            if (self.tempView != nil)
            {
                self.tempView.removeFromSuperview()
                self.tempView = nil
            }
            self.tempView = UIView(frame:CGRect(x:0, y:-10, width:self.view.frame.size.width+10, height:200))
            
            
            self.tempView.backgroundColor=UIColor.clear
            self.view.addSubview(self.tempView)
            
            if(self.isplaydfturl)
            {
                
                let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
                if hasConnectedSession && (self.playbackMode == .remote) {
                    
                    
                }
                else
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
                        self.loadadssetting()
                        self.creategoogeima()
                        self.setUpIMA()
                        self.requestAdsWithTag(self.Dfp_url)
                    })
                }
            }
            if(self.fromdownload == "yes")
            {
                
            }
            else
            {
                self.startloader()
            }
            
            if self.playbackSlider != nil
            {
                self.playbackSlider.removeFromSuperview()
            }
            
            
            //////soundslide////////////
            self.soundbackSlider = UISlider(frame:CGRect(x:10, y:145, width:self.view.frame.size.width-20, height:25))
            self.soundbackSlider.minimumValue = 0
            self.soundbackSlider.maximumValue = 1
            let leftTrackImage1 = UIImage(named: "slidercircle")
            self.soundbackSlider.setThumbImage(leftTrackImage1, for: .normal)
            self.soundbackSlider.isContinuous = true
            self.soundbackSlider.tintColor = UIColor.blue
            self.soundbackSlider.addTarget(self, action: #selector(self.soundSliderValueChanged(_:)), for: .valueChanged)
            self.tempView.addSubview(self.soundbackSlider)
            self.soundbackSlider.isHidden = true
            
            
            
            self.playbackSlider = UISlider(frame:CGRect(x:10, y:145, width:self.view.frame.size.width-20, height:25))
            let leftTrackImage = UIImage(named: "slidercircle")
            let minImage = UIImage(named: "lineRed")
            let maxImage = UIImage(named: "lineGray")
            self.playbackSlider.setThumbImage(leftTrackImage, for: .normal)
            self.playbackSlider.trackRect(forBounds: CGRect.init(origin: self.playbackSlider.bounds.origin, size: CGSize.init(width: self.playbackSlider.bounds.width, height: 5)))
            
            self.playbackSlider.minimumValue = 0
            // playbackSlider.maximumValue = 100
            self.playbackSlider.setValue(0, animated: true)
            self.playbackSlider.setMaximumTrackImage(maxImage, for: .normal)
            self.playbackSlider.setMinimumTrackImage(minImage, for: .normal)
            let duration : CMTime = playerItem.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            //playerViewController.player = player
            let endInterval = NSDate(timeIntervalSince1970:seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.ReferenceType.local
            dateFormatter.dateFormat = "HH:mm:ss"
            let dateTimeFromPublishedString = dateFormatter.string(from: endInterval as Date)
            if seconds != seconds
            {
                self.playbackSlider.maximumValue = Float(0.0)
            }
            else
            {
                self.playbackSlider.maximumValue = Float(seconds)
            }
            self.totalvideoDurationtime = Float(seconds)
            self.playbackSlider.isContinuous = true
            self.playbackSlider.tintColor = UIColor.green
            
            if (self.timer != nil)
            {
                self.timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            //Swift 2.2 selector syntax
            self.playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(self.playbackSlider)
            
            self.view.bringSubview(toFront: self.tempView)
            self.view.bringSubview(toFront: self.playbackSlider)
            let rectsound = CGRect(origin: CGPoint(x: 5,y :180), size: CGSize(width: 20, height: 20))
            self.soundcontrolbutton.frame = rectsound
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "Unmute"), for: .normal)
            self.soundcontrolbutton.addTarget(self, action: #selector(self.controlsound(button:)), for: .touchUpInside)
            self.tempView.addSubview(self.soundcontrolbutton)
            //duration
            let rectLeft = CGRect(origin: CGPoint(x: 30,y :184), size: CGSize(width: 30, height: 10))
            if self.lblLeft != nil
            {
                self.lblLeft.removeFromSuperview()
            }
            self.lblLeft.backgroundColor = UIColor.clear
            self.lblLeft.font = UIFont.systemFont(ofSize: 8)
            self.lblLeft.textColor = UIColor.white
            self.lblLeft.text = "00:00"
            self.lblLeft.frame = rectLeft
            self.tempView.addSubview(self.lblLeft)
            let timeDuration = Float(seconds)
            //singleTapped
            
            
            self.singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
            self.singletap.numberOfTapsRequired = 1
            if !self.isplayadd
            {
                self.tempView.addGestureRecognizer(self.singletap)
            }
            
            let (hr,  minf) = modf (timeDuration / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            let hoursString = String(hr)
            let minutesString = String(min)
            let secondString = String(second)
            let timeEnd = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            
            let rectRight = CGRect(origin: CGPoint(x: self.lblLeft.frame.origin.x+self.lblLeft.frame.size.width,y :184), size: CGSize(width: 40, height: 10))
            if self.lblEnd != nil
            {
                self.lblEnd.removeFromSuperview()
            }
            self.lblEnd.backgroundColor = UIColor.clear
            self.lblEnd.font = UIFont.systemFont(ofSize: 8)
            
            self.lblEnd.text = "\("/")\(" ")\(timeEnd as String)"
            self.lblEnd.frame = rectRight
            self.lblEnd.textColor = UIColor.white
            self.tempView.addSubview(self.lblEnd)
            
            if self.expandBtn != nil
            {
                self.expandBtn.removeFromSuperview()
            }
            
            let rectsecuritylabel = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :15), size: CGSize(width: 100, height: 50))
            self.securitylabel.frame = rectsecuritylabel
            self.securitylabel.font = UIFont(name: "Ubuntu", size: CGFloat(10))
            self.securitylabel.textColor = UIColor.white
            self.securitylabel.text = Common.getstatickey()
            self.tempView.addSubview(self.securitylabel)
            
            let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-50,y :80), size: CGSize(width: 50, height: 50))
            self.expandBtn.frame = rectMore
            self.expandBtn.addTarget(self, action: #selector(self.expandBtnAction), for: .touchUpInside)
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            self.expandBtn.isHidden = true
            if self.enlargeBtn != nil
            {
                self.enlargeBtn.removeFromSuperview()
            }
            let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-20,y :184), size: CGSize(width: 15, height: 15))
            //expandPlayer
            let expandImage = UIImage(named: "expandPlayer")
            self.enlargeBtn.setImage(expandImage, for: .normal)
            self.enlargeBtn.frame = rectEnlarge
            self.enlargeBtn.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            //settinglayer
            let settingicon = UIImage(named: "Resolution")
            let rectsetting = CGRect(origin: CGPoint(x: self.view.frame.size.width-75,y :180), size: CGSize(width: 40, height: 20))
            self.settingbutton.setImage(settingicon, for: .normal)
            self.settingbutton.frame = rectsetting
            self.settingbutton.addTarget(self, action: #selector(self.downloadSheet), for: .touchUpInside)
            
            ///Skipbutton
            let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
            self.Skipbutton.setTitle("SKIP", for: .normal)
            self.Skipbutton.setTitleColor(UIColor.white, for: .normal)
            self.Skipbutton.frame = skipEnlarge
            self.Skipbutton.backgroundColor = UIColor.black
            self.Skipbutton.addTarget(self, action: #selector(self.taptoskip), for: .touchUpInside)
            self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            Common.setbuttonborderwidth(button: self.Skipbutton, borderwidth: 1.0)
            self.tempView.addSubview(self.Skipbutton)
            self.Skipbutton.isHidden = true
            self.tempView.addSubview(self.settingbutton)
            self.tempView.addSubview(self.expandBtn)
            self.tempView.addSubview(self.enlargeBtn)
            
            
            self.tempView.bringSubview(toFront: self.expandBtn)
            self.tempView.bringSubview(toFront: self.enlargeBtn)
            
            if self.enlargeBtnLayer != nil
            {
                self.enlargeBtnLayer.removeFromSuperview()
            }
            let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
            //expandPlayer
            let expandLayerImage = UIImage(named: "")
            self.enlargeBtnLayer.setImage(expandLayerImage, for: .normal)
            self.enlargeBtnLayer.frame = rectEnlargeLayer
            self.enlargeBtnLayer.addTarget(self, action: #selector(self.enlargeBtnAction), for: .touchUpInside)
            
            self.tempView.addSubview(self.enlargeBtnLayer)
            self.tempView.bringSubview(toFront: self.enlargeBtnLayer)
            self.backwordbutton.isHidden = true
            self.forwardbutton.isHidden = true
            self.forword10secbutton.isHidden = true
            self.settingbutton.isHidden = true
            self.castButton.isHidden = true
            self.backwordbuttonuppercnstraint.constant = 60.0
            self.Resolutionbutton.isHidden = true
            self.view.bringSubview(toFront: self.forwardbutton)
            self.view.bringSubview(toFront: self.forword10secbutton)
            self.view.bringSubview(toFront: self.castButton)
            self.view.bringSubview(toFront: self.backwordbutton)
            self.view.bringSubview(toFront: self.backbutton)
            self.view.bringSubview(toFront: self.Resolutionbutton)
            self.view.bringSubview(toFront: self.Skipbutton)
            self.view.bringSubview(toFront: self.soundbackSlider)
            self.view.bringSubview(toFront: self.soundcontrolbutton)
            self.view.bringSubview(toFront: self.securitylabel)
            self.tempView.bringSubview(toFront: self.settingbutton)
            
            self.rotateddd()
            self.startsecurityTimer()
            
            
            
            
            
            
            if !self.isplaydfturl
            {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                    self.bHideControl = false
                    self.singleTapped()
                })
            }
            else{
                
                self.bHideControl = false
                self.singleTapped()
                
            }
        }
    }
    
    
    
    func startsecurityTimer() {
        showshecuritykey()
        if(securitykeytimer != nil)
        {
            securitykeytimer?.invalidate()
        }
        securitykeytimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(PlayerViewController.showshecuritykey), userInfo: nil, repeats: true)
        
        
    }
    
    
    func showshecuritykey()
    {
        securitylabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.hideenshowshecuritykey()
        })
        
    }
    func hideenshowshecuritykey()
    {
        securitylabel.isHidden = true
        
    }
    
    
    func stopsecurityTimer()
    {
        if(securitykeytimer != nil)
        {
            securitykeytimer?.invalidate()
        }
    }
    
    
    
    deinit {
        print("Going to casrsh")
        // stopsecurityTimer()
        NotificationCenter.default.removeObserver(self)

    }
    
    func loadadssetting()
    {
        if (adsLoader != nil) {
            adsLoader = nil
        }
        let settings = IMASettings()
        settings.enableBackgroundPlayback = true;
        adsLoader = IMAAdsLoader(settings: settings)
        
    }
    
    func creategoogeima()
    {
        // Create content playhead
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.videoPlayer)
        // Set ourselves up for PiP.
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
        pictureInPictureController = AVPictureInPictureController(playerLayer: avLayer!);
        if (pictureInPictureController != nil) {
            pictureInPictureController!.delegate = pictureInPictureProxy;
        }
    }
    
    
    
    // MARK: IMA SDK methods
    
    // Initialize ad display container.
    func createAdDisplayContainer() -> IMAAdDisplayContainer
    {
        // Create our AdDisplayContainer. Initialize it with our videoView as the container. This
        // will result in ads being displayed over our content video.
        return IMAAdDisplayContainer(adContainer: self.tempView, companionSlots: nil)
    }
    
    
    
    
    // Initialize AdsLoader.
    func setUpIMA()
    {
        
        if (adsManager != nil) {
            adsManager!.destroy()
        }
        adsLoader.contentComplete()
        adsLoader.delegate = self
        
    }
    
    
    // Request ads for provided tag.
    func requestAdsWithTag(_ adTagUrl: String!) {
        print(adTagUrl)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: createAdDisplayContainer(),
            avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: self.videoPlayer),
            pictureInPictureProxy: pictureInPictureProxy,
            userContext: nil)
        print(request)
        if(Common.Isuserissubscribe(Userdetails: self))
        {
            
            adsLoader = nil
            if(self.videoPlayer != nil)
            {
                bPlay = true
                expandBtnAction()
            }
            
            
        }
        else
        {
            adsLoader.requestAds(with: request)
            
        }
        
    }
    
    
    // Notify IMA SDK when content is done for post-rolls.
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if ((notification.object as? AVPlayerItem) == self.videoPlayer!.currentItem) {
            adsLoader.contentComplete()
        }
    }
    
    // MARK: AdsLoader Delegates
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        adsManager = adsLoadedData.adsManager
        adsManager!.delegate = self
        // Create ads rendering settings to tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.webOpenerPresentingController = self
        // Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        print(adErrorData.adError.message)
        //isAdPlayback = false
        isplaydfturl = false
        
        if(self.videoPlayer != nil)
        {
            if(isplaycromecast)
            {
            }
            else
            {
                if(self.videoPlayer != nil)
                {
                    bPlay = true
                    expandBtnAction()
                }
                
            }
        }
        else
        {
            
        }
        
        removeLoaderAfter()
    }
    
    
    // MARK: AdsManager Delegates
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print(event.typeString!)
        
        
        if(event.typeString! == "Started")
        {
            removeLoaderAfter()
            self.bHideControl = false
            self.singleTapped()
        }
        if(event.typeString! == "Skipped")
        {
            
            bPlay = true
            expandBtnAction()
        }
        
        switch (event.type) {
        case IMAAdEventType.LOADED:
            if (pictureInPictureController == nil ||
                !pictureInPictureController!.isPictureInPictureActive) {
                adsManager.start()
            }
            break
        case IMAAdEventType.PAUSE:
            print("PAUSE")
            break
        case IMAAdEventType.RESUME:
            print("RESUME")
            break
        case IMAAdEventType.TAPPED:
            print("TAPPED")
            break
        default:
            break
        }
    }
    
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        print(error.message)
        //  isAdPlayback = false
        if(self.videoPlayer != nil)
        {
            isplaydfturl = false
            if(isplaycromecast)
            {
            }
            else
            {
                self.videoPlayer.play()
                bPlay = true
                expandBtnAction()
            }
        }
        removeLoaderAfter()
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        //isAdPlayback = true
        if(self.videoPlayer != nil)
        {
            //self.videoPlayer.pause()
        }
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        //isAdPlayback = false
        if(self.videoPlayer != nil)
        {
            isplaydfturl = false
            self.videoPlayer.play()
            
            
            
        }
        removeLoaderAfter()
    }
    
    
    
    
    
    //MARK:- Make skip button enalbel
    
    func makeskipbuttonenalbel()
    {
        
        skiptime = skiptime + 1
        if(skiptime<6)
        {
            Skipbutton.isUserInteractionEnabled = false
            self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(12))
            Skipbutton.setTitle("Skip After \(skiptime) Sec", for: .normal)
        }
        else
        {
            Skipbutton.isUserInteractionEnabled = true
            self.Skipbutton.titleLabel?.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            Skipbutton.setTitle("SKIP", for: .normal)
        }
        
        
        
    }
    
    //MARK:- Make stop timer
    func stopTimer() {
        skiptimer.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
    }
    
    
    
    //MARK:- Skip button action
    
    func taptoskip()
    {
        Skipbutton.isHidden = true
        isplayadd = false
        self.avLayer.removeFromSuperlayer()
        self.avLayer = nil
        self.videoPlayer = nil
        
        
        if(isprerole)
        {
            self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
            isprerole = false
            
        }
        else
        {
            
            
        }
        
        
    }
    
    
    
    //MARK:- Video player playing Updata Method
    
    func update()
    {
        if self.videoPlayer != nil && (self.videoPlayer.currentItem != nil)
        {
            let currentItem:AVPlayerItem = videoPlayer.currentItem!
            let duration:CMTime = currentItem.duration
            let videoDUration:Float = Float(CMTimeGetSeconds(duration))
            let currentTime:Float = Float(CMTimeGetSeconds(videoPlayer.currentTime()))
            
            if self.bSlideBar == true
            {
                let time = Int(currentTime)
                let timePlay = Int(self.playbackSlider.value)
                print("currentTime ",time)
                print("self.playbackSlider.value >>",timePlay)
                if time == timePlay {
                    self.bSlideBar = false
                }
            }
            else
            {
                self.playbackSlider.value = currentTime
            }
            
            
            
            if(Common.isInternetAvailable())
            {
                
                if(!isplayadd)
                {
                    
                    
                    let currentplayertimeint = Int(self.playbackSlider.value)
                    let currentplayertime = String(currentplayertimeint)
                    
                    print("/////////////////////////////")
                    
                    print("video current playing time -> \(currentplayertime)")
                    
                    LoginCredentials.VideoPlayingtime = currentplayertimeint
                    LoginCredentials.Contantplaytime = currentplayertimeint
                    
                    if(midrolequepointarray.contains(currentplayertime))
                    {
                        
                        print("Find Midrole playing time -> \(midrolequepointarray)")
                        isprerole = false
                        isplayadd = true
                        ismidrolepresent = true
                        midroletime = self.playbackSlider.value
                        
                    }
  
                    
                }
                else
                {
                    
                    let currentplayertimeint12 = Int(self.playbackSlider.value)
                    print("LoginCredentials.Addtime -> \(LoginCredentials.Addtime)")
                    print("add time current playing -> \(currentplayertimeint12)")
                    LoginCredentials.Addtime =  currentplayertimeint12
                    
                    
                    
                    
                }
            }
            let (hr,  minf) = modf (currentTime / 3600)
            let (min, secf) = modf (60 * minf)
            let second:Float =  60 * secf
            
            let time = String(format: "%.0f:%.0f:%.0f", hr,min, second)
            self.lblLeft.text = time
            
            // playerTime = Int(currentTime)
        }
    }
    
    //MARK:- Player Delegate
    
    func removeLoaderAfter()
    {
        self.stoploader()
    }
    func stoploader()
    {
        if(activityIndicator != nil)
        {
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    func addPlayeraddtime()
    {
        if(isplayadd)
        {
            let currentplayertimeint = Int(self.playbackSlider.value)
            // LoginCredentials.Addtime =  currentplayertimeint
            // print("\("Add Time   >")\(LoginCredentials.Addtime)")
        }
    }
    
    func startplayingnotification(note: NSNotification)
    {
        
        
        self.stoploader()
        
        
        //////
        // let image = UIImage(named:"pause")
        //  self.expandBtn.setImage(image, for: .normal)
        
        
        castButton.isUserInteractionEnabled = true
        if(LoginCredentials.Ispressback)
        {
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                self.videoPlayer = nil
            }
        }
        
        
        
        Common.stoploderonplayer(view: self.view)
        if(isplayadd)
        {
            
            
            Playeraddtime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addPlayeraddtime), userInfo: nil, repeats: true);
            
            
            
            if(ismidrolepresent)
            {
                Skipbutton.isHidden = true
            }
            else
            {
                Skipbutton.isHidden = false
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.makeskipbuttonenalbel), userInfo: nil, repeats: true)
            removeLoaderAfter()
            let eventarray =  Event_dict.value(forKey: "events") as! NSArray
            for i in 0..<eventarray.count
            {
                if(((eventarray.object(at: i) as! NSDictionary).value(forKey: "event") as! String) == "vast_impression")
                {
                    
                    let url = (eventarray.object(at: i) as! NSDictionary).value(forKey: "URL") as! String
                    self.calladdeventurl(url: url)
                }
            }
            
            
        }
        else
        {
            if(!isplaydfturl)
            {
                
                
                self.perform(#selector(removeLoaderAfter), with: nil, afterDelay: 1.0)
            }
            Skipbutton.isHidden = true
            
            if Playeraddtime != nil
            {
                Playeraddtime.invalidate()
                Playeraddtime  = nil
            }
            
            
            
            
            
            
        }
        
    }
    
    
    
    
    func playerDidFinishPlaying(note: NSNotification)
    {
        
        
        
        
        self.PlayNextvideoinmoresection()
        //        if Playeraddtime != nil
        //        {
        //            Playeraddtime.invalidate()
        //            Playeraddtime  = nil
        //        }
        //
        //
        //      if(isplayadd)
        //      {
        //        isplayadd = false
        //        Skipbutton.isHidden = true
        //         if(ismidrolepresent)
        //        {
        //            playseektime(seektime: midroletime)
        //            ismidrolepresent = false
        //        }
        //        else
        //         {
        //            isprerole = false
        //            self.setvideodata(titile: tilttext, like: liketext, des: descriptiontext, url:Video_url)
        //
        //
        //        }
        //
        //
        //        }
        //        else
        //      {
        //        LoginCredentials.isvideostartorendtime = "2"
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "heartBeatapi"), object: nil)
        //
        //
        //        if(Common.Islogin())
        //        {
        //            LoginCredentials.isvideostartorendtime = ""
        //            LoginCredentials.Video_sid = ""
        //
        //
        //        }
        //        else
        //        {
        //            Common.stopHeartbeat()
        //
        //        }
        //
        //        }
        
    }
    
    
    
    
    //MARK:- Rotation add
    
    
    func rotateddd()
    {
        if(self.avLayer != nil)
        {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
            {
                bEnlarge = true
                Bottomviewuppercnstraint.constant = 300.0
                let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
                self.avLayer.frame = rect
                backbutton.isHidden = false
                backwordbuttonuppercnstraint.constant = rect.size.height/2-20
                let rectPlay = CGRect(x:10, y:self.view.frame.size.height-45, width:self.view.frame.size.width-20, height:25)
                self.playbackSlider.frame = rectPlay
                self.soundbackSlider.frame = rectPlay
                let rectsound = CGRect(origin: CGPoint(x: 5,y :self.view.frame.size.height-19), size: CGSize(width: 20, height: 20))
                self.soundcontrolbutton.frame = rectsound
                let rectLeft = CGRect(origin: CGPoint(x: 30,y :self.view.frame.size.height-15), size: CGSize(width: 30, height: 10))
                lblLeft.frame = rectLeft
                let rectRight = CGRect(origin: CGPoint(x: lblLeft.frame.origin.x+lblLeft.frame.size.width,y :self.view.frame.size.height-15), size: CGSize(width: 40, height: 10))
                lblEnd.frame = rectRight
                expandBtn.isHidden = true
                let rectsecuritylabel = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :30), size: CGSize(width: 100, height: 50))
                self.securitylabel.frame = rectsecuritylabel
                
                let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-50,y :self.view.frame.size.height/2 - 30.0), size: CGSize(width: 50, height: 50))
                self.expandBtn.frame = rectMore
                let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-40,y :self.view.frame.size.height-25), size: CGSize(width: 20, height: 20))
                enlargeBtn.frame = rectEnlarge
                enlargeBtn.setImage(#imageLiteral(resourceName: "expandPlayerrotation"), for: .normal)
                
                let rectsetting = CGRect(origin: CGPoint(x: self.view.frame.size.width-90,y :self.view.frame.size.height-25), size: CGSize(width: 20, height: 20))
                self.settingbutton.frame = rectsetting
                
                let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :self.view.frame.size.height-35), size: CGSize(width: 95, height: 30))
                Skipbutton.frame = skipEnlarge
                
                let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-60,y :self.view.frame.size.height-64), size: CGSize(width: 90, height: 90))
                enlargeBtnLayer.frame = rectEnlargeLayer
                
                self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
                
                activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
                backwordbutton.isHidden = true
                forwardbutton.isHidden = true
                forword10secbutton.isHidden = true
                self.castButton.isHidden = true
                
                
                Resolutionbutton.isHidden = true
                self.view.bringSubview(toFront: enlargeBtn)
                self.view.bringSubview(toFront: enlargeBtnLayer)
                self.view.bringSubview(toFront: forwardbutton)
                self.view.bringSubview(toFront: forword10secbutton)
                self.view.bringSubview(toFront: castButton)
                self.view.bringSubview(toFront: backwordbutton)
                self.view.bringSubview(toFront: Resolutionbutton)
                self.view.bringSubview(toFront: soundcontrolbutton)
                
                bHideControl = true
                self.playbackSlider.isHidden = true
                self.lblLeft.isHidden = true
                self.lblEnd.isHidden = true
                self.soundcontrolbutton.isHidden = true
                self.enlargeBtn.isHidden = true
                self.enlargeBtnLayer.isHidden = true
                self.expandBtn.isHidden = true
            }
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
            {
                bEnlarge = false
                Bottomviewuppercnstraint.constant = 170.0
                print("Portrait")
                self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
                var rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 200))
                if(isdeviceiphonex() == "iPhone X") {
                    print("Iphone X")
                    Bottomviewuppercnstraint.constant = 230.0
                    self.tempView.frame = CGRect(origin: CGPoint(x: 0,y :60), size: CGSize(width: self.view.frame.size.width, height: 200))
                    rect = CGRect(origin: CGPoint(x: 0,y :60), size: CGSize(width: self.view.frame.size.width, height: 200))
                    
                }
                
                
                
                
                self.avLayer.frame = rect
                backbutton.isHidden = false
                var rectPlay = CGRect(x:10, y:150, width:self.view.frame.size.width-20, height:25)
                let soundPlay = CGRect(x:10, y:150, width:self.view.frame.size.width-20, height:25)
                if(isdeviceiphonex() == "iPhone X") {
                    rectPlay = CGRect(x:10, y:210, width:self.view.frame.size.width-20, height:25)
                }
                self.playbackSlider.frame = rectPlay
                self.soundbackSlider.frame = soundPlay
                let rectMore = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-50,y :70), size: CGSize(width: 50, height: 50))
                self.expandBtn.frame = rectMore
                backwordbuttonuppercnstraint.constant = 60.0
                if(isdeviceiphonex() == "iPhone X") {
                    backwordbuttonuppercnstraint.constant = 95.0
                }
                
                let rectsecuritylabel = CGRect(origin: CGPoint(x: self.view.frame.size.width/2-20,y :15), size: CGSize(width: 100, height: 50))
                self.securitylabel.frame = rectsecuritylabel
                
                let soundLeft = CGRect(origin: CGPoint(x: 5,y :180), size: CGSize(width: 20, height: 20))
                soundcontrolbutton.frame = soundLeft
                
                let rectLeft = CGRect(origin: CGPoint(x: 30,y :184), size: CGSize(width: 30, height: 10))
                lblLeft.frame = rectLeft
                let rectRight = CGRect(origin: CGPoint(x: lblLeft.frame.origin.x+lblLeft.frame.size.width,y :184), size: CGSize(width: 40, height: 10))
                lblEnd.frame = rectRight
                
                let rectEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-30,y :184), size: CGSize(width: 15, height: 15))
                enlargeBtn.frame = rectEnlarge
                enlargeBtn.setImage(#imageLiteral(resourceName: "expandPlayer"), for: .normal)
                
                let rectsetting = CGRect(origin: CGPoint(x: self.view.frame.size.width-75,y :180), size: CGSize(width: 40, height: 20))
                self.settingbutton.frame = rectsetting
                
                
                let skipEnlarge = CGRect(origin: CGPoint(x: self.view.frame.size.width-105,y :160), size: CGSize(width: 95, height: 30))
                Skipbutton.frame = skipEnlarge
                
                
                
                let rectEnlargeLayer = CGRect(origin: CGPoint(x: self.view.frame.size.width-70,y :120), size: CGSize(width: 120, height: 90))
                enlargeBtnLayer.frame = rectEnlargeLayer
                activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
                self.Mycollectionview.reloadData()
            }
        }
    }
    
    
    //MARK:- Control sound action
    
    func controlsound(button:UIButton)
    {
      //  let volume = AVAudioSession.sharedInstance().outputVolume
      //  print(volume)
        self.soundbackSlider.value = Float(volume.volumeLevel)
        playbackSlider.isHidden = true
        soundbackSlider.isHidden = false
 
        //         DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
        //            self.bHideControl = false
        //            self.singleTapped()
        //
        //        })
        
    }
    

    
    //MARK:- Sound Slider Change notifation method
    
    func soundSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        
        try? volume.setVolumeLevel(Double(playbackSlider.value))
        
       // try? volume.increseVolume(by: Double(playbackSlider.value), animated: true)
        
        
        //try? volume.increaseVolume(by: playbackSlider.value, animated: true)
        
        print("\("Sound volueme is ")\(playbackSlider.value)")
     //   self.videoPlayer.volume = playbackSlider.value
        let vol = String(format: "%.1f", playbackSlider.value)
        print(vol)
        switch vol {
        case "0.0":
             self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_mute"), for: .normal)
            break
        case "0.3":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_33"), for: .normal)
            break
        case "0.6":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_66"), for: .normal)
            break
        case "1.0":
            self.soundcontrolbutton.setImage(#imageLiteral(resourceName: "sound_100"), for: .normal)
            break
        default:
            break
        }
        
        
    }
    
    //MARK:- UISlider Change notifation method
    
    func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        
        
        if self.videoPlayer!.rate == 0
        {
            self.isplayorpause()
        }
    }
    
    
    //MARK:- Chage Player seek time
    
    func playseektime(seektime:Float)
    {
        self.playvideo(url: Video_url)
        self.perform(#selector(playeseektime), with: nil, afterDelay: 3.0)
        
        
        
    }
    
    func playeseektime()
    {
        
        
        
        let seconds : Int64 = Int64(midroletime+10)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        if self.videoPlayer!.rate == 0
        {
            self.videoPlayer?.play()
        }
        
    }
    
    
    //MARK:- On Player Single Tap action
    
    func singleTapped() {
        
        self.tempView.removeGestureRecognizer(singletap)
        self.singletap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapped))
        self.singletap.numberOfTapsRequired = 1
        if !self.isplayadd
        {
            self.tempView.addGestureRecognizer(self.singletap)
        }
        if bHideControl == true
        {
            
            // self.perform(#selector(self.removecontroleronvideofter3sec), with: self, afterDelay: 4)
            //            let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
            //            DispatchQueue.main.asyncAfter(deadline: when) {
            //
            //                self.removecontroleronvideofter3sec()
            //            }
            bHideControl = false
            self.playbackSlider.isHidden = false
            self.lblLeft.isHidden = false
            self.lblEnd.isHidden = false
            self.enlargeBtn.isHidden = false
            self.enlargeBtnLayer.isHidden = false
            backwordbutton.isHidden = false
            forwardbutton.isHidden = false
            forword10secbutton.isHidden = false
            castButton.isHidden = false
            
            Resolutionbutton.isHidden = true
            settingbutton.isHidden = false
            self.expandBtn.isHidden = false
            self.soundcontrolbutton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.singleTapped()
            })
        }
        else
        {
            //NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.removecontroleronvideofter3sec), object: nil)
            bHideControl = true
            self.playbackSlider.isHidden = true
            self.lblLeft.isHidden = true
            self.lblEnd.isHidden = true
            self.enlargeBtn.isHidden = true
            self.enlargeBtnLayer.isHidden = true
            backwordbutton.isHidden = true
            forwardbutton.isHidden = true
            forword10secbutton.isHidden = true
            castButton.isHidden = true
            Resolutionbutton.isHidden = true
            self.expandBtn.isHidden = true
            self.soundcontrolbutton.isHidden = true
            soundbackSlider.isHidden = true
            settingbutton.isHidden = true
        }
        
    }
    
    
    
    
    
    
    //MARK:- Tap to oritation
    
    
    func enlargeBtnAction()
    {
        if bEnlarge == true {
            bEnlarge = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        else
        {
            bEnlarge = true
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
    }
    
    //MARK:- Tap to Play Or Paush video player

    func expandBtnAction()
    {
        if bPlay == true
        {
            if(self.videoPlayer != nil)
            {
                self.videoPlayer.play()
            }
            
            bPlay = false
            let image = UIImage(named:"pause")
            self.expandBtn.setImage(image, for: .normal)
            
        }
        else
        {
            if(self.videoPlayer != nil)
            {
                self.videoPlayer.pause()
            }
            bPlay = true
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
        }
    }
    
    func forcefullylandscape()
    {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    
    //MARK:- startloader on player view
    
    func startloader()
    {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: CGFloat(self.tempView.frame.size.width/2-25), y: CGFloat(self.tempView.frame.size.height/2-25), width:CGFloat(50), height: CGFloat(50))
        activityIndicator.startAnimating()
        self.tempView.addSubview(activityIndicator)
    }

    
    
    //MARK:- Getmorevideo
    func getmorevideo()
    {
        let parameters = [
            "device": "ios",
            "cat_id": catid,
            "content_id":cat_id
            ] as [String : Any]
        //  let url = String(format: "%@%@/device/ios/cat_id/%@/content_id/%@", LoginCredentials.Listapi,Apptoken,catid,cat_id)
        
        let url = String(format: "%@%@/device/ios/current_offset/0/max_counter/10/cat_id/%@", LoginCredentials.Listapi,Apptoken,catid)
        
        // http://staging.multitvsolution.com:9000/api/v6/content/list/token/59a942cd8175f/device/web/current_offset/0/max_counter/10/cat_id/99
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptListapi)
                {
                    let number = dict.value(forKey: "code") as! NSNumber
                    if(number == 0)
                    {
                        self.moredataarray = NSArray()
                        self.Mycollectionview.reloadData()
                        return
                    }
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                 }
                print(Catdata_dict)
                self.moredataarray = Catdata_dict.value(forKey: "content") as! NSArray
                //self.scrollviewheighltcontrant.constant = (CGFloat(self.moredataarray.count/2) * 141.0)
                self.Mycollectionview.reloadData()
                // self.mytableview.reloadData()
                
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    //MARK:- Getuserrelatedvideo
    
    func getuserrelatedvideo()
    {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        var parameters = [String:String]()
        if (dict.count>0)
        {
            
            parameters = [
                "device": "ios",
            ]
        }   
        else
        {
            parameters = [
                "device": "ios",
            ]
            
        }
        
        
        
        let url = String(format: "%@%@/device/ios/current_offset/0/max_counter/50", LoginCredentials.Recomendedapi,Apptoken)
        print(url)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                let dict = responseObject as! NSDictionary
                
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    return
                }
                
                var Catdata_dict = NSMutableDictionary()
                if(LoginCredentials.IsencriptRecomendedapi)
                {
                    Catdata_dict = (dict.value(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                }
                print(Catdata_dict)
                self.recomdentdedataarray = Catdata_dict.value(forKey: "content") as! NSArray
                // self.Mycollectionview.reloadData()
                
                // self.mytableview.reloadData()
                
                
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
        }
        
    }
    
    
    //MARK:- Taptodownload Acrion
    @IBAction func Taptodownload(_ sender: UIButton)
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            
            
            if(!checkinterconnection())
            {
                return
            }
            
            if(downloadVideo_url == "")
            {
                EZAlertController.alert(title: "Can't Download This Video")
                return
                
            }
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let destinationURLForFile = URL(fileURLWithPath: path.appendingFormat("/\((dict.value(forKey: "id") as! NSNumber).stringValue)\(self.cat_id).mp4"))
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationURLForFile.path) {
                print("FILE AVAILABLE")
                EZAlertController.alert(title: "This Video already exists in your download section")
                return
                
            } else
            {
                
                
                let array = dataBase.getdownloadvideoid(userid: (dict.value(forKey: "id") as! NSNumber).stringValue)
                if(array.contains(cat_id))
                {
                    print("id is match")
                    Showpopupmsg(msg: "\(tilttext) video already in downloading")
                }
                else
                {
                    self.saveDownloaddataincoredata()
                    Showpopupmsg(msg: "\(tilttext) video start downloading")
                    self.downloadwithurl(urlstr: self.downloadVideo_url)
                    self.animatedownloadbutton()
                }
                
            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to download video")
            
            
        }
    }
    
    
    //MARK:- Show notification pop up message
    
    func Showpopupmsg(msg:String)
    {
        let view = MessageView.viewFromNib(layout:.MessageView)
        view.configureTheme(.info)
        view.configureDropShadow()
        view.configureContent(title: "YUV", body: msg, iconText:"")
        SwiftMessages.show(view: view)
    }
    
    
    //MARK:- SaveDownloaddataincoredata
    
    func saveDownloaddataincoredata()
    {
        DispatchQueue.global(qos: .background).async {
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            print(self.Download_dic)
            
            if(Common.isNotNull(object: self.Download_dic.value(forKey: "thumbs") as AnyObject))
            {
            if((self.Download_dic.value(forKey: "thumbs") as! NSArray).count>0)
            {
                let url = (((self.Download_dic.value(forKey: "thumbs") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                let videoimage = NSData.init(contentsOf: URL(string: url)!)
                dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage!)
            }
            else
            {
                
                let videoimage = UIImagePNGRepresentation(#imageLiteral(resourceName: "Placehoder")) as NSData?
                dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage!)
            }
            }
            else
            {
                let videoimage = UIImagePNGRepresentation(#imageLiteral(resourceName: "Placehoder")) as NSData?
                dataBase.SaveDownloadvideo(Userid: (dict.value(forKey: "id") as! NSNumber).stringValue, Videoid: self.cat_id, data: self.Download_dic, image:videoimage!)
            }
            
        }
        
    }
    //MARK:- Taptoshare
    
    @IBAction func Taptoshare(_ sender: UIButton) {
        let text = "I am watching this awesome video \(shareurlnew) on YUV. \n Visit YUV app on App Store"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.copyToPasteboard,UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Taptodislike
    @IBAction func Taptodislike(_ sender: UIButton) {
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            if(!checkinterconnection())
            {
                return
            }
            var parameters = [String:String]()
            if(!isdislike)
            {
                
                dislikecount =  dislikecount + 1
                
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "dislike":"1",
                    "content_type":"video",
                    "channel_id":chnl_id
                ]
            }
            else
            {
                dislikecount =  dislikecount - 1
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "dislike":"0",
                    "content_type":"video",
                    "channel_id":chnl_id
                    
                ]
                
            }
            
            
            if(self.isdislike)
            {
                self.isdislike = false
                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
                
            }
            else
                
            {
                self.isdislike = true
                self.dislikebutton.setImage(UIImage.init(named: "dislike"), for: .normal)
                
                
            }
            
            
            
            if(islike)
            {
                likecount =  likecount - 1
                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                islike = false
            }
            
            
            if(self.dislikecount<0)
            {
                dislikecount = 0
            }
            if(likecount<0)
            {
                likecount = 0
            }
            self.dislikelabel.text = "\(self.dislikecount)"
            self.likelabel.text = "\(self.likecount)"
            
            
            
            let url = String(format: "%@%@", LoginCredentials.Dislikeapi,Apptoken)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                    
                    
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
            
            
        }
        
    }
    
    //MARK:- Taptofavrout
    
    @IBAction func Taptofavrout(_ sender: UIButton) {
        
        if(!Common.isInternetAvailable())
        {
            EZAlertController.alert(title: "No Internet connection")
            return
        }
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            if(!checkinterconnection())
            {
                
                return
            }
            var parameters = [String:String]()
            if(!isfav)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"1",
                    "content_type":"video",
                ]
 
            }
            else
            {
                
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "favorite":"0",
                    "content_type":"video",
                 ]
             }
            
           
            if(self.isfav)
            {
                self.Favroutbutton.setImage(UIImage.init(named: "favriout"), for: .normal)
                self.isfav = false
               //JYToast.init().isShow("Removed from favorite videos")
                self.view.makeToast("Removed from favorite videos", duration: 1.0, position: .center)
            }
            else
            {
                self.Favroutbutton.setImage(UIImage.init(named: "favriout1"), for: .normal)
                self.isfav = true
                self.view.makeToast("Added to favorite videos", duration: 1.0, position: .center)
             }
 
            let url = String(format: "%@%@", LoginCredentials.Favrioutapi,Apptoken)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
     
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
            
        }

    }
    
    //MARK:- Taptolike
    
    @IBAction func Taptolike(_ sender: UIButton) {
        
        
        
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            if(!checkinterconnection())
            {
                return
            }
            var parameters = [String:String]()
            if(!islike)
            {
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"1",
                    "content_type":"video",
                    "channel_id":chnl_id
                ]
                likecount =  likecount + 1
                
            }
            else
            {
                
                parameters = [
                    "device": "ios",
                    "type": "video",
                    "content_id":cat_id,
                    "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                    "like":"0",
                    "content_type":"video",
                    "channel_id":chnl_id
                ]
                likecount =  likecount - 1
                //dislikecount =  dislikecount + 1
            }
            
            
            if(self.islike)
            {
                self.likebutton.setImage(UIImage.init(named: "likedisable"), for: .normal)
                self.islike = false
                toast.isShow("Removed from liked videos")
                
                
            }
            else
            {
                self.likebutton.setImage(UIImage.init(named: "like"), for: .normal)
                self.islike = true
                toast.isShow("Added to liked videos")
                
                
            }
            
            
            if(self.isdislike)
            {
                dislikecount =  dislikecount - 1
                self.isdislike = false
                self.dislikebutton.setImage(UIImage.init(named: "dislikedisable"), for: .normal)
            }
            
            
            if(self.dislikecount<0)
            {
                dislikecount = 0
            }
            if(likecount<0)
            {
                likecount = 0
            }
            
            
            
            self.dislikelabel.text = "\(self.dislikecount)"
            self.likelabel.text = "\(self.likecount)"
            
            let url = String(format: "%@%@", LoginCredentials.Likeapi,Apptoken)
            print(url)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
       
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
                Common.stoploderonplayer(view: self.view)
            }
            
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
            
        }
        
        
    }
    
    
    
    func  backactionnotofication()
    {
 
            if(securitykeytimer != nil)
            {
                securitykeytimer?.invalidate()
            }
            LoginCredentials.Ispressback = true
            Common.callappanalytics()
            if Playeraddtime != nil
            {
                Playeraddtime.invalidate()
                Playeraddtime  = nil
            }
            
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                self.videoPlayer = nil
            }
            
            if (adsManager != nil)
            {
                adsManager!.destroy()
                adsManager = nil
            }
            
            
            
        
        
    }
    
    
    func backstoppalyer()
    {
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
    }
    
    
    //MARK:- Taptoback
    @IBAction func Taptoback(_ sender: UIButton) {
        
        
         if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
         {
        if(self.avLayer != nil)
        {
           enlargeBtnAction()
            return
         }
        }
        
        Common.DeActivateUsersession()
        if(securitykeytimer != nil)
        {
            securitykeytimer?.invalidate()
        }
        LoginCredentials.Ispressback = true
        Common.callappanalytics()
        if Playeraddtime != nil
        {
            Playeraddtime.invalidate()
            Playeraddtime  = nil
        }
        LoginCredentials.isvideostartorendtime = "2"
        if(Common.Islogin())
        {
            
            LoginCredentials.isvideostartorendtime = ""
            LoginCredentials.Video_sid = ""
            
        }
        else
        {
            Common.stopHeartbeat()
            
        }
        
        
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        
        
        adsLoader = nil
        if (adsManager != nil)
        {
            adsManager!.destroy()
            adsManager = nil
        }
        
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.backstoppalyer()
        })
        
        
        if(Isfromdeeplinking)
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        else
        {
            if self.isViewLoaded && (self.view.window != nil) {
                (self.navigationController?.popViewController(animated: true))!
            }
        }
    }
    
    //MARK:- MXSegmentedPager Set menu
    
    func setmenu()
    {
        
        
        
        mXSegmentedPager = MXSegmentedPager.init(frame: CGRect.init(x: 0, y: ratingview.frame.origin.y+ratingview.frame.size.height, width: self.view.frame.size.width, height: 41))
        mXSegmentedPager.frame.origin.y = channelview.frame.origin.y
        mXSegmentedPager.segmentedControl.selectionIndicatorLocation = .down
        mXSegmentedPager.segmentedControl.backgroundColor =  UIColor(red: 16/255, green: 16/255, blue: 16/255, alpha: 1.0)
        
        mXSegmentedPager.segmentedControl.selectionIndicatorColor = UIColor.white
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        mXSegmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 14.0) as Any]
        mXSegmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        //mXSegmentedPager.segmentedControlPosition = .bottom
        mXSegmentedPager.dataSource = self
        mXSegmentedPager.delegate = self
        self.myscroolview.addSubview(mXSegmentedPager)
        
    }
    
    
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int
    {
        return 2
    }
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String
    {
        switch index {
        case 0:
            return "More Videos"
        case 1:
            return "Trending"
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
            self.ismore = true
            self.Mycollectionview.reloadData()
            //self.scrollviewheighltcontrant.constant = (CGFloat(self.moredataarray.count/2) * 141.0)
            //  mytableview.reloadData()
            print(index)
            
        case 1:
            self.ismore = false
            self.Mycollectionview.reloadData()
            // self.scrollviewheighltcontrant.constant = (CGFloat(self.recomdentdedataarray.count/2) * 141.0)
            //  mytableview.reloadData()
            print(index)
            
        default:
            break
        }
        
    }
    
    
    //MARK:-tableView delagate method
    
    //       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //
    //
    //        let height = calculatecommentContentHeight(str: ((commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "comment") as? String)!)
    //
    //
    //        print("///////////////////////User Comment height///////////////////")
    //         print((commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "comment") as! String)
    //        print(height)
    //        print("///////////////////////End Comment height///////////////////")
    //        if(height<35)
    //        {
    //          return 70 + height
    //        }
    //       else if(height>35 || height<90)
    //            {
    //              return 120 + height
    //            }
    //        else
    //        {
    //        return 150 + height
    //        }
    //        //  return  UITableViewAutomaticDimension
    //    }
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        if(tableView == commenttableview)
        {
            
            
            return self.commentdataarray.count
        }
        else
        {
            
            return 0
            
        }
        return 0
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let SimpleTableIdentifier:NSString = "cell"
        var cell:Custometablecell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? Custometablecell
        
        if(tableView == commenttableview)
        {
            cell = Bundle.main.loadNibNamed("Custometablecell", owner: self, options: nil)?[2] as! Custometablecell
            cell.selectionStyle = .none
            
            Common.getRoundImage(imageView: cell.commentuserimageview, radius: 25.0)
            
            if(Common.isNotNull(object: (commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "u_thumb") as AnyObject?))
            {
                var url  = (commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "u_thumb") as! String
                if(url == "")
                {
                    cell.commentuserimageview.image = #imageLiteral(resourceName: "userprofile")
                }
                else{
                    let urlImg = URL(string:url)
                    cell.commentuserimageview.sd_setImage(with: urlImg, placeholderImage: #imageLiteral(resourceName: "userprofile"), options: .highPriority, completed: nil)
                    // url = Common.getsplitnormalimageurl(url: url)
                    //  cell.commentuserimageview.setImageWith(URL(string: url)!, placeholderImage: #imageLiteral(resourceName: "userprofile"))
                    
                }
            }
            else
                
            {
                cell.commentuserimageview.image = #imageLiteral(resourceName: "userprofile")
            }
            
            cell.commentnamelabel.text = (commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "u_name") as? String
            cell.commentdes_label.text = (commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "comment") as? String
            
            
            
            let releaseDate = (commentdataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as! String
            let futureDateFormatter = DateFormatter()
            futureDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: NSDate = futureDateFormatter.date(from: releaseDate)! as NSDate
            
            let currentDate = NSDate();
            let currentFormatter = DateFormatter();
            currentFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            currentFormatter.timeZone = NSTimeZone(abbreviation: "GMT+2:00") as TimeZone!
            
            
            let CompetitionDayDifference = NSCalendar.current.dateComponents([.day,.hour,.minute], from: date as Date, to: currentDate as Date)
            
            
            let countdown = " \(CompetitionDayDifference.day) d: \(CompetitionDayDifference.hour) h: \(CompetitionDayDifference.minute) min"
            print(countdown)
            var countstr = String()
            var counttime = Int()
            if((CompetitionDayDifference.day! as Int) != 0)
            {
                counttime = CompetitionDayDifference.day! as Int
                countstr = "\(counttime)\(" Days ago")"
            }
            else if((CompetitionDayDifference.hour! as Int) != 0)
            {
                counttime = CompetitionDayDifference.hour! as Int
                countstr = "\(counttime)\(" Hours ago")"
                
            }
            else if((CompetitionDayDifference.minute! as Int) != 0)
            {
                counttime = CompetitionDayDifference.minute! as Int
                countstr = "\(counttime)\(" min ago")"
                
            }
            else
            {
                countstr = "Just Now"
            }
            
            
            print(counttime)
            
            cell.commenttimelabel.text  = countstr
            cell.abusebutton.addTarget(self, action: #selector(taptoreportabuserusecomment(button:)), for: .touchUpInside)
            
            
            
            
        }
        else
        {
            
            
            
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if(tableView == commenttableview)
        {
            return
        }
        
        if Common.Islogin()
        {
            midroletime = 0.0
            skiptime = 0
            self.bHideControl = false
            self.singleTapped()
            Download_dic.removeAllObjects()
            fromdownload = "no"
            if ismore
            {
                
                Download_dic = (moredataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.cat_id = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
                tilttext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
                liketext =  (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes") as! String
                
                
                if(Common.isNotNull(object: (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
                {
                    self.descriptiontext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
                }
                else
                {
                    self.descriptiontext = ""
                }
                
                getplayerurl()
                
                
                
            }
            else
            {
                
                
                
                Download_dic = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.cat_id = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
                tilttext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
                liketext =  (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "likes") as! String
                
                
                
                if(Common.isNotNull(object: (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
                {
                    self.descriptiontext = (recomdentdedataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
                }
                else
                {
                    self.descriptiontext = ""
                }
                
                getplayerurl()
                Common.startloderonplayer(view: self.view)
                UIApplication.shared.endIgnoringInteractionEvents();
                
                
                
            }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please login to access this section")
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(tableView == commenttableview)
        {
            if(Isendcomment)
            {
                return
            }
            if indexPath.row + 1 == commentdataarray.count {
                print("Go TO LAST COMMENT TABLE VIEW INDEX")
                Iscommentloadmore = true
                self.getusercomment()
            }
        }
    }
    
    
    //MARK:reportabuseruser
    
    func taptoreportabuserusecomment(button:UIButton)
    {
        let optionMenu = UIAlertController(title: nil, message: "Report/Abuse", preferredStyle: .actionSheet)
        
        let fullAction = UIAlertAction(title: "Report", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.callreportabuseapi(sender: button)
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.addAction(fullAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    func callreportabuseapi(sender:UIButton)
    {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.commenttableview)
        let cellIndexPath = self.commenttableview.indexPathForRow(at: pointInTable)
        
        
        
        
        if(Common.Islogin())
        {
            print(self.commentdataarray.object(at: (cellIndexPath?.row)!))
            let commentid = ((self.commentdataarray.object(at: (cellIndexPath?.row)!) as! NSDictionary).value(forKey: "id") as! NSNumber).stringValue
            self.commentdataarray.removeObject(at: (cellIndexPath?.row)!)
            self.commenttableview.reloadData()
            let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
            EZAlertController.alert(title: "successfully report post.")
            
            
            
            
            //                var parameters = [String : Any]()
            //                parameters = [
            //                               "user_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
            //                               "device":"ios",
            //                               "comment_id": commentid,
            //                               "abuse": "1"
            //                ]
            //
            //                let url = String(format: "%@%@", LoginCredentials.Abuseapi,Apptoken)
            //                print(url)
            //
            //                let manager = AFHTTPSessionManager()
            //                manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            //                    if (responseObject as? [String: AnyObject]) != nil {
            //
            //                        let dict = responseObject as! NSDictionary
            //                        print(dict)
            //
            //
            //                        if((dict.value(forKey: "code") as! NSNumber).stringValue == "0")
            //                        {
            //                            EZAlertController.alert(title: "Error!")
            //                        }
            //                        else
            //                        {
            //
            //                            EZAlertController.alert(title: "successfully report post.")
            //
            //
            //                        }
            //                    }
            //                }
            //                    )
            //                { (task: URLSessionDataTask?, error: Error) in
            //                    print("POST fails with error \(error)")
            //                    Common.stoploderonplayer(view: self.view)
            //                }
        }
        else
        {
            Common.Showloginalert(view: self, text: "Please Login to report/abuse")
            
        }
        
        
        
        
        
    }
    
    //MARK:collection View delegate method
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ismore {
            
            return self.moredataarray.count
        }
            
        else
        {
            return LoginCredentials.Tredingcontent.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlayerCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PlayerCollectionViewCell)
        
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.clipsToBounds = true
        
        if ismore
        {
            cell?.headerlabel.text = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            
            var discriptiontext = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell?.Descriptionlabel.text = discriptiontext
            
           // cell?.Viewlabel.text = "\((self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
            cell?.Viewlabel.text = ""
              cell?.Uploadtimelabel.text = ""
//            let videotime = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
//
//            cell?.Uploadtimelabel.text = self.compatedate(date: videotime!)
            
            
      
            if(Common.isNotNull(object: (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
                let url = (self.moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
                if(url.count>0)
                {
                    var str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    str = Common.getsplitnormalimageurl(url: str)
                    cell?.MainImageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
                else
                {
                    cell?.MainImageview.image = #imageLiteral(resourceName: "Placehoder")
                }
            }
            else
            {
                cell?.MainImageview.image = #imageLiteral(resourceName: "Placehoder")
            }
            
            
        }
        else
        {
            
            cell?.headerlabel.text = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
            
            var discriptiontext = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as? String
            discriptiontext = discriptiontext?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell?.Descriptionlabel.text = discriptiontext
            
          //  cell?.Viewlabel.text = "\((LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "watch") as! String)\(" view")"
            cell?.Viewlabel.text = ""
             cell?.Uploadtimelabel.text = ""
//            let videotime = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as? String
//
//            cell?.Uploadtimelabel.text = self.compatedate(date: videotime!)
             if(Common.isNotNull(object: (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as AnyObject))
            {
                let url = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbs") as! NSArray
                if(url.count>0)
                {
                    var str = ((url.object(at: 0) as! NSDictionary).value(forKey: "thumb") as! NSDictionary).value(forKey: "medium") as! String
                    str = Common.getsplitnormalimageurl(url: str)
                    
                    cell?.MainImageview.setImageWith(URL(string: str)!, placeholderImage: UIImage.init(named: "Placehoder"))
                }
                else
                {
                    cell?.MainImageview.image = #imageLiteral(resourceName: "Placehoder")
                }
            }
            else
            {
                cell?.MainImageview.image = #imageLiteral(resourceName: "Placehoder")
                
            }
            
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        LoginCredentials.Ispressback = false
        
        if(ismore)
        {
            if(Common.isNotNull(object: (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "\((moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "\((moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                        return
                    }
                    
                }
            }
            
        }
        else
            
        {
            if(Common.isNotNull(object: (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as AnyObject?))
            {
                let type = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "status") as! String
                print(type)
                if(!Common.Isvideolvodtype(type: type))
                {
                    if(Common.Isvideolivetype(type: type))
                    {
                        if(!Common.Islogin())
                        {
                            Common.Showloginalert(view: self, text: "\((LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" is streaming live now. Please login to watch")")
                            return
                        }
                    }
                    else
                    {
                        EZAlertController.alert(title: "\((LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String)\(" event is scheduled as upcoming.")")
                        return
                    }
                    
                }
            }
        }
        
        stopanimatedownliadbutton()
        Common.callappanalytics()
        
        
        /////// rotate in Protrate///////////
        //      bEnlarge = true
        //        self.enlargeBtnAction()
        ///////////////////////////////////
        
        
        
        if(self.videoPlayer == nil)
        {
            
        }
        else
        {
            avLayer.removeFromSuperlayer()
            self.videoPlayer.pause()
            self.videoPlayer = nil
        }
        midroletime = 0.0
        skiptime = 0
        self.bHideControl = false
        checkcontantenable = false
        self.singleTapped()
        Download_dic.removeAllObjects()
        fromdownload = "no"
        isplaydfturl = false
        seletetedresoltionindex = 0
        AFHTTPSessionManager.cancelPreviousPerformRequests(withTarget: self)
        
        if(ismore)
        {
            print(moredataarray.object(at: indexPath.row))
            
            self.cat_id = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            
            
            let catdataarray = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            
            if(catdataarray.count == 0)
            {
                catid = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
            else
            {
                
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                catid = ids
            }
            
            
            
            tilttext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            if(Common.isNotNull(object: (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
                self.descriptiontext = (moredataarray.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            }
            else
            {
                self.descriptiontext = ""
            }
            
            self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
            getplayerurl()
            // self.getuserrelatedvideo()
            // self.getmorevideo()
        }
        else
        {
            print(LoginCredentials.Tredingcontent.object(at: indexPath.row))
            print((LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray)
            self.cat_id = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "id") as! String
            let catdataarray = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray
            print(catdataarray)
            if(catdataarray.count == 0)
            {
                catid = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_id") as! String
            }
                
            else
                
            {
                var ids = String()
                for i in 0..<catdataarray.count
                {
                    
                    let str = ((LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
                    ids = ids + str + ","
                    
                }
                ids = ids.substring(to: ids.index(before: ids.endIndex))
                catid = ids
                
            }
            
            
            tilttext = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as! String
            
            if(Common.isNotNull(object: (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as AnyObject?))
            {
                self.descriptiontext = (LoginCredentials.Tredingcontent.object(at: indexPath.row) as! NSDictionary).value(forKey: "des") as! String
            }
            else
            {
                self.descriptiontext = ""
            }
            
            self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
            
            
            getplayerurl()
            //self.getuserrelatedvideo()
            //self.getmorevideo()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2-5, height: 141)
    }
    
    
    
    
    @IBAction func secforwordaction(_ sender: UIButton) {
        
        if(self.videoPlayer != nil) {
          let seconds : Int64 = Int64(playbackSlider.value + 10.0)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.playbackSlider.value = Float(CGFloat(seconds))
        self.bSlideBar = true
        
        if self.videoPlayer!.rate == 0
        {
            self.isplayorpause()
         }
        }
        
    }
    
    
    //MARK:-Taptofarword5sec
    
    
    @IBAction func Taptofarword5sec(_ sender: UIButton) {
        
        PlayNextvideoinmoresection()
        
        
        
        
        //        let seconds : Int64 = Int64(playbackSlider.value + 5.0)
        //        let targetTime:CMTime = CMTimeMake(seconds, 1)
        //        print("seconds >>>",seconds)
        //        self.videoPlayer!.seek(to: targetTime)
        //        self.playbackSlider.value = Float(CGFloat(seconds))
        //        self.bSlideBar = true
        //        if self.videoPlayer!.rate == 0
        //        {
        //            self.videoPlayer?.play()
        //        }
        
    }
    
    
    
    
    
    
    
    func PlayNextvideoinmoresection()
    {
        
        if(moredataarray.count == 0 )
        {
            EZAlertController.alert(title: "Can't Play , no videos in more section")
            return
        }
        
        let lastindex = moredataarray.count
        if(lastindex == Nextvideoindex)
        {
            Nextvideoindex = 0
        }
        
        
         print("Nextvideoindex \(Nextvideoindex)")
         print("moredataarray count \(moredataarray.count)")
        
        if(Nextvideoindex>moredataarray.count)
        {
           Nextvideoindex = 0
        }
        
        self.collectionView(Mycollectionview, didSelectItemAt: NSIndexPath.init(item: Nextvideoindex, section: 0) as IndexPath)
        Nextvideoindex = Nextvideoindex+1
        
        
        //        if(moredataarray.count == 0)
        //        {
        //            return
        //        }
        //
        //
        //        if(self.videoPlayer == nil)
        //        {
        //
        //        }
        //        else
        //        {
        //            avLayer.removeFromSuperlayer()
        //            self.videoPlayer.pause()
        //            self.videoPlayer = nil
        //        }
        //
        //
        //
        //
        //        midroletime = 0.0
        //        skiptime = 0
        //        self.bHideControl = false
        //        self.singleTapped()
        //        Download_dic.removeAllObjects()
        //        fromdownload = "no"
        //
        //
        //
        //            print(moredataarray.object(at: 0))
        //            Common.callappanalytics()
        //             let catdataarray = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_ids") as! NSArray
        //
        //        if(catdataarray.count == 0)
        //        {
        //            catid = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_id") as! String
        //        }
        //
        //        else
        //        {
        //
        //            var ids = String()
        //            for i in 0..<catdataarray.count
        //            {
        //
        //                let str = ((moredataarray.object(at: 0) as! NSDictionary).value(forKey: "category_ids") as! NSArray).object(at: i) as! String
        //                ids = ids + str + ","
        //
        //            }
        //            ids = ids.substring(to: ids.index(before: ids.endIndex))
        //            catid = ids
        //
        //        }
        //
        //
        //            tilttext = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "title") as! String
        //            if(Common.isNotNull(object: (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "des") as AnyObject?))
        //            {
        //                self.descriptiontext = (moredataarray.object(at: 0) as! NSDictionary).value(forKey: "des") as! String
        //            }
        //            else
        //            {
        //                self.descriptiontext = ""
        //            }
        //
        //
        //            self.setvideodescription(titile: tilttext, like: "", des: descriptiontext, url:"")
        //            getplayerurl()
        //            self.getuserrelatedvideo()
        //            self.getmorevideo()
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:-Taptobackword5sec
    
    @IBAction func Taptobackword5sec(_ sender: UIButton)
    {
        if(playbackSlider.value < 10.0)
        {
            
        }
        else
        {
            
            let seconds : Int64 = Int64(playbackSlider.value - 10.0)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            self.videoPlayer!.seek(to: targetTime)
            self.playbackSlider.value = Float(CGFloat(seconds))
            self.bSlideBar = true
            
            if self.videoPlayer!.rate == 0
            {
                self.isplayorpause()
                //self.videoPlayer?.play()
            }
        }
    }
    
    
    
    func isplayorpause()
    {
        if(bPlay)
        {
            if(self.videoPlayer != nil)
            {
                self.videoPlayer.pause()
            }
        }
        else
        {
            self.videoPlayer.play()
            
        }
    }
    
    func isvideoplayingisremotecast()
    {
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote)
        {
            self.videoPlayer?.pause()
        }
    }
    
    
    //MARK:-parseallsteme All Resoltion
    
    
    func parseallsteme(url:String)
    {
        
        if(!(Common.isNotNull(object: url as AnyObject?)) || (url == "") )
        {
            return
        }
        videoresoulationtypearray.removeAllObjects()
        videoresoulationurlarray.removeAllObjects()
        let typenadresolutionarray = NSMutableDictionary()
        
        let xStreamList = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList
        let count1 = try! M3U8PlaylistModel.init(url:url).masterPlaylist.xStreamList.count
        for i in 0..<count1 {
            
            let str = (xStreamList?.xStreamInf(at: i).resolution.height)! as Float
            let str1 = "\(str.cleanValue)\("P")"
            print(xStreamList?.xStreamInf(at: i).m3u8URL())
            typenadresolutionarray.setValue((xStreamList?.xStreamInf(at: i).m3u8URL())!, forKey: str1)
        }
        print(typenadresolutionarray)
        
        
        let reverser = typenadresolutionarray.sorted(by: { (a, b) in (a.value as! String) < (b.value as! String) })
        
        
        for i in 0..<reverser.count {
            videoresoulationtypearray.add(reverser[i].key)
            videoresoulationurlarray.add(reverser[i].value)
        }
        
        print(videoresoulationtypearray)
        print(videoresoulationurlarray)
        videoresoulationtypearray.insert("Auto", at: 0)
        videoresoulationurlarray.insert(url, at: 0)
        
        
        let hasConnectedSession: Bool = (self.sessionManager.hasConnectedSession())
        if hasConnectedSession && (self.playbackMode == .remote) {
            //self.switchToRemotePlayback()
            if(self.videoPlayer == nil)
            {
            }
            else
            {
                self.stopplayerifcastingenable()
            }
            
            
            self.loadMediaList1()
        }
        
        
    }
    
    
    
    //MARK:-Action sheet resloution
    
    
    func downloadSheet()
    {
        print(videoresoulationurlarray)
        print(videoresoulationtypearray)
        
        
        let orderedSet = NSOrderedSet(object: videoresoulationtypearray)
        print(orderedSet.array)
        
        let set = NSSet(array: [videoresoulationtypearray.mutableCopy()])
        videoresoulationtypearray.removeAllObjects()
        let array1:NSMutableArray=NSMutableArray()
        array1.add(set.allObjects)
        videoresoulationtypearray = (((array1.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        
        
        let set1 = NSSet(array: [videoresoulationurlarray.mutableCopy()])
        videoresoulationurlarray.removeAllObjects()
        let array2:NSMutableArray=NSMutableArray()
        array2.add(set1.allObjects)
        videoresoulationurlarray = (((array2.object(at: 0) as! NSArray).object(at: 0) as! NSArray).mutableCopy() as! NSMutableArray)
        let actionSheet = UIActionSheet(title: "Video Quality", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        for i in 0..<videoresoulationtypearray.count {
            //actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)
            print(i)
            print(videoresoulationtypearray.object(at: i))
            if(i == seletetedresoltionindex)
            {
                actionSheet.addButton(withTitle: "\(videoresoulationtypearray.object(at: i) as! String)\(" ✓")")
            }
            else
            {
                actionSheet.addButton(withTitle: videoresoulationtypearray.object(at: i) as? String)
            }
        }
        actionSheet.show(in: view)
        
        
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print(buttonIndex)
        if buttonIndex>0 {
            if(self.videoPlayer == nil)
            {
                
            }
            else
            {
                avLayer.removeFromSuperlayer()
                self.videoPlayer.pause()
                self.videoPlayer = nil
            }
            isplaydfturl = false
            seletetedresoltionindex = buttonIndex-1
            self.playvideo(url: videoresoulationurlarray.object(at: buttonIndex-1) as! String)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                self.skiptimeinterval()
                
            })
        }
    }
    
    
    
    func skiptimeinterval()
    {
        print("self.playerTime >>>",LoginCredentials.Contantplaytime)
        let seconds : Int64 = Int64(LoginCredentials.Contantplaytime)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        self.videoPlayer!.seek(to: targetTime)
        self.isplayorpause()
        if(bPlay)
        {
            let image = UIImage(named:"play")
            self.expandBtn.setImage(image, for: .normal)
        }
    }
    
    
    //MARK:-Taptosound
    
    @IBAction func Taptosound(_ sender: UIButton) {
        
        if (sender.currentImage?.isEqual(UIImage(named: "Unmute")))! {
            //do something here
            self.videoPlayer.isMuted = true
            sender.setImage(UIImage.init(named: "Mute"), for: .normal)
        }
        else
        {
            self.videoPlayer.isMuted = false
            sender.setImage(UIImage.init(named: "Unmute"), for: .normal)
        }
        
        
    }
    
    
    //MARK:-TaptoResolution
    
    @IBAction func TaptoResolution(_ sender: UIButton) {
        
        self.downloadSheet()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    
    func setvideoinwatchlist()
    {
        let dict = dataBase.getDatabaseresponseinentity(entityname: "Logindata", key: "logindatadict")
        if (dict.count>0)
        {
            let asset = AVURLAsset(url: URL(string: Video_url)!)
            let duration: CMTime = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print(durationTime)
            var parameters = [String:Any]()
            parameters = [
                "content_id":cat_id,
                "c_id":(dict.value(forKey: "id") as! NSNumber).stringValue,
                "total_duration":durationTime,
                "duration":"1"
            ]
            let url = String(format: "%@%@", LoginCredentials.watchdurationapi,Apptoken)
            print(url)
            print(parameters)
            let manager = AFHTTPSessionManager()
            manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                if (responseObject as? [String: AnyObject]) != nil {
                    let dict = responseObject as! NSDictionary
                    print(dict)
                    // let Catdata_dict = Common.decodedresponsedata(msg:dict.value(forKey: "result") as! String)
                    // print(Catdata_dict)
                }
            }) { (task: URLSessionDataTask?, error: Error) in
                print("POST fails with error \(error)")
            }
            
        }
        else
        {
            
        }
    }
    
    
    
    func isdeviceiphonex() ->String
    {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return "iPhone 5"
            case 1334:
                print("iPhone 6/6S/7/8")
                return "iPhone 6/6S/7/8"
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                return "iPhone 6+/6S+/7+/8+"
            case 2436:
                print("iPhone X")
                return "iPhone X"
            default:
                print("unknown")
                return "unknown"
            }
        }
        return "unknown"
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
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 16.0, right: 0)
        self.view.frame.origin.y =  -38
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
        
    }
    
    
    
}


extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
// MARK: - KRPullLoadView delegate -------------------

extension PlayerViewController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                }
            default: break
            }
            return
        }
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1)
            {
                completionHandler()
            }
        }
    }
}





