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
    func fetchWeatherInfo(for city: String, in units: Units)
    func didTapBack()
}

final class CityWeatherDetailViewModel: CityWeatherDetailViewModelType {
    var showLoadingClosure: LoadingClosure?
    var hideLoadingClosure: LoadingClosure?
    var showAlertClosure: AlertClosure?
    var showWeatherInfo: ResponseCompletion?
    weak var coordinatorDelegate: CityWeatherViewModelToCoordinator?
    
    private var weatherInfoNetworkService: WeatherInfoNetworkServiceProtocol
    
    init(networkService: WeatherInfoNetworkServiceProtocol) {
        self.weatherInfoNetworkService = networkService
    }
    
    /**
     Method to fetch weather info
     - parameter city: Name of city
     - parameter units: Unit of measurement
     */
    func fetchWeatherInfo(for city: String, in units: Units) {
        self.showLoadingClosure?(nil)
        weatherInfoNetworkService.fetchWeatherInfo(for: city, in: units) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideLoadingClosure?(nil)
                switch result {
                case .success(let weatherInfo):
                    self.showWeatherInfo?(weatherInfo)
                case .failure(let error):
                    self.showAlertClosure?(error)
                }
            }
        }
    }
    
    func didTapBack() {
        coordinatorDelegate?.didTapBack()
    }
}
