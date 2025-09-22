//
//  DIContainer.swift
//  FXViewer
//
//  Created by Nik Dub on 9/19/25.
//

import Foundation
import Apollo

final class DIContainer {
    static let shared = DIContainer()
    private(set) lazy var graphQLService: GraphQLServiceProtocol = GraphQLService(client: apolloClient)
    let storage: Storage
    private let keychainService: Storage
    
    // MARK: - Private properties -
    
    private let decoder = JSONDecoder()
    private let store = ApolloStore()
    private lazy var apolloClient = ApolloClient(
        networkTransport: transport,
        store: store
    )
    private lazy var provider = NetworkInterceptorProvider(
        store: store,
        token: keychainService.getValue(for: StorageKeys.api)
    )
    private lazy var transport = RequestChainNetworkTransport(
        interceptorProvider: provider,
        endpointURL: Globals.baseURL
    )
    private init() {
        let keychainService = KeychainService(decoder: decoder)
        let keychainDecorator = KeychainDecorator(storage: keychainService)
        keychainDecorator.prepareIfNeeded()
        self.storage = FileManagerService()
        self.keychainService = keychainDecorator
    }
}

enum Globals {
    static let baseURL = URL(string: "https://swop.cx/graphql")!
    static let baseImageURL = "https://raw.githubusercontent.com/Lissy93/currency-flags/master/assets/flags_svg/"
    static let placeholderURL = "https://placehold.co/260x200?text=No%20image"
}
