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
        request.allHTTPHeaderFields = [
            "Authorization": "bearer c22ca9a5db39e2afda185cc1423308c118d94aa4",
            "Content-Type": "application/json; charset=utf-8"
        ]
        body["query"] = query
        request.httpBody = body.toData()
        return request
    }
}

// c22ca9a5db39e2afda185cc1423308c118d94aa4
