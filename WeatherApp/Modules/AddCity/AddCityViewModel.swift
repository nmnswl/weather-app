//
//  AddCityViewModel.swift
//  WeatherApp

import Foundation

protocol AddCityViewModelType {
    func updateCityName(with name: String)
    func isCityNameEntered() -> Bool
    func getCityName() -> String
}

final class AddCityViewModel: AddCityViewModelType {
    private var cityName = ""
    
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
}
