//
//  Ingredient+CoreDataProperties.swift
//  recipeApp_coredata
//
//  Created by Duy on 12/5/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?

}

extension Ingredient : Identifiable {

}
