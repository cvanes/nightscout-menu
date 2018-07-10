//
//  NightscoutApiClient.swift
//  NightscoutMenuTests
//
//  Created by Chris van Es on 10/07/2018.
//  Copyright © 2018 Chris van Es. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class NightscoutApiClient {
    
    static let shared = NightscoutApiClient()
    
    private let provider: MoyaProvider<NightscoutApi>
    private let userConfiguration: UserConfiguration
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    init(provider: MoyaProvider<NightscoutApi> = MoyaProvider<NightscoutApi>(), userConfiguration: UserConfiguration = .shared) {
        self.provider = provider
        self.userConfiguration = userConfiguration
    }
    
    func fetchSettings() -> Single<Settings> {
        return provider.rx
            .request(.settings)
            .filterSuccessfulStatusCodes()
            .map(Settings.self, atKeyPath: "settings")
            .map(convertThresholdsToPreferredUnit)
    }
    
    private func convertThresholdsToPreferredUnit(_ settings: Settings) -> Settings {
        let unit = settings.preferredUnit
        let thresholds = GlucoseAlarmThresholds(
            urgentHigh: convertToPreferredUnit(unit, settings.thresholds.urgentHigh),
            high: convertToPreferredUnit(unit, settings.thresholds.high),
            low: convertToPreferredUnit(unit, settings.thresholds.low),
            urgentLow: convertToPreferredUnit(unit, settings.thresholds.urgentLow)
        )
        return Settings(preferredUnit: unit, thresholds: thresholds)
    }
    
    func fetchEntries(count: Int = 13) -> Single<[GlucoseEntry]> {
        return provider.rx
            .request(.entries(count: count))
            .filterSuccessfulStatusCodes()
            .map([GlucoseEntry].self, using: decoder, failsOnEmptyData: false)
            .map(convertEntriesToPreferredUnit)
    }
    
    private func convertEntriesToPreferredUnit(_ entries: [GlucoseEntry]) -> [GlucoseEntry] {
        return entries.map { entry -> GlucoseEntry in
            return GlucoseEntry(
                timestamp: entry.timestamp,
                type: entry.type,
                value: convertToPreferredUnit(userConfiguration.preferredUnit, entry.value),
                unit: userConfiguration.preferredUnit,
                direction: entry.direction
            )
        }
    }
    
    private func convertToPreferredUnit(_ preferredUnit: GlucoseEntryUnit, _ value: Double) -> Double {
        return preferredUnit == .mmol ? value / 18 : value
    }
    
}

enum GlucoseEntryType : String, Decodable {
    case sgv = "sgv"
    case mbg = "mbg"
    case cal = "cal"
}

enum GlucoseEntryDirection : String, Decodable {
    case unknown = "NOT COMPUTABLE"
    case flat = "Flat"
    case risingFast = "SingleUp"
    case risingSlowly = "FortyFiveUp"
    case droppingFast = "SingleDown"
    case droppingSlowly = "FortyFiveDown"
    
    var symbol: String {
        switch self {
        case .flat: return "→"
        case .risingFast: return "↑"
        case .risingSlowly: return "↗"
        case .droppingFast: return "↓"
        case .droppingSlowly: return "↘"
        default: return "??"
        }
    }
}

enum GlucoseEntryUnit : String, Decodable {
    case mmol = "mmol"
    case mgdl = "mg/dl"
}

struct GlucoseEntry : Decodable {
    let timestamp: Date
    let type: GlucoseEntryType
    let value: Double
    let unit: GlucoseEntryUnit
    let direction: GlucoseEntryDirection
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dateString"
        case type = "type"
        case value = "sgv"
        case direction = "direction"
    }
    
    init(timestamp: Date,
         type: GlucoseEntryType,
         value: Double,
         unit: GlucoseEntryUnit,
         direction: GlucoseEntryDirection) {
        
        self.timestamp = timestamp
        self.type = type
        self.value = value
        self.unit = unit
        self.direction = direction
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        type = try container.decode(GlucoseEntryType.self, forKey: .type)
        value = try container.decodeIfPresent(Double.self, forKey: .value) ?? 0
        direction = (try? container.decode(GlucoseEntryDirection.self, forKey: .direction)) ?? .unknown
        unit = .mgdl
    }
}

struct Settings : Decodable {
    let preferredUnit: GlucoseEntryUnit
    let thresholds: GlucoseAlarmThresholds
    
    enum CodingKeys: String, CodingKey {
        case preferredUnit = "units"
        case thresholds = "thresholds"
    }
}

struct GlucoseAlarmThresholds : Decodable {
    let urgentHigh: Double
    let high: Double
    let low: Double
    let urgentLow: Double
    
    enum CodingKeys: String, CodingKey {
        case urgentHigh = "bgHigh"
        case high = "bgTargetTop"
        case low = "bgTargetBottom"
        case urgentLow = "bgLow"
    }
}
