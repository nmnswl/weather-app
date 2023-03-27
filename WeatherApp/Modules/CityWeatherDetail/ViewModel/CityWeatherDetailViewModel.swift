//
//  CityWeatherDetailViewModel.swift
//  WeatherApp

import Foundation

typealias LoadingClosure = (((() -> Void)?) -> Void)
typealias AlertClosure = ((_ error: Error?) -> ())
typealias ResponseCompletion = ((WeatherInfoResponse) -> Void)

protocol BaseViewModel {
    var showLoadingClosure: LoadingClosure? { get set }
    var hideLoadingClosure: LoadingClosure? { get set }
    var showAlertClosure: AlertClosure? { get set }
}

protocol CityWeatherDetailViewModelType: BaseViewModel {
    var showWeatherInfo: ResponseCompletion? { get set }
    func fetchWeatherInfo()
    func didTapBack()
    func fetchSavedData()
    func getCityName() -> String
    func getUnit() -> Units
}

final class CityWeatherDetailViewModel: CityWeatherDetailViewModelType {
    var showLoadingClosure: LoadingClosure?
    var hideLoadingClosure: LoadingClosure?
    var showAlertClosure: AlertClosure?
    var showWeatherInfo: ResponseCompletion?
    weak var coordinatorDelegate: CityWeatherViewModelToCoordinator?
    
    private var weatherInfoNetworkService: WeatherInfoNetworkServiceProtocol
    private let coreDataManager = CoreDataManager()
    private var cityName = ""
    private var navigationFrom: NavigationFrom = .addCity
    private let units = Units.metric
    
    init(networkService: WeatherInfoNetworkServiceProtocol) {
        self.weatherInfoNetworkService = networkService
    }
    
    func setCityName(as name: String, navigationFrom: NavigationFrom = .addCity) {
        cityName = name
        self.navigationFrom = navigationFrom
    }
    
    func getCityName() -> String {
        cityName
    }
    
    func getUnit() -> Units {
        units
    }
    
    /**
     Method to fetch weather info
     - parameter city: Name of city
     - parameter units: Unit of measurement
     */
    func fetchWeatherInfo() {
        self.showLoadingClosure?(nil)
        weatherInfoNetworkService.fetchWeatherInfo(for: cityName, in: units) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideLoadingClosure?(nil)
                switch result {
                case .success(let weatherInfo):
                    self.coreDataManager.save()
                    self.postNotification(with: weatherInfo)
                    self.showWeatherInfo?(weatherInfo)
                case .failure(let error):
                    self.showAlertClosure?(error)
                }
            }
        }
    }
    
    func fetchSavedData() {
        //Method to fetch saved weather info
        guard let weatherInfo = self.coreDataManager.fetchWeatherDetails(for: cityName) else {
            showAlertClosure?(nil)
            return
        }
        self.showWeatherInfo?(weatherInfo)
    }
    
    func didTapBack() {
        coordinatorDelegate?.didTapBack()
    }
    
    private func postNotification(with weatherInfo: WeatherInfoResponse) {
        NotificationCenter.default.post(name: .weatherInfoFetched, object: weatherInfo)
    }
}
