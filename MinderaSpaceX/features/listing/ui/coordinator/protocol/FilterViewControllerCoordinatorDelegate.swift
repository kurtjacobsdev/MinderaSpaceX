//
//  FilterViewControllerCoordinatorDelegate.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

protocol FilterViewControllerCoordinatorDelegate: NSObjectProtocol {
    func didSave()
    func didCancel()
}
