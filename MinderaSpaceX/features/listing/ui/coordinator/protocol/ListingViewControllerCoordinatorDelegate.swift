//
//  ListingViewControllerCoordinatorDelegate.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

protocol ListingViewControllerCoordinatorDelegate: NSObjectProtocol {
    func presentSafariViewController(url: URL)
    func presentLaunchFilterViewController()
    func presentLinkSelectionActionSheet(for model: Launch)
}
