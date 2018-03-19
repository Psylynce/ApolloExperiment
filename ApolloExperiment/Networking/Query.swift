//
//  Query.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

final class GithubAPI: Query {

    override init(url: URL = URL(string: "https://api.github.com/graphql")!, query: String) {
        super.init(url: url, query: query)
    }
}

struct QueryConfiguration {
    let token: String
}

class Query {

    let url: URL
    let query: String

    private var body = JSON()

    init(url: URL, query: String) {
        self.url = url
        self.query = query
    }

    func request() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headerFields = [
            "Content-Type": "application/json; charset=utf-8"
        ]

        if let githubToken = TokenManager.shared.githubOAuth {
            headerFields["Authorization"] = "Bearer \(githubToken)"
        }
        request.allHTTPHeaderFields = headerFields

        body["query"] = query
        request.httpBody = body.toData()
        return request
    }
}
