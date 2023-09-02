import Combine
import Foundation

final class SearchNewCityViewModel {

    private var network: WeatherServiceForSearchCity?
    private var weatherModel: MainSearchWeatherCity?

    private var cancellables = Set<AnyCancellable>()

    let showErrorMessage = PassthroughSubject<Void, Never>()
    var temperature = PassthroughSubject<String, Never>()
    let city = PassthroughSubject<String, Never>()
    let descriptionWeather = PassthroughSubject<String, Never>()
    let icon = PassthroughSubject<String, Never>()
    let imagesForView = PassthroughSubject<String, Never>()

    init() {
        self.network = WeatherServiceForSearchCity()
    }

    func getWeatherForCity() {
        network?.requestForWeatherInCity { [weak self] data in
            DispatchQueue.main.async {
                switch data {
                case .failure(let failure):
                    self?.showErrorMessage.send()
                    print(failure.localizedDescription)
                case .success(let weather):
                    self?.weatherModel = weather
                    self?.temperature.send("\(Int(weather.list[0].main.temp))°")
                    self?.city.send(weather.city.name)
                    self?.descriptionWeather.send(weather.list[0].weather[0].description)
                    self?.icon.send(weather.list[0].weather[0].icon)
                }
            }
        }
    }

    func searchButtonClicked(city: String) {
        self.network?.city = city
        getWeatherForCity()
    }

    func changeImageForBackgroundView() {
        let arrayIcons = ["IMG1", "IMG2", "IMG3", "IMG5", "IMG6", "IMG7", "IMG8", "IMG9", "winterImage"]
        imagesForView.send(arrayIcons.randomElement() ?? "")
    }
}
