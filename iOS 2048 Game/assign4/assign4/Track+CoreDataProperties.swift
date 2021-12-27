//
//  Track+CoreDataProperties.swift
//  assign4
//
//  Created by Duy on 10/27/21.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var name: String
    @NSManaged public var time: String
    @NSManaged public var points: NSSet

}

// MARK: Generated accessors for points
extension Track {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: Point)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: Point)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}

extension Track : Identifiable {

}
