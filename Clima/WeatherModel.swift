import Foundation

struct WeatherModel {
    
    // Properties
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    
    // Computed Properties
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        switch conditionId {
        case 0...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
