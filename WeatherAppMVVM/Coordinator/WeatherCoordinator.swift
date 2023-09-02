import Combine
import UIKit

final class WeatherCoordinator {
    private let rootNavigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
    }

    func start() {
        let viewModelWeather = WeatherViewModel()
        let view = WeatherView()
        view.viewModel = viewModelWeather
        rootNavigationController.pushViewController(view, animated: true)

        viewModelWeather.actionSubjectPushMapScreen
            .sink { [weak self] _ in
                self?.showCurrentLocationScreen()
            }
            .store(in: &cancellables)
        
        viewModelWeather.actionSubjectPushSearchCityScreen
            .sink { [weak self] _ in
                self?.showSearchCityScreen()
            }
            .store(in: &cancellables)
    }

    private func showCurrentLocationScreen() {
        let mapView = MapView()
        let mapViewMode = MapViewModel()
        mapView.viewModel = mapViewMode
        rootNavigationController.pushViewController(mapView, animated: true)
    }

    private func showSearchCityScreen() {
        let searchNewCityView = SearchNewCityView()
        let searchNewCityViewModel = SearchNewCityViewModel()
        searchNewCityView.viewModel = searchNewCityViewModel
        rootNavigationController.pushViewController(searchNewCityView, animated: true)
    }
}
