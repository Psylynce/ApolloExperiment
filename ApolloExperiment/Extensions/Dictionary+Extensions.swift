//
//  Dictionary+Extensions.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

extension Dictionary {
    func toData(options: JSONSerialization.WritingOptions = []) -> Data {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            return data
        } catch {
            return Data()
        }
    }

    func prettyPrintedJSON() -> String {
        return String(data: toData(options: .prettyPrinted), encoding: .utf8) ?? ""
    }
}
