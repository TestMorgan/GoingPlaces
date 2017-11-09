//
//  Place.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/6/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import CoreData
import GooglePlaces

struct Place {
    enum PlaceCreationType {
        case selfCreated
        case received
        case sent
    }
    
    let coordinate: CLLocationCoordinate2D
    let name: String
    let address: String
    let from: String?
    let to: String?
    let createdUTC: TimeInterval
    let type: PlaceCreationType
    
    var location: String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    var typeString: String {
        switch self.type {
        case .sent:
            return "Sent"
        case .received:
            return "Received"
        case .selfCreated:
            return "Self created"
        }
    }
    
    static func type(for string: String) -> PlaceCreationType {
        if string == "Sent" {
            return .sent
        } else if string == "Received" {
            return .received
        }
        return .selfCreated
    }
    
    static func sentPlace(place: Place, to: String) -> Place {
        return Place(coordinate: place.coordinate, name: place.name, address: place.address, from: place.from, to: to, createdUTC: Date().timeIntervalSince1970, type: .sent)
    }
    
    static func fromGMSPlace(gmsplace: GMSPlace) -> Place {
        return Place(coordinate: gmsplace.coordinate, name: gmsplace.name, address: gmsplace.formattedAddress!, from: "Self", to: nil, createdUTC: Date().timeIntervalSince1970, type: .selfCreated)
    }
    
    static func fromURLParameters(values: [String: String]) -> Place? {
        guard let latitudeString = values["location"]?.split(separator: ",").first,
            let longitudeString = values["location"]?.split(separator: ",").last,
            let latitude = Double(latitudeString),
            let longitude = Double(longitudeString),
            let name = values["name"],
            let formattedAddress = values["address"],
            let from = values["from"] else {
                return nil
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Place(coordinate: coordinate, name: name, address: formattedAddress + "\n" + "From \(from)", from: from, to: "self", createdUTC: Date().timeIntervalSince1970, type: .received)
    }
    
    static func fromManagedContext(model: NSManagedObject) -> Place? {
        guard let latitudeString = (model.value(forKey: "location") as? String)?.split(separator: ",").first,
            let longitudeString = (model.value(forKey: "location") as? String)?.split(separator: ",").last,
            let latitude = Double(latitudeString),
            let longitude = Double(longitudeString),
            let name = model.value(forKey: "name") as? String,
            let formattedAddress = model.value(forKey: "address") as? String,
            let from = model.value(forKey: "from") as? String,
            let to = model.value(forKey: "to") as? String,
            let typeString = model.value(forKey: "type") as? String,
            let createdUTC = model.value(forKey: "created_utc") as? TimeInterval else {
                return nil
        }
        
        let type = Place.type(for: typeString)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Place(coordinate: coordinate, name: name, address: formattedAddress, from: from, to: to, createdUTC: createdUTC, type: type)
    }
    
}
