#if canImport(UIKit)
import UIKit
#endif

public final class DebugViewController: UIViewController {
    private enum Constants {
        static let title = "Debug"
        static let debugCellIdentifier = "DebugCell"
    }

    internal static var moduleSet: MetatypeSet = MetatypeSet()
    private var modules: [DebugPresentable.Type] = moduleSet.compactMap { $0 as? DebugPresentable.Type }

    private var isFiltering: Bool = false
    private var filteredModules: [SearchResult] = []

    private lazy var tableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: Constants.debugCellIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView())

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.title
        setupSearchViewController()

        view.addSubview(tableView)
        tableView.pin(to: view)
    }

    private func setupSearchViewController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            searchController.hidesNavigationBarDuringPresentation = false
            tableView.tableHeaderView = searchController.searchBar
        }
    }
}

extension DebugViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isFiltering else {
            return filteredModules.count
        }
        return modules.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.debugCellIdentifier, for: indexPath)
        let moduleType: DebugPresentable.Type
        if isFiltering, let type = filteredModules[indexPath.row].type {
            let result = filteredModules[indexPath.row]
            cell.detailTextLabel?.text = result.renderedPath
            moduleType = type
        } else {
            let type = modules[indexPath.row]
            moduleType = type
        }
        cell.textLabel?.text = moduleType.name
        cell.imageView?.image = moduleType.icon
        return cell
    }
}

extension DebugViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = modules[indexPath.row].createViewController()
        show(detail, sender: nil)
    }
}

extension DebugViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmptyOrWhitespace {
            filteredModules = modules.reduce(into: [], foldResultsForQuery(query))
            isFiltering = true
        } else {
            filteredModules.removeAll()
            isFiltering = false
        }
        tableView.reloadData()
    }

    private func foldResultsForQuery(_ query: String) -> (inout [SearchResult], DebugPresentable.Type) -> Void {
        return { accumulator, type in
            if type.name.contains(query) {
                let result = SearchResult(match: type.name, path: [type.name], type: type)
                accumulator.append(result)
            }
            let subresults: [SearchResult] = type.searchResultsWithinModule(for: query).map {
                .init(match: $0.match, path: $0.path, type: type)
            }
            accumulator.append(contentsOf: subresults)
        }
    }
}
