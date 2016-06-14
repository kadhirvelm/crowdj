//
//  Music_queue+CoreDataProperties.swift
//  CrowDJ
//
//  Created by Kadhir M on 6/11/16.
//  Copyright © 2016 CrowdDJ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Music_queue {

    @NSManaged var title: String?
    @NSManaged var url: NSNumber?
    @NSManaged var artist: String?
    @NSManaged var artwork: NSData?
    @NSManaged var playback: String?

}
