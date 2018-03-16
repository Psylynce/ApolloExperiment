//
//  SearchResultsViewController.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/16/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import UIKit

final class SearchResultsViewController: UIViewController {

    class func viewController() -> SearchResultsViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! SearchResultsViewController
        return controller
    }

    @IBOutlet weak var tableView: UITableView!

    var results = [SearchResultEdge]()

    private var paging: Paging?
    private var currentText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let result = results[indexPath.row]

        cell.textLabel?.text = result.node?.name
        cell.detailTextLabel?.text = result.node?.url.absoluteString

        return cell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = tableView.numberOfRows(inSection: indexPath.section) - 1
        guard indexPath.row == lastRow && paging?.hasNextPage == true else { return }

        let lastResult = results[lastRow]

        let query = SearchQuery(query: currentText, first: 20, after: lastResult.cursor, type: .repository)
        ApolloWrapper<SearchResultContainer>().fetch(query: query) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(container):
                strongSelf.paging = container.search.pageInfo
                strongSelf.results += container.search.edges
                strongSelf.tableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        currentText = text

        let query = SearchQuery(query: currentText, first: 20, after: nil, type: .repository)
        ApolloWrapper<SearchResultContainer>().fetch(query: query) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(container):
                strongSelf.paging = container.search.pageInfo
                strongSelf.results = container.search.edges
                strongSelf.tableView.reloadData()
            case .failure:
                return
            }
        }
    }
}
