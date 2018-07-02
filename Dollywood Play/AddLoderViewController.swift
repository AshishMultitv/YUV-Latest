//
//  AddLoderViewController.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 23/03/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import GoogleInteractiveMediaAds


class AddLoderViewController: UIViewController,IMAAdsLoaderDelegate, IMAAdsManagerDelegate,AVPictureInPictureControllerDelegate {
    
    
    var player: AVPlayer?
    var playerLayer:AVPlayerLayer!
    
    
    
    //////////////Google Ima Object////////
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?
    // IMA SDK handles.
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    var companionSlot: IMACompanionAdSlot?
    var isplaydfturl:Bool = Bool()
    var Dfp_url = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.audioRouteChangeListener), name: .AVAudioSessionRouteChange, object: nil)
        AppUtility.lockOrientation(.landscapeRight)
        // Playerview.frame = self.view.frame
        Dfp_url = "https://googleads.g.doubleclick.net/pagead/ads?ad_type=video&client=ca-video-pub-5621004189462935&description_url=http%3A%2F%2Fwww.dinamalar.com%2F&videoad_start_delay=0&hl=en&max_ad_duration=30000"
        
        self.loadVideo()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        playerLayer.frame = self.view.frame
        
        
    }
    
    func rotateddd()
    {
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        {
            print(self.view.frame)
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            print(self.view.frame)
            
        }
    }
    func willResignActive(_ notification: Notification) {
        
        if(self.player == nil)
        {
            
        }
        else
        {
            self.player?.play()
        }
        
        // code to execute
    }
    
    
    
    func audioRouteChangeListener(notification: Notification) {
        
        guard let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as? Int else { return }
        
        switch audioRouteChangeReason {
            
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.hashValue:
            //plugged out
            
            if(self.player == nil)
            {
                
            }
            else
            {
                // self.player?.play()
                
            }
            break
            
        default:
            break
            
        }
        
    }
    
    
    @IBAction func tapTocancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissview() {
        
        if(self.player == nil)
        {
            
        }
        else
        {
            playerLayer.removeFromSuperlayer()
            self.player?.pause()
            self.player = nil
        }
        
        
        adsLoader = nil
        if (adsManager != nil)
        {
            adsManager!.destroy()
            adsManager = nil
        }
        
        AppUtility.lockOrientation(.portrait)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func loadVideo() {
        
        //  AVLayerVideoGravityResizeAspectFill
        // AVLayerVideoGravityResizeAspect
        //  AVLayerVideoGravityResize
        
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
        let path = Bundle.main.path(forResource: "yuv_video_final", ofType:"mp4")
        //let videoURL = URL(string: "https://www.youtube.com/watch?v=wQg3bXrVLtg")
        // player = AVPlayer(url: videoURL!)
        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startplayingnotification), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: self.player?.currentItem)
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player?.seek(to: kCMTimeZero)
        player?.pause()
        self.loadadssetting()
        self.creategoogeima()
        self.setUpIMA()
        self.requestAdsWithTag(self.Dfp_url)
        //player?.volume = 0.0
        
    }
    
    
    
    func startplayingnotification(note: NSNotification)
    {
        
    }
    
    func playerDidFinishPlaying(note: NSNotification)
    {
        self.dismissview()
    }
    
    func Showerroralert()
    {
        let alert = UIAlertController(title: "Error", message: "Getting some error please try again after some time", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.dismissview()
        }))
        self.present(alert, animated: true, completion: nil)
        
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
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.player)
        // Set ourselves up for PiP.
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
        pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer!);
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
        return IMAAdDisplayContainer(adContainer: self.view, companionSlots: nil)
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
            avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: self.player),
            pictureInPictureProxy: pictureInPictureProxy,
            userContext: nil)
        print(request)
        adsLoader.requestAds(with: request)
    }
    
    
    // Notify IMA SDK when content is done for post-rolls.
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if ((notification.object as? AVPlayerItem) == self.player!.currentItem) {
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
        self.Showerroralert()
        //isAdPlayback = false
        isplaydfturl = false
        
    }
    
    
    // MARK: AdsManager Delegates
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print(event.typeString!)
        
        if(event.typeString! == "Started")
        {
            
        }
        if(event.typeString! == "Skipped")
        {
            self.dismissview()
            
        }
        if(event.typeString! == "Complete")
        {
            Common.callUserfreesubscriptionapi()
            self.player?.play()
            // self.dismissview()
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
        self.Showerroralert()
        
        
    }
    
    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        //isAdPlayback = true
        
    }
    
    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        //isAdPlayback = false
        
    }
    
    
    
    
    
    
    func setvalueofanyfinaldesitinastion() {
        
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
