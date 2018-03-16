//
//  Apollo.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation
import Apollo

let apollo: ApolloClient = {
    let configuration = URLSessionConfiguration.default

    configuration.httpAdditionalHeaders = ["Authorization": "Bearer c22ca9a5db39e2afda185cc1423308c118d94aa4"]
    let url = URL(string: "https://api.github.com/graphql")!
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    let client = ApolloClient(networkTransport: transport)

    return client
}()

final class ApolloWrapper {
    typealias ApolloCompletion<T> = (Result<T, NetworkError>) -> Void

    static func fetch<Query: GraphQLQuery>(query: Query, completion: ApolloCompletion<Query.Data>?) {
        apollo.fetch(query: query, cachePolicy: CachePolicy.fetchIgnoringCacheData) { (result, error) in
            if let error = error {
                completion?(.failure(NetworkError.error(error)))
                return
            }

            guard let data = result?.data else { return }

            completion?(.success(data))
        }
    }
}
