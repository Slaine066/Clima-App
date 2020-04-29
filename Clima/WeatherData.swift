import Foundation

struct WeatherData: Codable { // The Codable Typealias contains Decodable and Encodable Protocol (which let us decode and encode JSON data).
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
