//
//  ViewController.swift
//  MyWeather
//
//  Created by Илья Алексейчук on 28.04.2023.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {
    
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        
        return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.requestLocation()
            }
        }
        
        
        
        networkWeatherManager.onCompelition = { [weak self] currentWeather in
            self?.updateUI(withWeather: currentWeather)
        }
        
        
    }
    
    
    
    @IBAction func refreshScreen(_ sender: Any) {
        guard let city = cityLabel.text else { return }
        networkWeatherManager.fetchCurrentWeather(forCity: city)
        
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [weak self] city in
            self?.networkWeatherManager.fetchCurrentWeather(forCity: city)
        }
    }
    
    
    func updateUI(withWeather weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.weatherIconNameString)
        }
        
    }
    
    
  
    
}




