//
//  ListingViewController.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit
import SnapKit

class ListingViewController: UIViewController {

    weak var coordinatorDelegate: ListingViewControllerCoordinatorDelegate?
    
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var refreshControl = UIRefreshControl()
    private var listingUseCaseInteractor: ListingUseCaseInteractor
    
    init(listingUseCaseInteractor: ListingUseCaseInteractor) {
        self.listingUseCaseInteractor = listingUseCaseInteractor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        configureUI()
        refresh()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func layoutUI() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        title = "SpaceX"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle.fill"), style: .plain, target: self, action: #selector(presentFilterModal))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action:#selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        listingUseCaseInteractor.refresh { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    func applyFilters() {
        listingUseCaseInteractor.applyFilters()
        self.tableView.reloadData()
    }
    
    @objc private func presentFilterModal() {
        coordinatorDelegate?.presentLaunchFilterViewController()
    }
}

// MARK: UITableView Delegate + DataSource

extension ListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            guard listingUseCaseInteractor.company.count > 0 else { return nil }
            return "Company"
        case 1:
            guard listingUseCaseInteractor.launches.count > 0 else { return nil }
            return "Launches"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listingUseCaseInteractor.company.count
        case 1:
            return listingUseCaseInteractor.launches.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let model = listingUseCaseInteractor.company[indexPath.row]
            let cell = CompanyInfoCell()
            cell.configure(viewModel: CompanyInfoViewModel(model: model))
            return cell
        case 1:
            let model = listingUseCaseInteractor.launches[indexPath.row]
            let cell = LaunchCell()
            cell.configure(viewModel: LaunchViewModel(model: model, currentDate: Date()))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let model = listingUseCaseInteractor.launches[indexPath.row]
            coordinatorDelegate?.presentLinkSelectionActionSheet(for: model)
        default:
            break
        }
    }
}



