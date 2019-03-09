//
//  RepositoryModel.swift
//  getAllRepos
//
//  Created by Mihai Dumitru on 07/03/2019.
//  Copyright © 2019 Mihai Dumitru. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let htmlUrl: String
    let fullName: String
    let language: String
    let stargazersCount: Int
    let forksCount: Int
    let watchersCount: Int
    let repoName: String
    let descriptionText: String
    let owner: Owner
    
    enum RepositoryCodingKeys: String, CodingKey {
        
        case htmlUrl = "html_url"
        case fullName = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case watchersCount = "watchers_count"
        case repoName = "name"
        case descriptionText = "description"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: RepositoryCodingKeys.self)
        htmlUrl = try container.decodeIfPresent(String.self, forKey: .htmlUrl) ?? ""
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        stargazersCount = try container.decodeIfPresent(Int.self, forKey: .stargazersCount) ?? -1
        forksCount = try container.decodeIfPresent(Int.self, forKey: .forksCount) ?? -1
        watchersCount = try container.decodeIfPresent(Int.self, forKey: .watchersCount) ?? -1
        repoName = try container.decodeIfPresent(String.self, forKey: .repoName) ?? ""
        descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText) ?? ""
        owner = try container.decodeIfPresent(Owner.self, forKey: .owner) ?? Owner()
    }
}

struct Owner: Decodable { 
    
    let login: String
    let avatarURL: String
    
    enum OwnerCodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OwnerCodingKeys.self)
        login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
    }
    
    init() {
        login = ""
        avatarURL = ""
    }
}

struct ReadMe: Decodable {
    
    let htmlUrl: String
    let name: String
    
    enum ReadMeCodingKeys: String, CodingKey {
        case htmlUrl = "html_url"
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReadMeCodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        htmlUrl = try container.decodeIfPresent(String.self, forKey: .htmlUrl) ?? ""
    }
}

