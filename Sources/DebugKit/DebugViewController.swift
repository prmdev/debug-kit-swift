#if canImport(UIKit)
import UIKit
#endif

private typealias ModuleMap = [ModuleDomain: [DebugModule.Type]]
private func metatypesToKeyedModuleMap(accumulator: inout ModuleMap, type: Any.Type) {
    guard let moduleType = type as? DebugModule.Type else {
        return
    }
    accumulator[moduleType.domain, default: []].append(moduleType)
}

public class DebugViewController: UIViewController {
    private enum Constants {
        static let title = "Debug"
        static let debugCellIdentifier = "DebugCell"
    }
    
    internal static var moduleSet: MetatypeSet = MetatypeSet()
    private var modules: ModuleMap = DebugViewController.moduleSet.reduce(into: [:], metatypesToKeyedModuleMap)
    private var domains: [ModuleDomain] {
        return modules.keys.sorted(by: <)
    }
    
    private var isFiltering: Bool = false
    private var filteredModules: [SearchResult] = []
    
    private lazy var tableView: UITableView = {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: Constants.debugCellIdentifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.title
        setupSearchViewController()
        
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
    
    func setupSearchViewController() {
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
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard !isFiltering else {
            return 1
        }
        return domains.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !isFiltering else {
            return filteredModules.count
        }
        let domain = domains[section]
        return modules[domain]?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.debugCellIdentifier, for: indexPath)
        let domain = domains[indexPath.section]
        let moduleType: DebugModule.Type
        if isFiltering, let type = filteredModules[indexPath.row].type {
            let result = filteredModules[indexPath.row]
            cell.detailTextLabel?.text = result.renderedPath
            moduleType = type
        } else if let type = modules[domain]?[indexPath.row] {
            moduleType = type
        } else {
            return cell
        }
        cell.textLabel?.text = moduleType.name
        cell.imageView?.image = moduleType.icon
        return cell
    }
}

extension DebugViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let domain = domains[indexPath.section]
        guard let module = modules[domain]?[indexPath.row] else {
            return
        }
        let info = AppInfo(name: "DebugKitExample", major: 1, minor: 0, patch: 0)
        let detail = module.make(forApp: info)
        show(detail, sender: nil)
    }
}

extension DebugViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmptyOrWhitespace {
            let types = modules.values.flatMap { $0 }
            filteredModules = types.reduce(into: []) { acc, type in
                if type.name.contains(query) {
                    let result = SearchResult(match: type.name, path: [type.name], type: type)
                    acc.append(result)
                }
                let subresults: [SearchResult] = type.searchResults(for: query).map { .init(match: $0.match, path: $0.path, type: type) }
                acc.append(contentsOf: subresults)
            }
            isFiltering = true
        } else {
            filteredModules.removeAll()
            isFiltering = false
        }
        tableView.reloadData()
    }
}
