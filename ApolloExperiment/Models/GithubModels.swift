//
//  GithubModels.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

struct Container<T: Decodable>: Decodable {
    let data: T
}

struct Viewer: Decodable {
    let viewer: User
}

struct User: Decodable {
    let name: String
    let repositories: Repository
}

struct Repository: Decodable {
    let nodes: [Node]
}

struct Node: Decodable {
    let name: String
}
