//
//  PropertiesManager.swift
//  WeatherApp
//
//  Created by Marvin DRION on 04/10/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import Foundation
import AVFoundation

class PropertiesManager {

    static let sharedInstance = PropertiesManager()

    var properties: NSDictionary?

    private init() {}

    func setProperties(source: NSDictionary) {
        self.properties = source
    }

    func getApiUrl() -> String? {
        guard let apiUrl = properties?["API_URL"] as? String else {
            return ""
        }
        return apiUrl
    }

    func getApiKey() -> String? {
        guard let apiKey = properties?["API_KEY"] as? String else {
            return ""
        }
        return apiKey
    }

    func getTemperatureUnit() -> String? {
        guard let apiKey = properties?["TEMPERATURE_UNIT"] as? String else {
            return ""
        }
        return apiKey
    }

}
