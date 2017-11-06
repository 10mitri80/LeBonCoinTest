//
//  ForecastListVC.swift
//  LeBonCoinTest
//
//  Created by Dimitri Cadars on 17-11-05.
//  Copyright © 2017 Dimitri Cadars. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class ForecastListVC: UITableViewController, CLLocationManagerDelegate {
    
    let networkingHelper = NetworkingHelper()
    var locationManager: CLLocationManager!
    let databaseHelper = DatabaseHelper()
    var forecasts = [Forecast]()
    var forecastToPass: Forecast!

    override func viewDidLoad() {
        super.viewDidLoad()
        determineMyCurrentLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath)
        let forecastDate = forecasts[indexPath.row].date
        cell.textLabel?.text = forecastDate.toString(dateFormat: "EEEE, MMM d, yyyy HH:mm")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forecastToPass = forecasts[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func loadForecastsWithUserLocation(userLatitude: Double, userLongitude: Double) {
        
        networkingHelper.forecastsWithUserLocation(userLatitude: userLatitude,userLongitude: userLongitude) { (forecasts,error) in
            if (error) != nil {
                // Show Error message if no internet connection and load Forecasts from database
                let alert = UIAlertController(title: "Error", message: "Internet connection appears to be offline. Would you like to retrieve the last stored values?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    self.loadForecastsFromDatabase()
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                // Save all forecasts in Database
                self.databaseHelper.storeForecasts(forecasts: forecasts!)
                self.loadForecastsFromDatabase()
            }
            
        }
    }
    
    func loadForecastsFromDatabase() {
        forecasts = databaseHelper.getForecasts()
        self.tableView.reloadData()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        loadForecastsWithUserLocation(userLatitude: userLocation.coordinate.latitude,
                                      userLongitude: userLocation.coordinate.longitude)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showDetail") {
            let forecastDetailVC = segue.destination as! ForecastDetailVC
            forecastDetailVC.forecast = forecastToPass
        }
    }


}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
