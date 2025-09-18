//
//  GraphQLService.swift
//  FXViewer
//
//  Created by Nik Dub on 9/18/25.
//

import Apollo
//
//protocol GraphQLServiceProtocol {
//    func fetchUser(id: String) async throws -> User
//}
//
//final class GraphQLService: GraphQLServiceProtocol {
//    private let client: ApolloClient
//
//    init(client: ApolloClient) {
//        self.client = client
//    }
//
//    func fetchUser(id: String) async throws -> User {
//        let query = GetUserQuery(id: id)
//        let result = try await client.fetchAsync(query: query)
//        guard let gqlUser = result.data?.user else {
//            throw APIError.notFound
//        }
//        return gqlUser.toDomain()
//    }
//}
