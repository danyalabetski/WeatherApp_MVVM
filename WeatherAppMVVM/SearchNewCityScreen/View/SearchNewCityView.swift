import Combine
import SnapKit
import UIKit

final class SearchNewCityView: UIViewController {

    // MARK: - Properties

    var viewModel: SearchNewCityViewModel!

    private var cancellables = Set<AnyCancellable>()

    // MARK: Private

    private let searchController = UISearchController(searchResultsController: nil)

    private let backgroundImageView = UIImageView()
    private let blurView = UIVisualEffectView()

    private let circleView = UIView()

    private let nameCityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImage = UIImageView()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.changeImageForBackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBehaviorUIElements()
        setupAppearanceUIElements()
        createSearchBar()
        setupConstraints()
    }

    // MARK: - Setups

    private func setupBehaviorUIElements() {
        view.backgroundColor = .systemBackground
                
        viewModel.imagesForView
            .sink { [weak self] image in
                self?.backgroundImageView.image = UIImage(named: image)
            }
            .store(in: &cancellables)
        
        viewModel.temperature.sink { [weak self] text in
            self?.temperatureLabel.text = text
        }
        .store(in: &cancellables)
        
        viewModel.city.sink { [weak self] text in
            self?.nameCityLabel.text = text
        }
        .store(in: &cancellables)
        
        viewModel.descriptionWeather.sink { [weak self] text in
            self?.descriptionLabel.text = text
        }
        .store(in: &cancellables)
        
        viewModel.icon.sink { [weak self] text in
            self?.iconImage.image = UIImage(named: text)
        }
        .store(in: &cancellables)

        view.addSubviews(
            backgroundImageView, blurView, circleView, iconImage, nameCityLabel, temperatureLabel, descriptionLabel
        )

        nameCityLabel.customLabel(nameFont: "DolomanPavljenkoLight", sizeFont: 50)
        temperatureLabel.customLabel(nameFont: "DolomanPavljenkoLight", sizeFont: 100)
        descriptionLabel.customLabel(nameFont: "DolomanPavljenkoLight", sizeFont: 30)

        iconImage.contentMode = .scaleAspectFill
    }

    private func setupAppearanceUIElements() {
        title = "Weather City"
        navigationController?.navigationBar.prefersLargeTitles = true

        circleView.backgroundColor = UIColor(red: 0.153, green: 0.184, blue: 0.204, alpha: 0.225)
        circleView.layer.cornerRadius = 20

        let blurEffect = UIBlurEffect(style: .light)
        blurView.effect = blurEffect
    }

    private func setupConstraints() {
        backgroundImageView.frame = view.bounds
        blurView.frame = view.bounds

        circleView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(320)
        }

        nameCityLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.top).inset(30)
            make.left.equalTo(circleView.snp.left)
            make.right.equalTo(circleView.snp.right)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.left.equalTo(circleView.snp.left).inset(40)
            make.centerY.equalTo(circleView.snp.centerY)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(circleView.snp.bottom).inset(30)
            make.left.equalTo(circleView.snp.left)
            make.right.equalTo(circleView.snp.right)
        }

        iconImage.snp.makeConstraints { make in
            make.right.equalTo(circleView.snp.right).inset(40)
            make.centerY.equalTo(circleView.snp.centerY)
            make.width.height.equalTo(100)
        }
    }

    // MARK: - Helpers
}

// MARK: - SearchBar

extension SearchNewCityView: UISearchBarDelegate {
    private func createSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchButtonClicked(city: searchBar.text ?? "")
        self.viewModel.showErrorMessage
            .sink { [weak self] _ in
                self?.showAlert()
        }
        .store(in: &cancellables)
    }
}

// MARK: - Alert Controller

extension SearchNewCityView {
    private func showAlert() {

        let alert = UIAlertController(
            title: "🙁",
            message: "The place was not found",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in self.searchController.isActive = false }
            )
        )
        
        present(alert, animated: true)
    }
}
