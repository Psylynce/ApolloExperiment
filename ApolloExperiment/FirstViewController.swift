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

    private lazy var searchController: UISearchController = {
        let resultsController = SearchResultsViewController.viewController()
        let search = UISearchController(searchResultsController: resultsController)
        search.searchResultsUpdater = resultsController
        definesPresentationContext = true
        
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let query = GetLastRepositoriesQuery(number: nil)
        apollo.fetch(query: query) { (result, error) in
            if let error = error {
                print("Error using Apollo: \(error)")
            }

            guard let data = result?.data else { return }

            do {
                let user = try JSONDecoder.iso.decode(Viewer.self, from: data.jsonObject.toData())
                print(user.viewer.name)
            } catch {
                print(error)
            }

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
