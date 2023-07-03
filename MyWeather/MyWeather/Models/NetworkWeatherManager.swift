//
//  NetworkWeatherManager.swift
//  MyWeather
//
//  Created by Илья Алексейчук on 02.05.2023.
//

import Foundation
import CoreLocation


class NetworkWeatherManager {
    
    
    var onCompelition: ((CurrentWeather) -> Void)?
    
    let apiKey = "f91d402c6a041eb8d519cc33d0cf96d4"
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        performRequest(withURLString: urlString)
    }
    
    func fetchCurrentWeather(forLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        performRequest(withURLString: urlString)
    }
    
    private func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                if let currentWeather = self?.parseJSON(withData: data) {
                    self?.onCompelition?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    
    private func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            
            if let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) {
                return currentWeather
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    

    
}


