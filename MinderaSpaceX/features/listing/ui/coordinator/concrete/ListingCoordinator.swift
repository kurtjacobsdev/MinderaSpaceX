//
//  ListingCoordinator.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit
import SafariServices

enum ListingCoordinatorTask {
    case presentSafariViewController(url: URL)
    case presentLaunchFilterViewController
    case presentLinkSelectionActionSheet(model: Launch)
    case filterLaunchList
}

class ListingCoordinator: NSObject {
    private var diContainer: DIContainer
    private (set) var navigationController = UINavigationController()
    private var rootViewController: ListingViewController
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
        self.rootViewController = ListingViewController(listingUseCaseInteractor: diContainer.listingUseCaseInteractor)
        super.init()
    }
    
    func begin() {
        rootViewController.coordinatorDelegate = self
        navigationController.viewControllers = [rootViewController]
    }
    
    func perform(task: ListingCoordinatorTask) {
        switch task {
        case let .presentSafariViewController(url: url):
            let webViewController = SFSafariViewController(url: url)
            self.navigationController.present(webViewController, animated: true, completion: nil)
        case .presentLaunchFilterViewController:
            let viewController = FilterViewController()
            viewController.coordinatorDelegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.modalPresentationStyle = .formSheet
            self.navigationController.present(navigationController, animated: true, completion: nil)
        case let .presentLinkSelectionActionSheet(model):
            let alertControllerActionSheet = UIAlertController(title: "", message: "Please Select An Action", preferredStyle: .actionSheet)
            let videoAction = UIAlertAction(title: "Video", style: .default) { action in
                guard let urlString = model.videoLink,
                      let url = URL(string: urlString) else { return }
                self.presentSafariViewController(url: url)
            }
            let wikiAction = UIAlertAction(title: "Wiki", style: .default) { action in
                guard let urlString = model.wikipediaLink,
                      let url = URL(string: urlString) else { return }
                self.presentSafariViewController(url: url)
            }
            let articleAction = UIAlertAction(title: "Article", style: .default) { action in
                guard let urlString = model.articleLink,
                      let url = URL(string: urlString) else { return }
                self.presentSafariViewController(url: url)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in }
            
            if let _ = model.wikipediaLink { alertControllerActionSheet.addAction(wikiAction) }
            if let _ = model.videoLink { alertControllerActionSheet.addAction(videoAction) }
            if let _ = model.articleLink { alertControllerActionSheet.addAction(articleAction) }
            alertControllerActionSheet.addAction(cancelAction)
            
            if (model.wikipediaLink == nil && model.videoLink == nil && model.articleLink == nil) {
                let alertController = UIAlertController(title: "", message: "Sorry There Are No Links Available", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController.present(alertController, animated: true, completion: nil)
                return
            }
            self.navigationController.present(alertControllerActionSheet, animated: true, completion: nil)
        case .filterLaunchList:
            rootViewController.applyFilters()
        }
    }
}

extension ListingCoordinator: ListingViewControllerCoordinatorDelegate {
    func presentSafariViewController(url: URL) {
        perform(task: .presentSafariViewController(url: url))
    }
    
    func presentLaunchFilterViewController() {
        perform(task: .presentLaunchFilterViewController)
    }
    
    func presentLinkSelectionActionSheet(for model: Launch) {
        perform(task: .presentLinkSelectionActionSheet(model: model))
    }
}

extension ListingCoordinator: FilterViewControllerCoordinatorDelegate {
    func didSave() {
        perform(task: .filterLaunchList)
    }
    
    func didCancel() {
        // Do nothing here.
    }
}
