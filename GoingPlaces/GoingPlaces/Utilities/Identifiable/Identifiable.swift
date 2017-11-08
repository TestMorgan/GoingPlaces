//
//  Identifiable.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/7/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import UIKit

protocol Identifiable {
    
    static var identifier: String { get }
    static var parentStoryboard: UIStoryboard { get }
    
}
