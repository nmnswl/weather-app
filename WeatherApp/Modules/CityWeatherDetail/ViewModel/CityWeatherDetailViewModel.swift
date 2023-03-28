//
//  CityWeatherDetailViewModel.swift
//  WeatherApp

import Foundation

typealias LoadingClosure = (((() -> Void)?) -> Void)
typealias AlertClosure = ((_ message: String?, _ error: Error?) -> ())
typealias ResponseCompletion = ((WeatherInfo) -> Void)

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
        if !NetworkMonitor.shared.isConnected {
            showAlertClosure?(Constants.Alert.internetError, nil)
            return
        }
        self.showLoadingClosure?(nil)
        weatherInfoNetworkService.fetchWeatherInfo(for: cityName, in: units) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.hideLoadingClosure?(nil)
                switch result {
                case .success(let weatherInfo):
                    self.save(weatherInfo: weatherInfo)
                    self.showWeatherInfo?(weatherInfo)
                case .failure(let error):
                    self.showAlertClosure?(nil, error)
                }
            }
        }
    }
    
    func fetchSavedData() {
        //Method to fetch saved weather info
        guard let weatherManagedObject = coreDataManager.fetchWeatherDetails(for: cityName),
              let weatherInfo = weatherManagedObject.convertToModel() else {
            return
        }
        self.showWeatherInfo?(weatherInfo)
    }
    
    func didTapBack() {
        coordinatorDelegate?.didTapBack()
    }
    
    private func postNewEntryNotification(with weatherInfo: WeatherInfoResponse) {
        NotificationCenter.default.post(name: .weatherToAdd, object: weatherInfo)
    }
    
    func saveInCoreData(weatherInfo: WeatherInfo) {
        //Save response to core data and update city list
        guard let weatherInfoManagedObject = weatherInfo.convertToManagedObject(in: coreDataManager.managedObjectContext) else { return }
        coreDataManager.save()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.postNewEntryNotification(with: weatherInfoManagedObject)
        }
    }
    
    private func save(weatherInfo: WeatherInfo) {
        switch navigationFrom {
        case .addCity:
            saveInCoreData(weatherInfo: weatherInfo)
        default: break
        }
    }
}
