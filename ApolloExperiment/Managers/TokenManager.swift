//
//  TokenManager.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/19/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

final class TokenManager {

    static let shared = TokenManager()

    private var tokens = [String: String]()

    init() {
        readPropertyList()
    }

    private func readPropertyList() {
        guard let path = Bundle.main.path(forResource: "Tokens", ofType: "plist"),
            let plist = FileManager.default.contents(atPath: path) else { return }

        do {
            tokens = try PropertyListDecoder().decode([String: String].self, from: plist)
        } catch {
            print("Error serializing plist: \(error)")
        }
    }
}

extension TokenManager {
    var githubOAuth: String? {
        return tokens["github"]
    }
}
