//
//  CityListViewModel.swift
//  WeatherApp

import Foundation

typealias ReloadClosure = (() -> Void)
typealias WeatherDetailsPresentation = ((CityCellModel) -> Void)

protocol CityListViewModelType {
    var reloadTable: ReloadClosure? { get set }
    var showWeatherDetails: WeatherDetailsPresentation? { get set }
    func numberOfCities() -> Int
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellModel
    func updateWeatherInfo(with info: WeatherInfoResponse)
}

final class CityListViewModel: CityListViewModelType {
    var reloadTable: ReloadClosure?
    var showWeatherDetails: WeatherDetailsPresentation?
    private var weatherInfo: WeatherInfoResponse? {
        didSet {
            addToCityList()
        }
    }
    
    private var cityCellModels = [CityCellModel]()
    
    func numberOfCities() -> Int {
        cityCellModels.count
    }
    
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellModel {
        cityCellModels[indexPath.row]
    }
    
    private func createCellModel() -> CityCellModel? {
        guard let weatherInfo = weatherInfo else { return nil }
        var cityCellModel = CityCellModel(cityName: weatherInfo.name ?? "",
                                                  temperature: weatherInfo.main?.temp ?? 0.0,
                                                  icon: weatherInfo.weather?.first?.icon ?? "")
        cityCellModel.didSelectCell = {
            //Handler for selecting a city
            self.showWeatherDetails?(cityCellModel)
        }
        return cityCellModel
    }
    
    func updateWeatherInfo(with info: WeatherInfoResponse) {
        weatherInfo = info
    }
    
    private func addToCityList() {
        //Add to city list
        if let cityCellModel = createCellModel() {
            cityCellModels.append(cityCellModel)
            reloadTable?()
        }
    }
}
