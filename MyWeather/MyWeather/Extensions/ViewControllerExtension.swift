//
//  ViewControllerExtension.swift
//  MyWeather
//
//  Created by Илья Алексейчук on 28.04.2023.
//

import UIKit


extension ViewController {
    
    // Adding alert controller to search for a new city
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, compelitionHandler: @escaping (String) -> Void) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena" ]
            tf.placeholder = cities.randomElement()
            tf.autocapitalizationType = .words
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self] action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                compelitionHandler(city)
            } else {
                self?.presentMistakeAlertController()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(searchAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
        
    }
    
    // Alert controller for mistakes 
    func presentMistakeAlertController() {
        let ac = UIAlertController(title: "Mistake", message: "You need to enter city name", preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .cancel) { [weak self] action in
            self?.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [weak self] city in
                self?.networkWeatherManager.fetchCurrentWeather(forCity: city)
            }
        }
        
        ac.addAction(tryAgainAction)
        
        present(ac, animated: true)
        
    }
    
}



