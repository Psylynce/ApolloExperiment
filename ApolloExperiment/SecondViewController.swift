//
//  SecondViewController.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var user: User? {
        didSet {
            if navigationItem.title == nil {
                navigationItem.title = user?.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.title = "DIY"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let query = GithubQueries.getCurrentUsersRepositories(last: 5)
        let operation = GraphQLOperation<Container<Viewer>>(query: query) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(container):
                strongSelf.user = container.data.viewer
                strongSelf.tableView.reloadData()
            case .failure:
                return
            }
        }

        OperationQueue().addOperation(operation)
    }
}

extension SecondViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.repositories.nodes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let node = user?.repositories.nodes[indexPath.row] {
            cell.textLabel?.text = node.name
        }

        return cell
    }
}
