//
//  FragmentConvertible.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/16/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation
import Apollo

protocol FragmentConvertible {
    static func convert(fragment: GraphQLFragment) -> Self
}
