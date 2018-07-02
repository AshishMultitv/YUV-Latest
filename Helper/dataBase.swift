//
//  dataBase.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 15/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import CoreData
import Sugar

class dataBase: NSObject {

    
    
   //MARK:- Save any data with entity name, which key, data
    static func Savedatainentity(entityname:String,key:String,data:NSMutableDictionary)
    {
      
        
            let data1 = NSMutableData()
            let archiver = NSKeyedArchiver.init(forWritingWith: data1)
            // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
            archiver.finishEncoding()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            
            if #available(iOS 10.0, *) {
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: entityname,
                                                        in: managedContext)!
                let person = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                
                person.setValue(data1, forKeyPath: key)
               // person.setValue(sport_id, forKeyPath: "id")
                
                do {
                    try managedContext.save()
                    print("Successfully save")
                 } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } else {
                // Fallback on earlier versions
            }
            
 
        
    }
   
    
    
    //MARK:- Save Download video id
    static func savedownloadvideoid(id:String,userid:String)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.string(from: NSDate() as Date)
        
         if #available(iOS 10.0, *) {
            
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Downloadvideoid",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
             person.setValue(id, forKeyPath: "id")
             person.setValue(userid, forKeyPath: "userid")
             person.setValue(dataBase.converstringtodate(date: date), forKeyPath: "videodate")
            
 
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
 
        
    }

    
    //MARK:- Save favriout video id
    static func savefavrioutvideoid(id:String,userid:String)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Favriout",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(userid, forKeyPath: "userid")
            person.setValue(id, forKeyPath: "videoid")

            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
   
    
    static func getfavrioutlvideoid(userid:String) -> NSMutableArray
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favriout")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    for i in 0..<manageobject.count
                    {
                        let person = manageobject[i]
                        let data = person.value(forKeyPath: "videoid") as! String
                         downloaddataarray.add(data)
                        
                        
                    }
                    print(downloaddataarray)
                    return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    

    static func deletefavvideoid(userid:String,videoid:String)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favriout")
            let predicate = NSPredicate(format: "(userid = %@)", userid)
            let predicate1 = NSPredicate(format: "(videoid = %@)", videoid)
            let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate,predicate1])
            fetchRequest.predicate = predicateCompound;
            fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in  error : \(error) \(error.userInfo)")
            }
            
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
   
    
    
    
    static func getdownloadvideoid(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Downloadvideoid")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    for i in 0..<manageobject.count
                    {
                        let person = manageobject[i]
                        let downloadvideodate = person.value(forKeyPath: "videodate") as! Date
                        let currentdate = Date()
                         let diffrence = currentdate.days(from: downloadvideodate)
                        print("Diffrence in minut\(diffrence)")
                        if(diffrence < 30)
                        {
                           downloaddataarray.add(person.value(forKey: "id") as! String)
                        }
                        
                      }
                    print(downloaddataarray)
                    return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    

    
    
    static func deletedownloadvideoid(videoid:String,user_id:String)
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Downloadvideoid")
               let predicate = NSPredicate(format: "(id = %@)", videoid)
             let predicate1 = NSPredicate(format: "(userid = %@)", user_id)
             let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate,predicate1])
            fetchRequest.predicate = predicateCompound;
            fetchRequest.returnsObjectsAsFaults = false
      
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in  error : \(error) \(error.userInfo)")
            }
            
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
 
   
    
    
    //MARK:- Save Channeldata in database
    
    static func SaveChanneldata(data:NSMutableDictionary)
    {
        
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Channeldata",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: "channeldatadict")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
 //MARK:- Get Cahannel data from database
    
    static func GetCahanneldata() -> NSMutableDictionary
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Channeldata")
            
            do {
                
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    let data = person.value(forKeyPath: "channeldatadict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                    sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                    print("contentListArray>>>",sportsDatabasedictnew)
                    return sportsDatabasedictnew
                    
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
    }
    
    
    //MARK:- Save Continue watching video in database
    
    static func Savecontinuewatching(id:String,seektime:Float,data:NSMutableDictionary)
    {
        
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Continuewatching",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: "dontinuewatchingdict")
            person.setValue(id, forKeyPath: "id")
            person.setValue(seektime, forKeyPath: "seektime")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
   //MARK:- Get Continue watching video from database
    
    static func getcontinuewatchingfromdatabase(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Continuewatching")
            
            do {
                
                let predicate = NSPredicate(format: "(id = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    for i in 0..<manageobject.count
                    {
                        var sportsDatabasedictnew = NSMutableDictionary()
                        let person = manageobject[i]
                        let data = person.value(forKeyPath: "dontinuewatchingdict") as! Data
                        let data1 = person.value(forKeyPath: "seektime") as! Float
                        
                        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                        print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                        sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                        sportsDatabasedictnew.setValue(data1, forKey: "seektime")
                        downloaddataarray.add(sportsDatabasedictnew)
                        
                        
                    }
                    print(downloaddataarray)
                    return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    
    
    
    
    
    
    //MARK:- Save Homedata Catlist in database
  
    static func Savecatlist(entityname:String,id:String,key:String,data:NSMutableDictionary)
    {
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: entityname,
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: key)
            person.setValue(id, forKeyPath: "id")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    
    //MARK:- Save Download Video Data
    static func SaveDownloadvideo(Userid:String,Videoid:String,data:NSMutableDictionary,image:NSData)
    {
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.string(from: NSDate() as Date)
      
        
        
        
           if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "VideoDownload",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: "videodownloaddata")
            person.setValue(Userid, forKeyPath: "userid")
            person.setValue(Videoid, forKeyPath: "videoid")
            person.setValue(image, forKeyPath: "image")
            person.setValue(dataBase.converstringtodate(date: date), forKeyPath: "downloaddate")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    static func getdownloadlistdatabase(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         var downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VideoDownload")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                      for i in 0..<manageobject.count
                      {
                        
                   
               
                        var sportsDatabasedictnew = NSMutableDictionary()
                         let person = manageobject[i]
                        let data = person.value(forKeyPath: "videodownloaddata") as! Data
                        let data1 = person.value(forKeyPath: "image") as! Data
                        let downloadvideodate = person.value(forKeyPath: "downloaddate") as! Date
                        
                         let currentdate = Date()
                          let diffrence = currentdate.days(from: downloadvideodate)
                        print("Diffrence in days\(diffrence)")
                        if(diffrence < 30)
                         {
                        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                        print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                        sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                        sportsDatabasedictnew.setValue(data1, forKey: "videoimage")
                        downloaddataarray.add(sportsDatabasedictnew)
                        }
                        
                        
                    }
                  print(downloaddataarray)
                 return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    
  
    
    //MARK:- Get Homedata Catlist from database

    static func getcatlistdatabase(entityname:String,id:String,key:String) -> NSMutableDictionary
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityname)
            
            do {
                
                 let predicate = NSPredicate(format: "(id = %@)", id)
                 fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    let data = person.value(forKeyPath: key) as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                    sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                    print("contentListArray>>>",sportsDatabasedictnew)
                    return sportsDatabasedictnew
                    
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
        
    }
   
    //MARK:- Get anydata response with emtity name and key

    static func getDatabaseresponseinentity(entityname:String,key:String) -> NSMutableDictionary
    {
        
    
         var sportsDatabasedictnew = NSMutableDictionary()
            
            if #available(iOS 10.0, *) {
                let managedContext = appDelegate?.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityname)
                
                do {
                    
                    
                   // let predicate = NSPredicate(format: "(id = %@)", sport_id)
                   // fetchRequest.predicate = predicate
                     var manageobject: [NSManagedObject] = []
                    manageobject = (try managedContext?.fetch(fetchRequest))!
                    
                    if (manageobject.count>0)
                    {
                        
                        let person = manageobject[0]
                        let data = person.value(forKeyPath: key) as! Data
                        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                         sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                        print("contentListArray>>>",sportsDatabasedictnew)
                        return sportsDatabasedictnew
                        
                        
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
            } else {
                // Fallback on earlier versions
            }
            
         return sportsDatabasedictnew   
      
     }
    
    //MARK:- Delete data base with perticular entity
 
//    static func deletedataentity(entityname:String)
//    {
//        
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if #available(iOS 10.0, *) {
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
//           // let predicate = NSPredicate(format: "(id = %@)", sport_id)
//           // fetchRequest.predicate = predicate
//            fetchRequest.returnsObjectsAsFaults = false
//            
//            do
//            {
//                let results = try managedContext.fetch(fetchRequest)
//                for managedObject in results
//                {
//                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                    managedContext.delete(managedObjectData)
//                }
//            } catch let error as NSError {
//                print("Detele all data in \(entityname) error : \(error) \(error.userInfo)")
//            }
//            
//            
//            
//            
//            
//        } else {
//            // Fallback on earlier versions
//        }
//
//        
//        
//    }
    
    
    static func deletedownloaddata(userid:String,videoid:String){
        
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if #available(iOS 10.0, *) {
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VideoDownload")
                    let predicate = NSPredicate(format: "(userid = %@)", userid)
                    let predicate1 = NSPredicate(format: "(videoid = %@)", videoid)
                    let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate,predicate1])
                    fetchRequest.predicate = predicateCompound;
                    fetchRequest.returnsObjectsAsFaults = false
        
                    do
                    {
                        let results = try managedContext.fetch(fetchRequest)
                        for managedObject in results
                        {
                            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                            managedContext.delete(managedObjectData)
                        }
                    } catch let error as NSError {
                        print("Deteleting in  error : \(error) \(error.userInfo)")
                    }
        
                    
                    
                    
                    
                } else {
                    // Fallback on earlier versions
                }
        
    }
    
   static func deletedataentity(entityname:String){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityname))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    func savezonerdataindatabase(data:NSMutableDictionary,zonerid:String)
    {
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Zonerlistdata",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            person.setValue(data1, forKeyPath: "zonerlistdatadict")
            person.setValue(zonerid, forKeyPath: "zonerid")
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    //MARK:- Get Homedata Catlist from database
    
    static func getZonerdata(id:String) -> NSMutableDictionary
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Zonerlistdata")
            
            do {
                let predicate = NSPredicate(format: "(zonerid = %@)", id)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    let data = person.value(forKeyPath: "zonerlistdatadict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                    sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                    print("contentListArray>>>",sportsDatabasedictnew)
                    return sportsDatabasedictnew
                    
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
        
    }
    
    
    static func converstringtodate(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date) // replace Date String
    }
    
   
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
}
