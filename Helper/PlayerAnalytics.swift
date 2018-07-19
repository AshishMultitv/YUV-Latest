//
//  PlayerAnalytics.swift
//  Dollywood Play
//
//  Created by Cybermac002 on 18/07/18.
//  Copyright © 2018 Cyberlinks. All rights reserved.
//

import UIKit

class PlayerAnalytics: NSObject {

    // MARK: - PlayCount
    static var PlayCount: Int {
 
        get {
            
            if let playCount = UserDefaults.standard.object(forKey: "playCount") as? Int
            {
                return  playCount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playCount")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - PauseCount
    static var PauseCount: Int {
        get {
            
            if let pauseCount = UserDefaults.standard.object(forKey: "pauseCount") as? Int
            {
                return  pauseCount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pauseCount")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - ErrorCount
    static var ErrorCount: Int {
        get {
            
            if let errorCount = UserDefaults.standard.object(forKey: "errorCount") as? Int
            {
                return  errorCount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "errorCount")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - Resolutionchangecount
    static var Resolutionchangecount: Int {
        get {
            
            if let resolutionchangecount = UserDefaults.standard.object(forKey: "resolutionchangecount") as? Int
            {
                return  resolutionchangecount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "resolutionchangecount")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    // MARK: - Seekcount
    static var Seekcount: Int {
        get {
            
            if let seekcount = UserDefaults.standard.object(forKey: "seekcount") as? Int
            {
                return  seekcount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "seekcount")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - Fullscreencount
    static var Fullscreencount: Int {
        get {
            
            if let fullscreencount = UserDefaults.standard.object(forKey: "fullscreencount") as? Int
            {
                return  fullscreencount
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "fullscreencount")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - DvrUsagecont
    static var DvrUsagecont: Int {
        get {
            
            if let dvrUsagecont = UserDefaults.standard.object(forKey: "dvrUsagecont") as? Int
            {
                return  dvrUsagecont
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dvrUsagecont")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - PlayerInstilixetime
    static var PlayerInstilixetime: Int {
        get {
            
            if let playerInstilixetime = UserDefaults.standard.object(forKey: "playerInstilixetime") as? Int
            {
                return  playerInstilixetime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "playerInstilixetime")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - StartTime
    static var StartTime: Int {
        get {
            
            if let startTime = UserDefaults.standard.object(forKey: "startTime") as? Int
            {
                return  startTime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "startTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - WatchTime
    static var WatchTime: Int {
        get {
            
            if let watchTime = UserDefaults.standard.object(forKey: "watchTime") as? Int
            {
                return  watchTime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "watchTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    // MARK: - PauseTime
    static var PauseTime: Int {
        get {
            
            if let pauseTime = UserDefaults.standard.object(forKey: "pauseTime") as? Int
            {
                return  pauseTime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "pauseTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    // MARK: - BufferingTime
    static var BufferingTime: Int {
        get {
            
            if let bufferingTime = UserDefaults.standard.object(forKey: "bufferingTime") as? Int
            {
                return  bufferingTime
            }
            return Int()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bufferingTime")
            UserDefaults.standard.synchronize()
        }
    }
}
