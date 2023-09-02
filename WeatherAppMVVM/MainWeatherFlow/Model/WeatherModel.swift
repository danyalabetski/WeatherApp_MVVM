import Foundation

// MARK: - MainWeather
struct MainWeather: Codable {
    let list: [APIList]
    let city: APICity
}

// MARK: - APICity
struct APICity: Codable {
    let name: String
    let country: String
}

// MARK: - APIList
struct APIList: Codable {
    let main: APIMain
    let weather: [APIWeather]
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - APIMain
struct APIMain: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - APIWeather
struct APIWeather: Codable {
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
}
