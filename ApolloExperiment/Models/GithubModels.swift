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

struct UserContainer: Decodable {
    let user: User
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

struct SearchResultContainer: Decodable {
    let search: SearchResult
}

struct SearchResult: Decodable {
    var pageInfo: Paging
    var edges: [SearchResultEdge]
}

extension SearchResult {
    init(fragment: SearchDetails) {
        pageInfo = Paging(fragment: fragment.pageInfo.fragments.pageDetails)
        edges = fragment.edges?
            .flatMap { $0?.fragments.edgeResultDetails }
            .flatMap { SearchResultEdge(fragment: $0) } ?? []
    }
}

struct SearchResultEdge: Decodable {
    let cursor: String
    let node: Repository?
}

extension SearchResultEdge {
    init(fragment: EdgeResultDetails) {
        cursor = fragment.cursor
        if let details = fragment.node?.asRepository?.fragments.repositoryDetails {
            node = Repository(fragment: details)
        } else {
            node = nil
        }
    }
}

struct Paging: Decodable {
    let startCursor: String?
    let endCursor: String?
    let hasNextPage: Bool
    let hasPreviousPage: Bool
}

extension Paging {
    init(fragment: PageDetails) {
        startCursor = fragment.startCursor
        endCursor = fragment.endCursor
        hasNextPage = fragment.hasNextPage
        hasPreviousPage = fragment.hasPreviousPage
    }
}

struct Repository: Decodable {
    let id: String
    let name: String
    let url: URL
}

extension Repository {
    init(fragment: RepositoryDetails) {
        id = fragment.id
        name = fragment.name
        url = URL(string: fragment.url)!
    }
}
