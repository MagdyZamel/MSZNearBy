//
//  CoreDataHelpers.swift
//  MSZNearBy
//
//  Created by MSZ on 2/23/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

 import CoreData

 func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

     let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

     do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                          configurationName: nil,
                                                          at: nil,
                                                          options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }

    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

    return managedObjectContext
}
