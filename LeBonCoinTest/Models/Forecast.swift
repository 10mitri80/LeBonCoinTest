//
//  Forecast.swift
//  LeBonCoinTest
//
//  Created by Dimitri Cadars on 17-11-05.
//  Copyright © 2017 Dimitri Cadars. All rights reserved.
//

import Foundation
import RealmSwift

class Forecast: Object {
    
    @objc dynamic var id:String = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var temperature = 0.0
    @objc dynamic var pressure = 0.0
    @objc dynamic var humidity = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(date: Date, temperature: Double, pressure: Double, humidity: Double) {
        
        self.init()
        
        self.date = date
        self.temperature = temperature - 273.15 // kelvin to celsius
        self.pressure = pressure
        self.humidity = humidity
    }

    
    
}

