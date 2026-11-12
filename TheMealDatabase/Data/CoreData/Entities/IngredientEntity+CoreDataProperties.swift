//
//  IngredientEntity+CoreDataProperties.swift
//  TheMealDatabase
//
//  Created by Artur on 04.11.2026.
//
//

public import Foundation
public import CoreData


public typealias IngredientEntityCoreDataPropertiesSet = NSSet

extension IngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientEntity> {
        return NSFetchRequest<IngredientEntity>(entityName: "IngredientEntity")
    }

    @NSManaged nonisolated public var name: String
    @NSManaged nonisolated public var measure: String?
    @NSManaged nonisolated public var meal: MealEntity?

}

extension IngredientEntity : Identifiable {

}
