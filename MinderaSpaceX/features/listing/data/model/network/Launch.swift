//
//  Launch.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import Foundation

struct Launch: Decodable {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    init(missionName: String?, missionImage: String?, launchSuccess: Bool?, rocketName: String?, rocketType: String?, wikipediaLink: String?, videoLink: String?, articleLink: String?, launchYear: Int?, launchDate: Date?) {
        self.missionName = missionName
        self.missionImage = missionImage
        self.launchSuccess = launchSuccess
        self.rocketName = rocketName
        self.rocketType = rocketType
        self.wikipediaLink = wikipediaLink
        self.videoLink = videoLink
        self.articleLink = articleLink
        self.launchYear = launchYear
        self.launchDate = launchDate
    }
    
    private (set) var missionName: String?
    private (set) var missionImage: String?
    private (set) var launchSuccess: Bool?
    private (set) var rocketName: String?
    private (set) var rocketType: String?
    private (set) var wikipediaLink: String?
    private (set) var videoLink: String?
    private (set) var articleLink: String?
    private (set) var launchYear: Int?
    private (set) var launchDate: Date?

    enum CodingKeys: String, CodingKey {
        case missionName = "mission_name"
        case launchSuccess = "launch_success"
        case missionImage = "mission_image"
        case launchYear = "launch_year"
        case rocket
        case links
        case launchDate = "launch_date_unix"
    }
    
    enum RocketKeys: String, CodingKey {
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
    }
    
    enum LinksKeys: String, CodingKey {
        case missionPatch = "mission_patch_small"
        case article = "article_link"
        case video = "video_link"
        case wikipedia
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rocket = try values.nestedContainer(keyedBy: RocketKeys.self,forKey: .rocket)
        let links = try values.nestedContainer(keyedBy: LinksKeys.self,forKey: .links)
        missionName = try? values.decode(String.self, forKey: .missionName)
        launchSuccess = try? values.decode(Bool.self, forKey: .launchSuccess)
        rocketName = try? rocket.decode(String.self, forKey: .rocketName)
        rocketType = try? rocket.decode(String.self, forKey: .rocketType)
        if let launchYearString = try? values.decode(String.self, forKey: .launchYear) {
            launchYear = Int(launchYearString)
        }
        missionImage = try? links.decode(String.self, forKey: .missionPatch)
        wikipediaLink = try? links.decode(String.self, forKey: .wikipedia)
        articleLink = try? links.decode(String.self, forKey: .article)
        videoLink = try? links.decode(String.self, forKey: .video)
        launchDate = try? values.decode(Date.self, forKey: .launchDate)
    }
}

extension Launch: Comparable {
    static func < (lhs: Launch, rhs: Launch) -> Bool {
        guard let lhs = lhs.missionName, let rhs = rhs.missionName else { return false }
        return lhs > rhs
    }
}
