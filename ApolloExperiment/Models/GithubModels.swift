//
//  GithubModels.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation
import Apollo

struct Container<T: Decodable>: Decodable {
    let data: T
}

struct Viewer: Decodable {
    let viewer: User
}

struct User: Decodable {
    let name: String
    let email: String
    let avatarUrl: URL
    let login: String
    let createdAt: Date
    var repositories: Repositories
}

extension User: FragmentConvertible {
    static func convert(fragment: GraphQLFragment) -> User {
        guard let details = fragment as? UserDetails,
            let url = URL(string: details.avatarUrl) else { fatalError() }

        let date = ISO8601DateFormatter().date(from: details.createdAt) ?? Date()

        return User(name: details.name ?? "", email: details.email, avatarUrl: url, login: details.login, createdAt: date, repositories: Repositories(nodes: []))
    }
}

struct Repositories: Decodable {
    let nodes: [Node]
}

extension Repositories: FragmentConvertible {
    static func convert(fragment: GraphQLFragment) -> Repositories {
        guard let details = fragment as? RepositoriesDetails else { fatalError() }

        let nodes = details.nodes?
            .flatMap { $0?.fragments }
            .flatMap { Node.convert(fragment: $0.repositoryDetails) }

        return Repositories(nodes: nodes ?? [])
    }
}

struct Node: Decodable {
    let name: String
}

extension Node: FragmentConvertible {
    static func convert(fragment: GraphQLFragment) -> Node {
        guard let details = fragment as? RepositoryDetails else { fatalError() }

        return Node(name: details.name)
    }
}
