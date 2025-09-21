//
//  ErrorHandler.swift
//  FXViewer
//
//  Created by Nik Dub on 9/21/25.
//

import Foundation

final class ErrorHandler {
    func mapError(_ error: Error) -> FXError {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorNetworkConnectionLost:
            return .connectionLost
        case NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost:
            return .serverUnavailable
        case NSURLErrorBadServerResponse:
            return .badResponse
        default:
            return .unknown
        }
    }
}
