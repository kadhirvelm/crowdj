//
//  Core_Data.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//

import CoreData
import UIKit

class crowdjCoreData {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    /** Given a username, userID, and NSData profile picture, this method will create a new user and save it to Core Data. */
    func createUser(userName: String){
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
        newUser.setValue(userName, forKey: "userName")
        do {
            try context.save()
        } catch {
            print("Errors saving user data")
        }
    }
    
    func createNewMusic(url: Int, title: String, artist: String, artwork: NSData, playback: String, genre: String) {
        let newMusic = NSEntityDescription.insertNewObjectForEntityForName("Music_queue", inManagedObjectContext: context)
        newMusic.setValue(url, forKey: "url")
        newMusic.setValue(title, forKey: "title")
        newMusic.setValue(artist, forKey: "artist")
        newMusic.setValue(artwork, forKey: "artwork")
        newMusic.setValue(playback, forKey: "playback")
        newMusic.setValue(genre, forKey: "genre")
        do {
            try context.save()
        } catch {
            print("Errors saving music data")
        }
    }
    
    /** Given an entity title, it will delete everything in core data associated with it. */
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    /** Given an entity title, it will delete everything in core data associated with it. */
    func deleteFirstEntry(entity: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            managedContext.deleteObject(results[0] as! NSManagedObject)
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    /* Given some entity string, it will return all the data associated with it in Core Data. */
    func retrieveData(entity: String) -> [AnyObject]? {
        do {
            let request = NSFetchRequest(entityName: entity)
            let results = try context.executeFetchRequest(request)
            return results
        } catch {
            print("Errors")
        }
        return nil
    }
    
}
