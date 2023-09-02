import Foundation

// MARK: - MainSearchWeatherCity
struct MainSearchWeatherCity: Codable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let name: String
    let country: String
}

// MARK: - List
struct List: Codable {
    let main: MainClass
    let weather: [Weather]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}
