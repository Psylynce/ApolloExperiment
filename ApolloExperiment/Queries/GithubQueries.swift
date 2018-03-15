//
//  GithubQueries.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

struct GithubQueries {

    static func getCurrentUsersRepositories(last: Int) -> GithubAPI {
        let query = "query { viewer { name repositories(last: \(last)) { nodes { name }}}}"

        return GithubAPI(query: query)
    }
}
