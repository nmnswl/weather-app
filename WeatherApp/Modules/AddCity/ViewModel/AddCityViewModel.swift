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
    func cityNameContainsNumbers() -> Bool
    func cityNameContainsSpecialCharacters() -> Bool
}

final class AddCityViewModel: AddCityViewModelType {
    private var cityName = ""
    weak var coordinatorDelegate: AddCityViewModelToCoordinator?
    private let validator = InputValidator()
    
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
    
    func cityNameContainsNumbers() -> Bool {
        //Check if city name contains numbers
        validator.containsNumbers(string: cityName)
    }
    
    func cityNameContainsSpecialCharacters() -> Bool {
        //Check if city name contains special characters
        validator.containsSpecialCharacters(string: cityName)
    }
    
    func showWeatherDetails() {
        coordinatorDelegate?.showWeatherDetails(for: cityName)
    }
    
    func didTapBack() {
        coordinatorDelegate?.didTapBack()
    }
}
