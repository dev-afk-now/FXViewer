//
//  AuthInterceptor.swift
//  FXViewer
//
//  Created by Nik Dub on 9/19/25.
//

import Apollo
import ApolloAPI

final class AuthInterceptor: ApolloInterceptor {
    var id = "authinterceptor"
    
    func interceptAsync<Operation>(
        chain: any Apollo.RequestChain,
        request: Apollo.HTTPRequest<Operation>,
        response: Apollo.HTTPResponse<Operation>?,
        completion: @escaping (Result<Apollo.GraphQLResult<Operation.Data>, any Error>) -> Void
    ) where Operation : ApolloAPI.GraphQLOperation {
        request.addHeader(
            name: "Authorization",
            value: "ApiKey \(token)"
        )
        chain.proceedAsync(
            request: request,
            response: response,
            interceptor: self,
            completion: completion
        )
    }
    
    private let token: String

    init(token: String) {
        self.token = token
    }
}
