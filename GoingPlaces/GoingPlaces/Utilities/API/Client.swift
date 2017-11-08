//
//  Client.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/1/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation

import Foundation
import OAuthSwift

/// HTTP Method.
public enum HTTPMethod: String {
    case GET
    case POST
    var oAuthMethod: OAuthSwiftHTTPRequest.Method {
        get {
            switch self {
            case .GET:
                return OAuthSwiftHTTPRequest.Method.GET
            case .POST:
                return OAuthSwiftHTTPRequest.Method.POST
            }
        }
    }
}

/// Request Error enum.
///
/// - invalidRequest: Invalid request error.
/// - unknown: Unknown error.
/// - badURL: Bad URL error.
enum RequestError: Error {
    case invalidRequest(error: NSError)
    case unknown
    case badURL
}

/// Client class.
class Client {
    
    // MARK: - Private properties
    
    private let consumerKey: String
    private let consumerSecret: String
    private let oAuthCredential: OAuthSwiftCredential
    
    // MARK: - Init methods
    
    init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        
        let credential = OAuthSwiftCredential(consumerKey: consumerKey, consumerSecret: consumerSecret)
        credential.oauthToken = accessToken
        credential.oauthTokenSecret = accessTokenSecret
        self.oAuthCredential = credential
    }
    
    // MARK: - Public methods
    
    /// Construct URL request with given parameters.
    ///
    /// - Parameters:
    ///   - method: HTTP Method.
    ///   - urlString: URL String.
    ///   - parameters: Parameters.
    /// - Returns: URLRequest instance.
    /// - Throws: Throws RequestError if fail.
    func request(_ method: HTTPMethod, url urlString: String, parameters: Dictionary<String, String>) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw RequestError.badURL
        }
        
        let authorization = oAuthCredential.authorizationHeader(method: method.oAuthMethod, url: url, parameters: parameters)
        let headers = ["Authorization": authorization]
        
        let request: URLRequest
        
        do {
            request = try OAuthSwiftHTTPRequest.makeRequest(url:
                url, method: method.oAuthMethod, headers: headers, parameters: parameters, dataEncoding: String.Encoding.utf8) as URLRequest
        } catch let error as NSError {
            throw RequestError.invalidRequest(error: error)
        } catch {
            throw RequestError.unknown
        }
        
        return request
    }
    
}
