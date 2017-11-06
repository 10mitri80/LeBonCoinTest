//
//  DatabaseHelper.swift
//  LeBonCoinTest
//
//  Created by Dimitri Cadars on 17-11-05.
//  Copyright © 2017 Dimitri Cadars. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseHelper {
    
    struct RealmManager {
        static let realm = try! Realm()
    }
    
    func storeForecasts(forecasts:[Forecast]) {
        try! RealmManager.realm.write {
            RealmManager.realm.add(forecasts)
        }
    }
    
    func getForecasts() -> [Forecast] {
        let forecasts = RealmManager.realm.objects(Forecast.self)
        return Array(forecasts)
    }

    
}
