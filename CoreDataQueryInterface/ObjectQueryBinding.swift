//
//  ObjectQueryBinding.swift
//  CoreDataQueryInterface
//
//  Created by Patrick Goley on 4/11/16.
//  Copyright © 2016 Prosumma LLC. All rights reserved.
//

import Foundation
import CoreData


// Abstracts a fetched results controller using a fetch request for a single object

public protocol ObjectQueryBindingProtocol: QueryBindingProtocol {
    
    var result: ResultType? { get }
    
    func setObserver<ObserverType: ObjectBindingObserver where ObserverType.ResultType == ResultType>(observer: ObserverType)
}


// A protocol for objects that want to observe a query binding for a single object

public protocol ObjectBindingObserver: class, QueryBindingObserver {
    
    func objectInserted(object: ResultType)
    
    func objectUpdated(object: ResultType)
    
    func objectDeleted(object: ResultType)
}


public class ObjectQueryBinding<T where T: EntityType, T: AnyObject> : NSObject, ObjectQueryBindingProtocol, NSFetchedResultsControllerDelegate {
    
    public typealias ResultType = T
    
    let resultsController: NSFetchedResultsController
    
    weak var observer: AnyObjectBindingObserver<T>? = nil
    
    public var result: ResultType? {
        
        return resultsController.fetchedObjects?.first as? ResultType
    }
    
    public convenience init<Q: QueryType where Q.QueryResultType == ResultType>(query: Q) {
        
        guard let context = query.builder.managedObjectContext else {
            
            preconditionFailure("query must be assigned a managed object context")
        }
        
        let request: NSFetchRequest = query.request()
        
        self.init(fetchRequest: request, context: context)
    }
    
    required public init(fetchRequest: NSFetchRequest, context: NSManagedObjectContext) {
        
        self.resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    public func setObserver<ObserverType: ObjectBindingObserver where ObserverType.ResultType == ResultType>(observer: ObserverType) {
        
        self.observer = AnyObjectBindingObserver(base: observer)
        
        if resultsController.delegate == nil {
            
            resultsController.delegate = self
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        guard let result = anObject as? T else {
            
            fatalError("failed to cast \(anObject) to \(T.self)")
        }
        
        switch type {
            
        case .Insert:
            
            observer?.objectInserted(result)
            
        case .Update:
            
            observer?.objectUpdated(result)
            
        case .Delete:
            
            observer?.objectDeleted(result)
            
        default:
            
            print("")
        }
    }
}


// A type erasure class that abstracts a ObjectBindingObserver implementation and 
// weakly retains it by capturing it in a closure

final class AnyObjectBindingObserver<T: EntityType>: ObjectBindingObserver {
    
    typealias ResultType = T
    
    private let _inserted: T -> ()
    private let _updated: T -> ()
    private let _deleted: T -> ()
    
    init<Base where Base: ObjectBindingObserver, Base.ResultType == T>(base: Base) {
        
        _inserted = { [weak weakBase = base] in
            
            weakBase?.objectInserted($0)
        }
        
        _updated = { [weak weakBase = base] in
            
            weakBase?.objectInserted($0)
        }
        
        _deleted = { [weak weakBase = base] in
            
            weakBase?.objectDeleted($0)
        }
    }
    
    func objectInserted(object: ResultType) {
        
        _inserted(object)
    }
    
    func objectUpdated(object: ResultType) {
        
        _updated(object)
    }
    
    func objectDeleted(object: ResultType) {
        
        _deleted(object)
    }
}

