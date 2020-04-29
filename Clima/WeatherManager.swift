import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error)
}

struct WeatherManager {
    
    // Delegate property
    var delegate: WeatherManagerDelegate?
    
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=25d9b72dd42938e49f845a0626e63a29&units=metric"

    func fetchWeather (_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func fetchWeather (_ lat: CLLocationDegrees, _ long: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give URLSession a Task
            let task = session.dataTask(with: url) { (data, response, error) in // Since the last parameter of the methods dataTask is a function
                                                                                // we can use a trailing closure.
                if error != nil {
                    self.delegate?.didFailWithError(self, error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            
            // 4. Start the Task
            task.resume()
        }
    }
    
    // Function which parse from JSON format returning SwiftObject format (WeatherModel)
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temperature = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weather
        } catch {
            delegate?.didFailWithError(self, error)
            return nil
        }
    }
}
