//
//  LaunchViewModel.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit

struct LaunchViewModel {
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY 'at' hh:mm"
        return dateFormatter
    }
    
    private var model: Launch
    private var currentDate: Date
    
    init(model: Launch, currentDate: Date) {
        self.model = model
        self.currentDate = currentDate
    }
    
    var missionName: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "Mission: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        guard let missionName = model.missionName else { return attributedString }
        attributedString.append(NSAttributedString(string: missionName))
        return attributedString
    }
    
    var rocketName: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "Rocket: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        guard let rocketName = model.rocketName, let rocketType = model.rocketType else { return attributedString }
        attributedString.append(NSAttributedString(string: rocketName))
        attributedString.append(NSAttributedString(string: " / "))
        attributedString.append(NSAttributedString(string: rocketType))
        return attributedString
    }
    
    var dateTime: NSAttributedString? {
        guard let date = model.launchDate else {
            return nil
        }
        let formattedDate = LaunchViewModel.dateFormatter.string(from: date)
        
        let attributedString = NSMutableAttributedString(string: "Date/Time: ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        attributedString.append(NSAttributedString(string: formattedDate))
        return attributedString
    }
    
    var days: NSAttributedString? {
        guard let date = model.launchDate,
              let day = Calendar.current.dateComponents([.day], from: self.currentDate, to: date).day else {
            return nil
        }
        
        let prefix = day < 0 ? "Days Since Now: " : "Days From Now: "
        let attributedString = NSMutableAttributedString(string: prefix, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        attributedString.append(NSAttributedString(string: String(abs(day))))
        return attributedString
    }
    
    var missionImage: URL? {
        guard let imageURLString = model.missionImage else { return nil }
        return URL(string: imageURLString)
    }
    
    var hasLaunched: Bool {
        return model.launchSuccess ?? false
    }
}
