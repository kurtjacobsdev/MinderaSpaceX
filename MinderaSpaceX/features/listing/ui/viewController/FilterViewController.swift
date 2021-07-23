//
//  FilterViewController.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit

class FilterViewController: UIViewController {
    
    weak var coordinatorDelegate: FilterViewControllerCoordinatorDelegate?
    
    private let launchFilter = UISegmentedControl()
    private let sortFilter = UISegmentedControl()
    private let fromDate = UIDatePicker()
    private let untilDate = UIDatePicker()
    
    private let untilDateSwitch = UISwitch()
    private let fromDateSwitch = UISwitch()
    
    private let mainStack = UIStackView()
    
    private let launchTitle = UILabel()
    private let sortTitle = UILabel()
    private let dateTitle = UILabel()
    private let fromDateTitle = UILabel()
    private let untilDateTitle = UILabel()
    private let fromDateStack = UIStackView()
    private let untilDateStack = UIStackView()
    
    private let filterPersistence = FileWriterWorker<LaunchFilterModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        configureUI()
    
        if let state = filterPersistence.retrieve() {
            configureSettings(model: state)
        }
    }
    
    private func configureSettings(model: LaunchFilterModel) {
        launchFilter.selectedSegmentIndex = model.launch.rawValue
        sortFilter.selectedSegmentIndex = model.sort.rawValue
        fromDate.date = model.fromYear
        untilDate.date = model.untilYear
        fromDateSwitch.isOn = model.fromYearEnabled
        untilDateSwitch.isOn = model.untilYearEnabled
    }
    
    private func setupUI() {
        view.addSubview(mainStack)
        
        fromDateStack.addArrangedSubview(fromDateTitle)
        fromDateStack.addArrangedSubview(fromDate)
        fromDateStack.addArrangedSubview(fromDateSwitch)
        
        untilDateStack.addArrangedSubview(untilDateTitle)
        untilDateStack.addArrangedSubview(untilDate)
        untilDateStack.addArrangedSubview(untilDateSwitch)
        
        mainStack.addArrangedSubview(launchTitle)
        mainStack.addArrangedSubview(launchFilter)
        mainStack.addArrangedSubview(sortTitle)
        mainStack.addArrangedSubview(sortFilter)
        mainStack.addArrangedSubview(dateTitle)
        mainStack.addArrangedSubview(fromDateStack)
        mainStack.addArrangedSubview(untilDateStack)
        
        launchFilter.insertSegment(withTitle: LaunchFilterType.all.title, at: LaunchFilterType.all.rawValue, animated: false)
        launchFilter.insertSegment(withTitle: LaunchFilterType.failed.title, at: LaunchFilterType.failed.rawValue, animated: false)
        launchFilter.insertSegment(withTitle: LaunchFilterType.successful.title, at: LaunchFilterType.successful.rawValue, animated: false)
        
        sortFilter.insertSegment(withTitle: SortFilterType.asc.title, at: SortFilterType.asc.rawValue, animated: false)
        sortFilter.insertSegment(withTitle: SortFilterType.desc.title, at: SortFilterType.desc.rawValue, animated: false)
    }
    
    private func layoutUI() {
        mainStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureUI() {
        launchFilter.selectedSegmentIndex = 0
        sortFilter.selectedSegmentIndex = 0
        
        fromDate.datePickerMode = .date
        untilDate.datePickerMode = .date
        
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.axis = .vertical
        mainStack.spacing = 10
        
        fromDateStack.alignment = .fill
        fromDateStack.distribution = .fill
        fromDateStack.axis = .horizontal
        fromDateStack.spacing = 10
        
        untilDateStack.alignment = .fill
        untilDateStack.distribution = .fill
        untilDateStack.axis = .horizontal
        untilDateStack.spacing = 10
        
        view.backgroundColor = .white
        
        navigationItem.title = "Filters"
        fromDateTitle.text = "From: "
        untilDateTitle.text = "Until: "
        launchTitle.text = "Launch Filters"
        sortTitle.text = "Sort Filters"
        dateTitle.text = "Date Filters"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close,
                                                           target: self,
                                                           action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save,
                                                            target: self,
                                                            action: #selector(save))
    }
    
    @objc private func close() {
        coordinatorDelegate?.didCancel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        _ = filterPersistence.save(data: LaunchFilterModel(fromYear: fromDate.date, untilYear: untilDate.date, sort: SortFilterType.init(rawValue: sortFilter.selectedSegmentIndex) ?? SortFilterType.asc, launch: LaunchFilterType.init(rawValue: launchFilter.selectedSegmentIndex) ?? LaunchFilterType.all, fromYearEnabled: fromDateSwitch.isOn, untilYearEnabled: untilDateSwitch.isOn))
        coordinatorDelegate?.didSave()
        self.dismiss(animated: true, completion: nil)
    }
}
