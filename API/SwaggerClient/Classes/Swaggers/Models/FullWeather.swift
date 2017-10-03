//
// FullWeather.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


open class FullWeather: JSONEncodable {

    public var dt: Int32?
    public var main: FullWeatherMain?
    public var weather: [Weather]?
    public var clouds: FullWeatherClouds?
    public var wind: Any?
    public var dtTxt: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["dt"] = self.dt?.encodeToJSON()
        nillableDictionary["main"] = self.main?.encodeToJSON()
        nillableDictionary["weather"] = self.weather?.encodeToJSON()
        nillableDictionary["clouds"] = self.clouds?.encodeToJSON()
        nillableDictionary["wind"] = self.wind
        nillableDictionary["dt_txt"] = self.dtTxt

        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}