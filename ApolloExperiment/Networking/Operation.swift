//
//  Operation.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import Foundation

class Operation: Foundation.Operation {

    enum State: String {
        case cancelled
        case executing
        case finished

        var keyValue: String {
            return "is" + rawValue.capitalized
        }
    }

    private var _executing = false
    override var isExecuting: Bool {
        get { return _executing }
        set {
            if _executing != newValue {
                willChangeState(to: .executing)
                _executing = newValue
                didChangeState(to: .executing)
            }
        }
    }

    private var _finished = false
    override var isFinished: Bool {
        get { return _finished }
        set {
            if _finished != newValue {
                willChangeState(to: .finished)
                _finished = newValue
                didChangeState(to: .finished)

                if _finished == true {
                    isExecuting = false
                }
            }
        }
    }

    private var _cancelled = false
    override var isCancelled: Bool {
        get { return _cancelled }
        set {
            if _cancelled != newValue {
                willChangeState(to: .cancelled)
                _cancelled = newValue
                didChangeState(to: .cancelled)
            }
        }
    }

    override func cancel() {
        super.cancel()
        isCancelled = true
    }

    final override func start() {
        guard isCancelled == false else {
            isFinished = true
            return
        }

        guard isExecuting == false else { return }

        isExecuting = true
        execute()
    }

    func execute() {
        main()
    }

    deinit {
        print("\(self) -- deinit")
    }

    private func willChangeState(to state: State) {
        willChangeValue(forKey: state.keyValue)
    }

    private func didChangeState(to state: State) {
        didChangeValue(forKey: state.keyValue)
    }
}
