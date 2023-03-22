//
//  CityWeatherDetailViewModel.swift
//  WeatherApp

import Foundation

protocol BaseViewModel {
    var showLoadingClosure: (((() -> Void)?) -> Void)? { get set }
    var hideLoadingClosure: (((() -> Void)?) -> Void)? { get set }
    var showAlertClosure: ((_ error: Error?) -> ())? { get set }
}

protocol CityWeatherDetailViewModelType: BaseViewModel {
    var showWeatherInfo: ((WeatherInfoResponse) -> Void)? { get set }
    func fetchWeatherInfo(for city: String, in units: Units)
}

final class CityWeatherDetailViewModel: CityWeatherDetailViewModelType {
    var showLoadingClosure: (((() -> Void)?) -> Void)?
    var hideLoadingClosure: (((() -> Void)?) -> Void)?
    var showAlertClosure: ((Error?) -> ())?
    var showWeatherInfo: ((WeatherInfoResponse) -> Void)?
    
    private lazy var weatherInfoNetworkService: WeatherInfoNetworkServiceProtocol = {
        return WeatherInfoNetworkService()
    }()
    
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
}
