//
//  QueryBinding.swift
//  CoreDataQueryInterface
//
//  Created by Patrick Goley on 4/7/16.
//  Copyright © 2016 Prosumma LLC. All rights reserved.
//

import Foundation

public protocol QueryBindingProtocol {
    
    associatedtype ResultType: EntityType
}

@objc public protocol QueryBindingObserver: class {
    
    associatedtype ResultType: EntityType
}


