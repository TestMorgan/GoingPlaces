//
//  DeepLinkManager.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import GooglePlaces

final class DeepLinkManager: NSObject {
    
    private let deepLinkFunc: [String: Selector] = ["openLocation": #selector(openLocation)]
    
    func canOpenURL(url: URL) -> Bool {
        if let host = url.host, deepLinkFunc.keys.contains(host) {
            return true
        }
        return false
    }
    
    func openURL(url: URL) {
        guard let host = url.host else {
            return
        }
        
        let selector = deepLinkFunc[host]
        perform(selector, with: url)
    }
    
}

// Open Location extension.
extension DeepLinkManager {
    
    @objc func openLocation(url: URL) {
        let values = parseOpenLocationQuery(query: url.query)
        displayMainViewController(with: values)
    }
    
    private func parseOpenLocationQuery(query: String?) -> [String: String] {
        let parametersAndValues = query?.split(separator: "&")
        var values: [String: String] = [:]
        parametersAndValues?.forEach({ (parameterAndValue) in
            if let parameterSubsequence = parameterAndValue.split(separator: "=").first,
                let valueSubsequence = parameterAndValue.split(separator: "=").last {
                let parameter = String(describing: parameterSubsequence)
                let value = String(describing: valueSubsequence)
                values[parameter] = value.removingPercentEncoding
            }
        })
        return values
    }
    
    private func displayMainViewController(with infos: [String: String]) {
        if let place = Place.fromURLParameters(values: infos) {
            let router = MainRouter()
            router.routeToRoot(place: place)
        }
    }
    
}
