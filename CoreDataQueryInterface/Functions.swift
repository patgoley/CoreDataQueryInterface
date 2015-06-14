//
//  Functions.swift
//  CoreDataQueryInterface
//
//  Created by Gregory Higley on 6/13/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import CoreData
import Foundation

extension Expression {
    
    public static func max(keyPath: CustomStringConvertible, name: String? = nil, type: NSAttributeType? = nil) -> Expression {
        return Expression.Function("max:", String(keyPath), name, type)
    }
    
}