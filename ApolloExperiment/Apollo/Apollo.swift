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

    if let githubToken = TokenManager.shared.githubOAuth {
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(githubToken)"]
    }
    let url = URL(string: "https://api.github.com/graphql")!
    let transport = HTTPNetworkTransport(url: url, configuration: configuration)
    let client = ApolloClient(networkTransport: transport)

    return client
}()

final class ApolloWrapper<T: Decodable> {
    typealias ApolloCompletion<T> = (Result<T, NetworkError>) -> Void

    func fetch<Query: GraphQLQuery>(query: Query, completion: ApolloCompletion<T>?) {
        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { (result, error) in
            if let error = error {
                completion?(.failure(NetworkError.error(error)))
                return
            }
            guard let data = result?.data else { return }

            do {
                let object = try JSONDecoder.iso.decode(T.self, from: data.jsonObject.toData())
                completion?(.success(object))
            } catch {
                print("Error decoding: \(T.self) with error \(error)")
                completion?(.failure(NetworkError.error(error)))
            }
        }
    }
}
