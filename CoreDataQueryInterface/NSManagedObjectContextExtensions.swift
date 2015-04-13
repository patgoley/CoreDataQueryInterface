//
//  NSManagedObjectContextExtensions.swift
//  CoreDataQueryInterface
//
//  Created by Gregory Higley on 4/11/15.
//  Copyright (c) 2015 Prosumma LLC. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    public func from<E: NSManagedObject>(E.Type) -> EntityQuery<E> {
        return EntityQuery.from(E).context(self)
    }
    
    public func query<E: NSManagedObject>() -> EntityQuery<E> {
        return EntityQuery.from(E)
    }
    
    public func newManagedObject<E: NSManagedObject>() -> E {
        return newManagedObject(E)
    }

    public func newManagedObject<E: NSManagedObject>(E.Type) -> E {
        return NSEntityDescription.insertNewObjectForEntityForName(E.entityName, inManagedObjectContext: self) as! E
    }
    
    public convenience init?(sqliteStoreAtPath path: String, concurrencyType: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType, error: NSErrorPointer = nil) {
        self.init()
        if let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil) {
            persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: NSURL(fileURLWithPath: path), options: nil, error: error)
        } else {
            return nil
        }
    }
}
