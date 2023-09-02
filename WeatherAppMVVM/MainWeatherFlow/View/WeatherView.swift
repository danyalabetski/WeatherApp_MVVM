import Combine
import SnapKit
import UIKit

final class WeatherView: UIViewController {

    // MARK: - Properties

    var viewModel: WeatherViewModel!

    private var cancellables = Set<AnyCancellable>()

    // MARK: Public
    // MARK: Private

    private let backgroundImageView = UIImageView()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let backroundView = UIView()

    private let currentTime = UILabel()
    private let temperatureImageView = UIImageView()
    private let currentTemperatureLabel = UILabel()
    private let weatherConditionLabel = UILabel()
    private let cityLabel = UILabel()
    private let seperatorView = UIView()
    private let countyLabel = UILabel()

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.changeImageForBackgroundView()
        viewModel.getWeatherDataFromWeatherService()
        
        viewModel.city.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBehaviorUIElements()
        setupAppearanceUIElements()
        setupConstraints()
    }

    // MARK: - Setups

    private func setupView() {
        view.backgroundColor = .systemBackground
        viewModel.imagesForView
            .sink { [weak self] image in
                self?.backgroundImageView.image = UIImage(named: image)
            }
            .store(in: &cancellables)

        view.addSubviews(
            backgroundImageView, collectionView, backroundView, currentTime, temperatureImageView, currentTemperatureLabel, weatherConditionLabel, cityLabel, seperatorView, countyLabel
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(addNewCityDidTappedButton)
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "location.fill.viewfinder"),
            style: .done, target: self,
            action: #selector(myLocationDidTappedButton)
        )
    }

    private func setupBehaviorUIElements() {
        collectionView.delegate = self
        collectionView.dataSource = self

        backroundView.clipsToBounds = false

        collectionView.backgroundColor = UIColor(red: 0.153, green: 0.184, blue: 0.204, alpha: 0.225)
        collectionView.layer.cornerRadius = 25

        backroundView.backgroundColor = UIColor(red: 0.153, green: 0.184, blue: 0.204, alpha: 0.225)
        backroundView.layer.cornerRadius = 35

        currentTime.text = "Today"
        currentTime.customLabel(nameFont: "Poppins-Medium", sizeFont: 25)

        temperatureImageView.contentMode = .scaleAspectFill

        currentTemperatureLabel.customLabel(nameFont: "Poppins-SemiBold", sizeFont: 100)
        weatherConditionLabel.customLabel(nameFont: "Poppins-SemiBold", sizeFont: 20)
        cityLabel.customLabel(nameFont: "Poppins-Medium", sizeFont: 15)
        countyLabel.customLabel(nameFont: "Poppins-Medium", sizeFont: 15)

        seperatorView.backgroundColor = .black

        viewModel.image
            .sink { [weak self] image in
                self?.temperatureImageView.image = UIImage(named: image)
            }
            .store(in: &cancellables)

        viewModel.currentTemperature
            .sink { [weak self] temp in
                self?.currentTemperatureLabel.text = temp
            }
            .store(in: &cancellables)

        viewModel.condition
            .sink { [weak self] text in
                self?.weatherConditionLabel.text = text
            }
            .store(in: &cancellables)

        viewModel.city
            .sink { [weak self] city in
                self?.cityLabel.text = city
            }
            .store(in: &cancellables)

        viewModel.country
            .sink { [weak self] country in
                self?.countyLabel.text = country
            }
            .store(in: &cancellables)
    }

    private func setupAppearanceUIElements() {
        currentTemperatureLabel.font = .boldSystemFont(ofSize: 50)
    }

    private func setupConstraints() {
        backgroundImageView.frame = view.bounds

        backroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.left.right.equalToSuperview().inset(34)
            make.height.equalTo(240)
        }

        currentTime.snp.makeConstraints { make in
            make.top.equalTo(backroundView.snp.top).inset(20)
            make.left.equalTo(backroundView.snp.left).inset(100)
            make.right.equalTo(backroundView.snp.right).inset(100)
        }

        temperatureImageView.snp.makeConstraints { make in
            make.top.equalTo(backroundView.snp.top).inset(86)
            make.left.equalTo(backroundView.snp.left).inset(30)
            make.height.width.equalTo(72)
        }

        currentTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(backroundView.snp.top).inset(48)
            make.right.equalTo(backroundView.snp.right).inset(40)
        }

        weatherConditionLabel.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).inset(15)
            make.left.equalTo(backroundView.snp.left).inset(50)
            make.right.equalTo(backroundView.snp.right).inset(50)
        }

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherConditionLabel.snp.bottom).inset(-10)
            make.left.equalTo(backroundView.snp.left).inset(105)
        }

        seperatorView.snp.makeConstraints { make in
            make.top.equalTo(weatherConditionLabel.snp.bottom).inset(-10)
            make.left.equalTo(cityLabel.snp.right).inset(-15)
            make.width.equalTo(1)
            make.height.equalTo(20)
        }

        countyLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherConditionLabel.snp.bottom).inset(-10)
            make.left.equalTo(cityLabel.snp.right).inset(-30)
        }

        collectionView.snp.makeConstraints { make in
            make.height.equalTo(170)
            make.bottom.equalTo(backroundView.snp.top).inset(425)
            make.left.right.equalToSuperview().inset(34)
        }
    }

    // MARK: - Helpers

    @objc private func addNewCityDidTappedButton() {
        viewModel.actionSubjectPushSearchCityScreen.send()
    }

    @objc private func myLocationDidTappedButton() {
        viewModel.actionSubjectPushMapScreen.send()
    }
}

extension WeatherView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 4.5, height: collectionView.frame.width / 2.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.weatherData?.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        let data = viewModel.weatherData?.list[indexPath.row]

        let weather = viewModel.weatherData?.list[0]
        let icons = weather?.weather[0]

        cell.timeLabel.text = data?.dtTxt.hhDate()
        cell.temperatureImageView.image = UIImage(named: icons?.icon ?? "")
        cell.temperatureLabel.text = "\(Int(data?.main.temp ?? 0))°"

        
        return cell
    }
}
