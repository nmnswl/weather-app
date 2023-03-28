//
//  CityListViewModel.swift
//  WeatherApp

import Foundation

typealias ReloadClosure = (() -> Void)
typealias WeatherDetailsPresentation = ((CityCellModel) -> Void)

protocol CityListViewModelType {
    var reloadTable: ReloadClosure? { get set }
    func numberOfCities() -> Int
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellModel
    func updateWeatherInfo(with info: WeatherInfo)
    func addToList(with weatherInfo: WeatherInfoResponse)
    func addCity()
    func fetchAllCities()
    func updateSelectedIndex(with index: Int)
    func displayWeatherDetails(for city: String?)
}

final class CityListViewModel: CityListViewModelType {
    var reloadTable: ReloadClosure?
    weak var coordinatorDelegate: CityListViewModelToCoordinator?
    private var cityCellModels = [CityCellModel]()
    private let coreDataManager = CoreDataManager()
    private var cityArray: [WeatherInfoResponse] = []
    private var selectedIndex: Int?
    
    func numberOfCities() -> Int {
        cityCellModels.count
    }
    
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellModel {
        cityCellModels[indexPath.row]
    }
    
    private func createCellModel(for weatherInfo: WeatherInfoResponse) -> CityCellModel? {
        let cityCellModel = CityCellModel(cityName: weatherInfo.name ?? "",
                                          temperature: weatherInfo.main?.temp ?? 0.0,
                                          icon: weatherInfo.weather?.first?.icon ?? "")
        return cityCellModel
    }
    
    func updateWeatherInfo(with info: WeatherInfo) {
        if let selectedIndex = selectedIndex {
            let weatherInfo = self.cityArray[selectedIndex]
            weatherInfo.updateDetails(with: info)
            coreDataManager.save()
            if let cityCellModel = createCellModel(for: weatherInfo) {
                cityCellModels.remove(at: selectedIndex)
                cityCellModels.insert(cityCellModel, at: selectedIndex)
                reloadTable?()
            }
        }
        self.selectedIndex = nil
    }
    
    func addToList(with weatherInfo: WeatherInfoResponse) {
        if let cityCellModel = createCellModel(for: weatherInfo) {
            cityCellModels.append(cityCellModel)
            reloadTable?()
        }
    }
    
    func addCity() {
        coordinatorDelegate?.addCity()
    }
    
    func displayWeatherDetails(for city: String?) {
        guard let cityName = city else { return }
        coordinatorDelegate?.showWeatherDetails(for: cityName)
    }
    
    func fetchAllCities() {
        cityArray = coreDataManager.fetchAll() ?? []
        if !cityArray.isEmpty {
            cityArray.forEach { weatherInfo in
                if let cityCellModel = createCellModel(for: weatherInfo) {
                    cityCellModels.append(cityCellModel)
                }
            }
            reloadTable?()
        }
    }
    
    func updateSelectedIndex(with index: Int) {
        selectedIndex = index
    }
}
