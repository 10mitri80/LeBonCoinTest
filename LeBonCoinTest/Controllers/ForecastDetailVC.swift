//
//  ForecastDetailVC.swift
//  LeBonCoinTest
//
//  Created by Dimitri Cadars on 17-11-05.
//  Copyright © 2017 Dimitri Cadars. All rights reserved.
//

import UIKit

class ForecastDetailVC: UIViewController {
    
    var forecast: Forecast!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabels() {
        let forecastDate = forecast.date
        navigationItem.title = forecastDate.toString(dateFormat: "EEEE, MMM d, yyyy HH:mm")
        temperatureLabel.text = String(format: "%.2f °C", forecast.temperature)
        pressureLabel.text = String(format: "%.2f hpa", forecast.pressure)
        humidityLabel.text = String(format: "%.2f %%", forecast.humidity)
    }

}

