//
//  NetworkInterceptorProvider.swift
//  FXViewer
//
//  Created by Nik Dub on 9/19/25.
//

import Apollo
import ApolloAPI

final class NetworkInterceptorProvider: DefaultInterceptorProvider {
    private let token: String?

    init(store: ApolloStore, token: String? = nil) {
        self.token = token
        super.init(store: store)
    }

    override func interceptors<Operation: GraphQLOperation>(
        for operation: Operation
    ) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        guard let token = token else {
            return interceptors
        }
        interceptors.insert(AuthInterceptor(token: token), at: .zero)
        return interceptors
    }
}
