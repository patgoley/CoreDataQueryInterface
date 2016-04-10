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

import XCTest
import CoreData
@testable import CoreDataQueryInterface

class ManagedObjectContextTests: BaseTestCase {

    func testNewEntity() {
        let employee: Employee = managedObjectContext.newEntity()
        managedObjectContext.deleteObject(employee)
    }
    
    func testRequestWithMOC() {
        let request = EntityQuery.from(Employee).request(managedObjectContext)
        let employees = try! managedObjectContext.executeFetchRequest(request)
        XCTAssertEqual(employees.count, 25)
    }
    
    func testCountWithMOC() {
        let departmentCount = EntityQuery.from(Department).count(managedObjectContext)
        XCTAssertEqual(departmentCount, 3)
    }
    
    func testRequestWithModel() {
        let request = EntityQuery.from(Employee).request(BaseTestCase.managedObjectModel)
        let employees = try! managedObjectContext.executeFetchRequest(request)
        XCTAssertEqual(employees.count, 25)
    }
}