//
//  QueryBinding.swift
//  CoreDataQueryInterface
//
//  Created by Patrick Goley on 4/7/16.
//  Copyright © 2016 Prosumma LLC. All rights reserved.
//

import Foundation
import CoreData

//MARK:- Query Binding

public protocol QueryBindingProtocol {
    
    associatedtype ResultType: TypedExpressionConvertible
}

@objc public protocol QueryBindingObserver: class {
    
    associatedtype ResultType: TypedExpressionConvertible
}


//MARK:- Object Binding

public protocol ObjectQueryBindingProtocol: QueryBindingProtocol {
    
    var result: ResultType? { get }
    
    func setObserver<ObserverType: ObjectBindingObserver where ObserverType.ResultType == ResultType>(observer: ObserverType)
}

public protocol ObjectBindingObserver: class, QueryBindingObserver {
    
    func objectInserted(object: ResultType)
    
    func objectUpdated(object: ResultType)
    
    func objectDeleted()
}


class ObjectQueryBinding<T where T: TypedExpressionConvertible, T: AnyObject> : NSObject, ObjectQueryBindingProtocol, NSFetchedResultsControllerDelegate {
    
    typealias ResultType = T
    
    let resultsController: NSFetchedResultsController
    
    var result: ResultType? {
        
        if let result = resultsController.fetchedObjects?.first as? ResultType {
            return result
        } else {
            
            return nil
        }
    }
    
    convenience init<Q: QueryType where Q.QueryResultType == ResultType>(query: Q) {
        
        let context: NSManagedObjectContext = query.builder.managedObjectContext!
        
        let request: NSFetchRequest = query.request()
        
        self.init(fetchRequest: request, context: context, sectionKeyPath: nil)
    }
    
    required init(fetchRequest: NSFetchRequest, context: NSManagedObjectContext, sectionKeyPath: String? = nil) {
        
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionKeyPath, cacheName: nil)
    }
    
    func setObserver<ObserverType: ObjectBindingObserver where ObserverType.ResultType == ResultType>(observer: ObserverType) {
        
        // weakly hold reference to observer
        
        if resultsController.delegate == nil {
            
            resultsController.delegate = self
        }
    }
}

