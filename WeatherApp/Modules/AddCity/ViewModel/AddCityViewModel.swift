//
//  AddCityViewModel.swift
//  WeatherApp

import Foundation

protocol AddCityViewModelType {
    func updateCityName(with name: String)
    func isCityNameEntered() -> Bool
    func getCityName() -> String
    func showWeatherDetails()
    func didTapBack()
}

final class AddCityViewModel: AddCityViewModelType {
    private var cityName = ""
    weak var coordinatorDelegate: AddCityViewModelToCoordinator?
    
    func isCityNameEntered() -> Bool {
        //Check if city name is blank
        !cityName.isEmpty
    }
    
    func updateCityName(with name: String) {
        //Updates the city name
        cityName = name
    }
    
    func getCityName() -> String {
        //Returns city name
        cityName
    }
    
    func showWeatherDetails() {
        coordinatorDelegate?.showWeatherDetails(for: cityName)
    }
    
    func didTapBack() {
        coordinatorDelegate?.didTapBack()
    }
}
