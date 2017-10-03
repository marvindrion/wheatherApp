// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject, AnyObject?) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject, AnyObject?) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0, $1) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source, nil) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0, instance: nil) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value, instance: nil)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject, instance: AnyObject?) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return (source as! NSNumber).int32Value as! T
        }
        if T.self is Int64.Type && source is NSNumber {
            return (source as! NSNumber).int64Value as! T
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source, instance) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source, instance: nil)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject, instance: AnyObject?) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [FullWeather]
        Decoders.addDecoder(clazz: [FullWeather].self) { (source: AnyObject, instance: AnyObject?) -> [FullWeather] in
            return Decoders.decode(clazz: [FullWeather].self, source: source)
        }
        // Decoder for FullWeather
        Decoders.addDecoder(clazz: FullWeather.self) { (source: AnyObject, instance: AnyObject?) -> FullWeather in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? FullWeather() : instance as! FullWeather
            
            result.dt = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["dt"] as AnyObject?)
            result.main = Decoders.decodeOptional(clazz: FullWeatherMain.self, source: sourceDictionary["main"] as AnyObject?)
            result.weather = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["weather"] as AnyObject?)
            result.clouds = Decoders.decodeOptional(clazz: FullWeatherClouds.self, source: sourceDictionary["clouds"] as AnyObject?)
            result.wind = Decoders.decodeOptional(clazz: Any.self, source: sourceDictionary["wind"] as AnyObject?)
            result.dtTxt = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["dt_txt"] as AnyObject?)
            return result
        }


        // Decoder for [FullWeatherClouds]
        Decoders.addDecoder(clazz: [FullWeatherClouds].self) { (source: AnyObject, instance: AnyObject?) -> [FullWeatherClouds] in
            return Decoders.decode(clazz: [FullWeatherClouds].self, source: source)
        }
        // Decoder for FullWeatherClouds
        Decoders.addDecoder(clazz: FullWeatherClouds.self) { (source: AnyObject, instance: AnyObject?) -> FullWeatherClouds in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? FullWeatherClouds() : instance as! FullWeatherClouds
            
            result.all = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["all"] as AnyObject?)
            return result
        }


        // Decoder for [FullWeatherMain]
        Decoders.addDecoder(clazz: [FullWeatherMain].self) { (source: AnyObject, instance: AnyObject?) -> [FullWeatherMain] in
            return Decoders.decode(clazz: [FullWeatherMain].self, source: source)
        }
        // Decoder for FullWeatherMain
        Decoders.addDecoder(clazz: FullWeatherMain.self) { (source: AnyObject, instance: AnyObject?) -> FullWeatherMain in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? FullWeatherMain() : instance as! FullWeatherMain
            
            result.humidity = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["humidity"] as AnyObject?)
            return result
        }


        // Decoder for [Weather]
        Decoders.addDecoder(clazz: [Weather].self) { (source: AnyObject, instance: AnyObject?) -> [Weather] in
            return Decoders.decode(clazz: [Weather].self, source: source)
        }
        // Decoder for Weather
        Decoders.addDecoder(clazz: Weather.self) { (source: AnyObject, instance: AnyObject?) -> Weather in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Weather() : instance as! Weather
            
            result.id = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["id"] as AnyObject?)
            result.main = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["main"] as AnyObject?)
            result.description = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?)
            result.icon = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["icon"] as AnyObject?)
            return result
        }


        // Decoder for [WeatherResponse]
        Decoders.addDecoder(clazz: [WeatherResponse].self) { (source: AnyObject, instance: AnyObject?) -> [WeatherResponse] in
            return Decoders.decode(clazz: [WeatherResponse].self, source: source)
        }
        // Decoder for WeatherResponse
        Decoders.addDecoder(clazz: WeatherResponse.self) { (source: AnyObject, instance: AnyObject?) -> WeatherResponse in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? WeatherResponse() : instance as! WeatherResponse
            
            result.cod = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["cod"] as AnyObject?)
            result.cnt = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["cnt"] as AnyObject?)
            result.list = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["list"] as AnyObject?)
            return result
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}