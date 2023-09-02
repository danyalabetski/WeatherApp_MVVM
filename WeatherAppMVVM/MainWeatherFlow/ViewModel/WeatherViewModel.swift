import Combine
import Foundation

final class WeatherViewModel {

    var weatherData: MainWeather?
    var weatherService: WeatherService?

    let image = PassthroughSubject<String, Never>()
    let currentTemperature = PassthroughSubject<String, Never>()
    let condition = PassthroughSubject<String, Never>()
    let city = PassthroughSubject<String, Never>()
    let country = PassthroughSubject<String, Never>()
    let imagesForView = PassthroughSubject<String, Never>()
    let actionSubjectPushMapScreen = PassthroughSubject<Void, Never>()
    let actionSubjectPushSearchCityScreen = PassthroughSubject<Void, Never>()

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.weatherService = WeatherService()
    }
    
    func getWeatherDataFromWeatherService() {
        weatherService?.loadWeatherData { [weak self] weather in
            DispatchQueue.main.async {
                self?.weatherData = weather
                self?.image.send(weather?.list[0].weather[0].icon ?? "")
                self?.currentTemperature.send("\(Int(weather?.list[0].main.temp ?? 0))°")
                self?.condition.send(weather?.list[0].weather[0].weatherDescription ?? "")
                self?.city.send(weather?.city.name ?? "")
                self?.country.send(weather?.city.country ?? "")
            }
        }
    }
    
    func changeImageForBackgroundView() {
        let arrayIcons = ["IMG1", "IMG2", "IMG3", "IMG5", "IMG6", "IMG7", "IMG8", "IMG9", "winterImage"]
        imagesForView.send(arrayIcons.randomElement() ?? "")
    }
}
