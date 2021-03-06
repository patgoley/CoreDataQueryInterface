/*
The MIT License (MIT)

Copyright (c) 2015 Gregory Higley (Prosumma)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import CoreData
import Foundation

extension QueryType {
    /**
    Constructs a fetch request from the preceding CDQI chain.
    
    - parameter managedObjectModel: The `NSManagedObjectModel` whose metadata is used to construct the fetch request.
    */
    public func request(managedObjectModel: NSManagedObjectModel) -> NSFetchRequest {
        return builder.request(resultType, managedObjectModel: managedObjectModel)
    }
    
    /**
    Same as `request(_:managedObjectModel:)` but gets the model from the given or implied
    `NSManagedObjectContext`.
    
    - parameter managedObjectContext: An optional `NSManagedObjectContext`. If passed, supercedes the one in the chain.
    - warning: If no `NSManagedObjectContext` exists in the chain, an exception will be thrown.
    */
    public func request(managedObjectContext: NSManagedObjectContext? = nil) -> NSFetchRequest {
        return builder.request(resultType, managedObjectContext: managedObjectContext)
    }
    
    /**
    Execute the fetch request built by the CDQI chain.
    
    - parameter managedObjectContext: An optional `NSManagedObjectContext`. If passed, supercedes the one in the chain.
    */
    public func all(managedObjectContext: NSManagedObjectContext? = nil) -> [QueryResultType] {
        return builder.execute(managedObjectContext, resultType: resultType)
    }
    
    /**
    Executes `countForFetchRequest` on the fetch request built by the CDQI chain.
    
    - parameter managedObjectContext: An optional `NSManagedObjectContext`. If passed, supercedes the one in the chain.
    */
    public func count(managedObjectContext: NSManagedObjectContext? = nil) -> UInt {
        return builder.count(managedObjectContext)
    }
    
    /**
    Executes the fetch request built by the CDQI chain and returns the first record, if any.
    
    - note: Calls `limit(1)` before executing for efficiency.
    - parameter managedObjectContext: An optional `NSManagedObjectContext`. If passed, supercedes the one in the chain.
    */
    public func first(managedObjectContext: NSManagedObjectContext? = nil) -> QueryResultType? {
        return limit(1).all(managedObjectContext).first
    }
    
    /**
    Returns true if any entities match the given query.
     
     - note: Calls `limit(1)` before executing for efficiency.
     - parameter managedObjectContext: An optional `NSManagedObjectContext`. If passed, supercedes the one in the chain.
    */
    public func exists(managedObjectContext: NSManagedObjectContext? = nil) -> Bool {
        let count = limit(1).count(managedObjectContext)
        return count > 0
    }
}

extension ExpressionQueryType {
    /**
    Returns the given expression as an array of `T`.
    
    - warning: Any preceding expressions in the CDQI chain are overwritten by `expression`. If the cast to `T` fails,
    a runtime exception will occur.
    */
    public func array<T>(expression: CustomPropertyConvertible, managedObjectContext: NSManagedObjectContext? = nil) -> [T] {
        var builder = self.builder
        builder.expressions = [expression]
        let results = ExpressionQuery(builder: builder).all(managedObjectContext) as NSArray
        if results.count > 0 {
            let key = (results[0] as! NSDictionary).allKeys.first! as! String
            return results.valueForKey(key) as! [T]
        } else {
            return []
        }
    }
    
    /**
    Returns the given expression as an array of `T`.
    
    - warning: Any preceding expressions in the CDQI chain are overwritten by `expression`. If the cast to `T` fails,
    a runtime exception will occur.
    */
    public func array<T>(managedObjectContext managedObjectContext: NSManagedObjectContext? = nil, _ expression: QueryEntityType.EntityAttributeType -> CustomPropertyConvertible) -> [T] {
        let attribute = QueryEntityType.EntityAttributeType()
        return array(expression(attribute), managedObjectContext: managedObjectContext)
    }
    
    /**
    Returns the value of `expression` for the first row as type `T`. In other words, this returns the value of the first row
    in the first column.
    
    - warning: Any preceding expressions in the CDQI chain are overwritten by `expression`. If the cast to `T` fails,
    a runtime exception will occur.
    */
    public func value<T>(expression: CustomPropertyConvertible, managedObjectContext: NSManagedObjectContext? = nil) -> T? {
        var builder = self.builder
        builder.expressions = [expression]
        if let result = ExpressionQuery(builder: builder).first(managedObjectContext) {
            let key = result.allKeys.first! as! String
            return (result[key]! as! T)
        } else {
            return nil
        }
    }
    
    /**
    Returns the value of `expression` for the first row as type `T`. In other words, this returns the value of the first row
    in the first column.
    
    - warning: Any preceding expressions in the CDQI chain are overwritten by `expression`. If the cast to `T` fails,
    a runtime exception will occur.
    */
    public func value<T>(managedObjectContext managedObjectContext: NSManagedObjectContext? = nil, _ expression: QueryEntityType.EntityAttributeType -> CustomPropertyConvertible) -> T? {
        let attribute = QueryEntityType.EntityAttributeType()
        return value(expression(attribute), managedObjectContext: managedObjectContext)
    }
}
