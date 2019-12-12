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

class CoreDataStackManager: DataBaseManagerProtocol {
    // MARK: - Core Data stack
    let containerName: String
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext!
    var backgroundContext: NSManagedObjectContext!
    
    init(containerName: String) {
        self.containerName = containerName
        persistentContainer = NSPersistentContainer(name: containerName)
        start()
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
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext = persistentContainer.viewContext
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func fetch<Output, Query>(query: Query, output: Output.Type) -> Promise<[Output]> {
        
        return retry(on: .promises, attempts: 9, delay: 2, condition: { (_, error) -> Bool in
            return (error as NSError).code  == 10
        }, { () -> Promise<[Output]> in
            if self.backgroundContext == nil {
                return Promise<[Output]>(NSError.init(domain: "", code: 10, userInfo: nil))
            }
            guard let query  = query as? NSFetchRequest<NSFetchRequestResult> else {
                fatalError("CoreDataStackManager Only fetch quaries of type NSFetchRequest")
            }
            do {
                let fetchedData =  try self.backgroundContext.fetch(query)
                if let output =  fetchedData as? [Output] {
                    return Promise<[Output]>(output  )
                } else {
                    fatalError("un expected output")
                }
            } catch {
                return Promise<[Output]>(error)
            }
        })
    }
    
    func
        save() -> Promise<Void> {
        let promise = Promise<Void>.pending()
        if backgroundContext != nil && backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
                promise.fulfill(Void())
            } catch {
                promise.reject(error)
            }
        }
        return promise
    }
    
    func insert<Input>(data: Input) -> Promise<Void> {
       
        var inputs = [NSManagedObject]()
        if let data = data as? [NSManagedObject] {
            inputs = data
        } else if let data = data as? NSManagedObject {
            inputs.append( data)
        } else {
            fatalError("Data must be child NSManagedObject")
        }
        inputs.forEach { (data) in
            backgroundContext.insert(data)
        }
        return self.save()
    }
    
    func clear() -> Promise<Void> {
        return Promise<Void>.init { }
    }
    
}
