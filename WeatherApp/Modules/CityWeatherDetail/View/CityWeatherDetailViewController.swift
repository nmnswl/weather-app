//
//  CityWeatherDetailViewController.swift
//  WeatherApp

import UIKit
import WeatherInformation

class CityWeatherDetailViewController: UIViewController {
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var visibilityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var maxTempView: UIView!
    @IBOutlet private weak var minTempView: UIView!
    @IBOutlet private weak var humidityView: UIView!
    @IBOutlet private weak var pressureView: UIView!
    @IBOutlet private weak var windSpeedView: UIView!
    @IBOutlet private weak var visibilityView: UIView!
    
    private var viewModel: CityWeatherDetailViewModelType!
    private var weatherInfo: WeatherInfo?

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        initialViewSetup()
        loadWeatherDetails()
    }
    
    //MARK: - View model setup -
    func bindViewModel(_ viewModel: CityWeatherDetailViewModelType) {
        self.viewModel = viewModel
    }
    
    private func setupViewModel() {
        viewModel.showLoadingClosure = { [weak self] completion in
            guard let self = self else { return }
            self.view.showIndicator()
        }
        
        viewModel.hideLoadingClosure = { [weak self] completion in
            guard let self = self else { return }
            self.view.hideIndicator()
        }
        
        viewModel.showAlertClosure = { [weak self] (message, error) in
            guard let self = self else { return }
            if let apiError = error as? APIError {
                switch apiError {
                case .serverError:
                    self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                         message: Constants.Alert.serverError,
                                                                         buttons: .ok(nil))
                case .decodingError:
                    self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                         message: Constants.Alert.decodingError,
                                                                         buttons: .ok(nil))
                case .noData:
                    self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                         message: Constants.Alert.noDataError,
                                                                         buttons: .ok(nil))
                case .requestError(let error):
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        //Showing alert when device is not connected to the internet
                        self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                             message: Constants.Alert.internetError,
                                                                             buttons: .ok(nil))
                        self.viewModel.fetchSavedData()
                    } else {
                        self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                             message: error.localizedDescription,
                                                                             buttons: .ok(nil))
                    }
                default: break
                }
            } else if let alertMessage = message {
                self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                     message: alertMessage,
                                                                     buttons: .ok(nil))
                self.viewModel.fetchSavedData()
            } else {
                self.showAlertControllerWith(title: Constants.Alert.errorAlertTitle,
                                                                     message: Constants.Alert.generalError,
                                                                     buttons: .ok(nil))
            }
        }
        
        viewModel.showWeatherInfo = { [weak self] (weatherInfo) in
            guard let self = self else { return }
            self.weatherInfo = weatherInfo
            self.setupUI()
        }
    }
    
    //MARK: - API calling
    private func loadWeatherDetails() {
        viewModel.fetchWeatherInfo()
    }
    
    //MARK: - View setup -
    private func initialViewSetup() {
        //Initial setup
        cityNameLabel.text = viewModel.getCityName()
        weatherImageView.roundCornersWithRadius(10)
    }
    
    private func setupUI() {
        //Set up UI with API response
        guard let weatherInfo = self.weatherInfo else { return }
        let temperatureUnit = viewModel.getUnit().temperatureUnit
        let windSpeedUnit = viewModel.getUnit().windSpeedUnit
        if let main = weatherInfo.main {
            if let temp = main.temp {
                temperatureLabel.text = "\(temp)\(temperatureUnit)"
            } else {
                //Default text when API does not return a temperature in the response
                temperatureLabel.text = "--"
            }
            minTempLabel.text = "\(main.temp_min ?? 0.0)\(temperatureUnit)"
            maxTempLabel.text = "\(main.temp_max ?? 0.0)\(temperatureUnit)"
            humidityLabel.text = "\(main.humidity ?? 0.0)%"
            pressureLabel.text = "\(main.pressure ?? 0.0) hPa"
            handleVisibilityOf(view: minTempView, when: main.temp_min)
            handleVisibilityOf(view: maxTempView, when: main.temp_min)
            handleVisibilityOf(view: humidityView, when: main.temp_min)
            handleVisibilityOf(view: pressureView, when: main.temp_min)
        }
        if let weather = weatherInfo.weather?.first {
            weatherImageView.image = UIImage(named: weather.icon ?? "")
            if let mainDescription = weather.main, !mainDescription.isEmpty {
                weatherDescriptionLabel.text = weather.main
            } else if let detailDescription = weather.description, !detailDescription.isEmpty {
                weatherDescriptionLabel.text = weather.description
            }
        }
        if let visibility = weatherInfo.visibility {
            visibilityLabel.text = "\(visibility) metres"
        } else {
            visibilityView.isHidden = true
        }
        if let wind = weatherInfo.wind, let speed = wind.speed {
            windSpeedLabel.text = "\(speed) \(windSpeedUnit)"
        } else {
            windSpeedView.isHidden = true
        }
    }
    
    private func handleVisibilityOf(view: UIView, when value: Double?) {
        //Hide the view when the API does not provide some weather info in response
        view.isHidden = value == nil
    }
    
    //MARK: - Button action -
    @IBAction private func actionBack(_ sender: UIButton) {
        viewModel.didTapBack()
    }
}
