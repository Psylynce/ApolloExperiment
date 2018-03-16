//
//  FirstViewController.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/15/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var nodes = [Node]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let query = GetLastRepositoriesQuery(number: nil)
        apollo.fetch(query: query) { (result, error) in
            if let error = error {
                print("Error using Apollo: \(error)")
            }

            guard let data = result?.data else { return }

            let user = User.convert(fragment: data.viewer.fragments.userDetails)
            self.navigationItem.title = "\(user.name) | \(user.login)"
            let repositories = Repositories.convert(fragment: data.viewer.repositories.fragments.repositoriesDetails)
            self.nodes = repositories.nodes
            self.tableView.reloadData()
        }

//        ApolloWrapper.fetch(query: query) { [weak self] result in
//            guard let strongSelf = self else { return }
//
//            switch result {
//            case let .success(data):
//                let user = User.convert(fragment: data.viewer.fragments.userDetails)
//                strongSelf.navigationItem.title = "\(user.name) | \(user.login)"
//                let repositories = Repositories.convert(fragment: data.viewer.repositories.fragments.repositoriesDetails)
//                strongSelf.nodes = repositories.nodes
//                strongSelf.tableView.reloadData()
//            case .failure:
//                return
//            }
//        }
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nodes[indexPath.row].name

        return cell
    }
}
