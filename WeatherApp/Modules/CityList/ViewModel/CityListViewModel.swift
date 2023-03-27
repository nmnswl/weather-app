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
    func updateWeatherInfo(with info: WeatherInfoResponse)
    func addCity()
    func fetchAllCities()
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
        var cityCellModel = CityCellModel(cityName: weatherInfo.name ?? "",
                                          temperature: weatherInfo.main?.temp ?? 0.0,
                                          icon: weatherInfo.weather?.first?.icon ?? "")
        cityCellModel.didSelectCell = {
            self.displayWeatherDetails(for: weatherInfo.name)
        }
        return cityCellModel
    }
    
    func updateWeatherInfo(with info: WeatherInfoResponse) {
        if let selectedIndex = selectedIndex {
            let weatherInfo = self.cityArray[selectedIndex]
            coreDataManager.deleteCity(with: weatherInfo)
            cityCellModels.remove(at: selectedIndex)
        }
        if let cityCellModel = createCellModel(for: info) {
            cityCellModels.insert(cityCellModel, at: 0)
            reloadTable?()
        }
    }
    
    func addCity() {
        coordinatorDelegate?.addCity()
    }
    
    private func displayWeatherDetails(for city: String?) {
        guard let cityName = city else { return }
        coordinatorDelegate?.showWeatherDetails(for: cityName)
    }
    
    func fetchAllCities() {
        let cityArray = coreDataManager.fetchAll() ?? []
        if !cityArray.isEmpty {
            self.cityArray = cityArray.reversed()
            self.cityArray.forEach { weatherInfo in
                if let cityCellModel = createCellModel(for: weatherInfo) {
                    cityCellModels.append(cityCellModel)
                }
            }
            reloadTable?()
        }
    }
}
