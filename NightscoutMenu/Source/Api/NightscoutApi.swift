//
//  NightscoutApi.swift
//  NightscoutMacMenuBar
//
//  Created by Chris van Es on 03/06/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import Moya

enum NightscoutApi {
    case latestEntry
    case entries(count: Int)
    case settings
}

extension NightscoutApi : TargetType {
    var baseURL: URL {
        return URL(string: UserConfiguration().nightscoutUrl ?? "http://localhost")!
    }
    
    var path: String {
        switch self {
        case .latestEntry: return "/api/v1/entries/current"
        case .entries: return "/api/v1/entries"
        case .settings: return "/api/v1/status"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .entries(let count): return .requestParameters(parameters: ["count": count], encoding: URLEncoding.queryString)
        default: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
