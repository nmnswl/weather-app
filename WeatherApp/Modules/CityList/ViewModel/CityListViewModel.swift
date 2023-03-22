//
//  CityListViewModel.swift
//  WeatherApp

import Foundation

protocol CityListViewModelType {
    var reloadTable: (() -> Void)? { get set }
    var showWeatherDetails: ((CityCellViewModel) -> Void)? { get set }
    func numberOfCities() -> Int
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellViewModel
    func updateWeatherInfo(with info: WeatherInfoResponse)
}

final class CityListViewModel: CityListViewModelType {
    var reloadTable: (() -> Void)?
    var showWeatherDetails: ((CityCellViewModel) -> Void)?
    private var weatherInfo: WeatherInfoResponse? {
        didSet {
            addToCityList()
        }
    }
    
    private var cityCellViewModels = [CityCellViewModel]()
    
    func numberOfCities() -> Int {
        cityCellViewModels.count
    }
    
    func getCellViewModelAt(at indexPath: IndexPath) -> CityCellViewModel {
        cityCellViewModels[indexPath.row]
    }
    
    private func createCellModel() -> CityCellViewModel? {
        guard let weatherInfo = weatherInfo else { return nil }
        var cityCellViewModel = CityCellViewModel(cityName: weatherInfo.name ?? "",
                                                  temperature: weatherInfo.main?.temp ?? 0.0,
                                                  icon: weatherInfo.weather?.first?.icon ?? "")
        cityCellViewModel.didSelectCell = {
            //Handler for selecting a city
            self.showWeatherDetails?(cityCellViewModel)
        }
        return cityCellViewModel
    }
    
    func updateWeatherInfo(with info: WeatherInfoResponse) {
        weatherInfo = info
    }
    
    private func addToCityList() {
        //Add to city list
        if let cityCellViewModel  = createCellModel() {
            cityCellViewModels.append(cityCellViewModel)
            reloadTable?()
        }
    }
}
