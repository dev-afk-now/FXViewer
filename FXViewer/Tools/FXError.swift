//
//  FXError.swift
//  FXViewer
//
//  Created by Nik Dub on 9/21/25.
//

enum FXError: Error {
    case propagated(Error)
    case dataError
    case noInternet
    case timeout
    case connectionLost
    case serverUnavailable
    case badResponse
    case unknown
    
    var message: String {
        switch self {
        case .propagated(let error):
            error.localizedDescription
        case .dataError, .badResponse, .connectionLost:
            "Couldn't fetch response"
        case .noInternet:
            "Internet connection is off, try again later"
        case .timeout:
            "Request reached timeout time"
        case .serverUnavailable:
            "Server is unavailable"
        case .unknown:
            "Unknown error"
        }
    }
}
