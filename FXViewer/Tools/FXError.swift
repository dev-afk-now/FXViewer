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
}
