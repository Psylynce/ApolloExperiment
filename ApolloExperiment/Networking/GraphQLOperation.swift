//
//  GraphQLOperation.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

enum NetworkError: Swift.Error {
    case error(Error)
}

final class GraphQLOperation<Model: Decodable>: Operation {

    typealias NetworkCompletion = ((Result<Model, NetworkError>) -> Void)
    override var isAsynchronous: Bool { return true }

    let query: Query

    var data: Data?
    var model: Model?
    var error: Error?

    private let decoder: JSONDecoder
    private var task: URLSessionDataTask?
    private var completion: NetworkCompletion?

    init(query: Query, decoder: JSONDecoder = JSONDecoder(), completion: NetworkCompletion? = nil) {
        self.query = query
        self.decoder = decoder
        self.completion = completion
        super.init()
        qualityOfService = .userInitiated
    }

    override func main() {
        guard isCancelled == false else {
            isFinished = true
            return
        }

        task = URLSession.shared.dataTask(with: query.request()) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }

            guard strongSelf.isCancelled == false, let data = data else {
                strongSelf.isFinished = true
                return
            }

            if let error = error {
                strongSelf.error = error
                DispatchQueue.main.async {
                    strongSelf.completion?(.failure(NetworkError.error(error)))
                }
                print("""
                    NetworkOperation Network Error: \(error)
                    """)
                strongSelf.isFinished = true
                return
            }

            strongSelf.data = data
            do {
                let model = try strongSelf.decoder.decode(Model.self, from: data)
                strongSelf.model = model
                DispatchQueue.main.async {
                    strongSelf.completion?(.success(model))
                }
            } catch {
                print("""
                    Error decoding \(Model.self): \(error)
                    """)
                DispatchQueue.main.async {
                    strongSelf.completion?(.failure(NetworkError.error(error)))
                }
            }

            strongSelf.isFinished = true
        }

        task?.resume()
    }

    override func cancel() {
        task?.cancel()
    }
}
