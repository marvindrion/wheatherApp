//
// WeatherAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class WeatherAPI: APIBase {
    /**
     Retrieve weateher data for 5 days for selected city
     
     - parameter id: (query) City identifier 
     - parameter appid: (query) API Key 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getWeather(id: String, appid: String, completion: @escaping ((_ data: WeatherResponse?,_ error: Error?) -> Void)) {
        getWeatherWithRequestBuilder(id: id, appid: appid).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Retrieve weateher data for 5 days for selected city
     - GET /forecast
     - Retrieve weateher data for 5 days for selected city
     - examples: [{contentType=application/json, example={
  "cnt" : 0,
  "cod" : "aeiou",
  "list" : [ {
    "dt" : 6,
    "dt_txt" : "aeiou",
    "weather" : [ {
      "icon" : "aeiou",
      "description" : "aeiou",
      "main" : "aeiou",
      "id" : 5
    } ],
    "main" : {
      "humidity" : 1
    },
    "clouds" : {
      "all" : 5
    },
    "wind" : "{}"
  } ]
}}]
     
     - parameter id: (query) City identifier 
     - parameter appid: (query) API Key 

     - returns: RequestBuilder<WeatherResponse> 
     */
    open class func getWeatherWithRequestBuilder(id: String, appid: String) -> RequestBuilder<WeatherResponse> {
        let path = "/forecast"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems(values:[
            "id": id, 
            "appid": appid
        ])
        

        let requestBuilder: RequestBuilder<WeatherResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}