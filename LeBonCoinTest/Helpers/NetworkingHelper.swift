//
//  NetworkingHelper.swift
//  LeBonCoinTest
//
//  Created by Dimitri Cadars on 17-11-05.
//  Copyright © 2017 Dimitri Cadars. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingHelper {
    
    let baseURL = "http://www.infoclimat.fr/public-api/gfs/json?_ll="
    let key = "BR9VQgZ4BCZXeltsBHJWfwdvAzYOeFN0An5QMwBlUy4IYwdmUjJdO1U7Uy5XeAs9Ai8CYQgzCTkLYAtzWykEZQVvVTkGbQRjVzhbPgQrVn0HKQNiDi5TdAJgUDAAa1MuCGoHZlI5XSFVOFM0V2ILIQIzAmMIMQkuC3cLbVszBGcFb1U5Bm0EYlc5WzEENFZ9BysDZg44Uz0CN1A3AGxTMQhvBzZSMl06VWtTNFdgCyECMQJjCD8JOAtuC21bMgRuBXlVLgYcBBVXJVt5BHZWNwdyA34OZFM1AjU%3D&_c=75af8db9eb1e6e0227787a51f6e9cd57"
    
    func forecastsWithUserLocation(userLatitude: Double, userLongitude: Double, callback: @escaping ([Forecast]?, Error?)->()) {
        Alamofire.request("\(baseURL)\(userLatitude),\(userLongitude)&_auth=\(key)").responseJSON { (response) in
            if response.error == nil {
                let forecastJSON = JSON(response.result.value!)
                var forecastsLoad = [Forecast]()
                for key in forecastJSON {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let date = dateFormatter.date(from: key.0) {
                        let temperature = key.1["temperature"]["2m"].double
                        let pressure = key.1["pression"]["niveau_de_la_mer"].double
                        let humidity = key.1["humidite"]["2m"].double
                        let forecast = Forecast.init(date: date, temperature: temperature!, pressure: pressure!, humidity: humidity!)
                        forecastsLoad.append(forecast)
                    } else {
                        continue
                    }
                }
                forecastsLoad.sort(by: { $0.date.compare($1.date) == .orderedAscending})
                callback(forecastsLoad, response.error)
                
            } else {
                print("Error : \(String(describing: response.error))")
                callback(nil,response.error)
            }
        }
    }
    
    
}
