//
//  Point+CoreDataProperties.swift
//  assign4
//
//  Created by Duy on 10/27/21.
//
//

import Foundation
import CoreData


extension Point {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var track: Track?

}

extension Point : Identifiable {

}
