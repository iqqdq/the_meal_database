//
//  MealEntity+CoreDataProperties.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//
//

public import Foundation
public import CoreData


public typealias MealEntityCoreDataPropertiesSet = NSSet

extension MealEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealEntity> {
        return NSFetchRequest<MealEntity>(entityName: "MealEntity")
    }

    @NSManaged nonisolated public var idMeal: String?
    @NSManaged nonisolated public var strArea: String?
    @NSManaged nonisolated public var strCategory: String?
    @NSManaged nonisolated public var strInstructions: String?
    @NSManaged nonisolated public var strMeal: String?
    @NSManaged nonisolated public var strMealThumb: String?
    @NSManaged nonisolated public var isFavourite: Bool
    @NSManaged nonisolated public var ingredients: NSSet?

}

// MARK: Generated accessors for ingredients
extension MealEntity {

    @objc(addIngredientsObject:)
    @NSManaged nonisolated public func addToIngredients(_ value: IngredientEntity)

    @objc(removeIngredientsObject:)
    @NSManaged nonisolated public func removeFromIngredients(_ value: IngredientEntity)

    @objc(addIngredients:)
    @NSManaged nonisolated public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged nonisolated public func removeFromIngredients(_ values: NSSet)

}

extension MealEntity : Identifiable {

}
