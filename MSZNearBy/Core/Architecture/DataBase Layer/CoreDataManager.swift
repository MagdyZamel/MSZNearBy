//
//  CoreDataManager.swift
//  MSZNearBy
//
//  Created by MSZ on 12/7/19.
//  Copyright © 2019 MSZ. All rights reserved.
//

import Foundation
import Promises
import CoreData

class CoreDataStackManager: DataBaseProtocol {
    
    // MARK: - Core Data stack
    let containerName: String
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    init(containerName: String) {
        self.containerName = containerName
        persistentContainer = NSPersistentContainer(name: containerName)
    }
    
    @discardableResult
    func start() -> Promise<Void> {
        
        let promise = Promise<Void>.init { fillfull, reject in
            self.persistentContainer.loadPersistentStores { ( _, error) in
                if let error = error {
                    reject(error)
                    fatalError("Failed to load Core Data stack: \(error)")
                }
                self.configureContexts()
                fillfull(Void())
            }
        }
        return promise
    }
    
    fileprivate func configureContexts() {
        backgroundContext = persistentContainer.viewContext
        viewContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func fetch<Output: NSObject>(query: NSFetchRequest<Output>) ->  Promise<[Output]> {
        return retry(on: .promises, attempts: 9, delay: 2, condition: { (_, error) -> Bool in
            return (error as NSError).code  == 10
        }, { () -> Promise<[Output]> in
            if self.backgroundContext == nil {
                return Promise<[Output]>(NSError.init(domain: "", code: 10, userInfo: nil))
            }
            do {
                let output = try self.backgroundContext.fetch(query)
                return Promise<[Output]>(output)
            } catch {
                return Promise<[Output]>(error)
            }
        })
    }
    
    func save() throws {
        if backgroundContext != nil && backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                throw error
//                fatalError("Unresolved error \(error))")
            }
        }
        
    }
    func insert<Input>(data: Input) {
        
        if let data = data as? NSManagedObject {
            let managedObject = NSManagedObject(entity: data.entity, insertInto: backgroundContext)
            for key in managedObject.entity.attributesByName.keys{
                print(message: key)
                let value = data.value(forKey: key)
                
                managedObject.setValue(value, forKey: key)
            }
            try? save()
        }
    }
    
    func clear() -> Promise<Void> {
        return Promise<Void>.init { }
    }
    
}
