//
//  PlaceDataManager.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/6/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import CoreData
import UIKit

final class PlaceDataManager {
    
    private var places: [Place] = []
    private var managedContext: NSManagedObjectContext? = nil
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            return
        }
        
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func getPlaces() -> [Place] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlaceEntity")
        
        do {
            let savedPlaces = try managedContext?.fetch(fetchRequest)
            self.places = adapt(storedPlaces: savedPlaces)
            return self.places
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return places
    }
    
    func save(place: Place) {
        guard let managedContext = managedContext,
            let entity = NSEntityDescription.entity(forEntityName: "PlaceEntity",
                                       in: managedContext) else {
            return
        }
        
        let newPlace = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        newPlace.setValue(place.name, forKeyPath: "name")
        newPlace.setValue(place.address, forKeyPath: "address")
        newPlace.setValue(place.location, forKeyPath: "location")
        newPlace.setValue(place.typeString, forKeyPath: "type")
        newPlace.setValue(place.from, forKeyPath: "from")
        newPlace.setValue(place.to, forKeyPath: "to")
        newPlace.setValue(place.createdUTC, forKeyPath: "created_utc")
        try? managedContext.save()
    }
    
    private func adapt(storedPlaces: [NSManagedObject]?) -> [Place] {
        var places: [Place] = []
        storedPlaces?.forEach({ (model) in
            if let place = Place.fromManagedContext(model: model) {
                places.append(place)
            }
        })
        return places
    }
}
