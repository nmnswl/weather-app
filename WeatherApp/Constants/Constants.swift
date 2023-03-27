//
//  Constants.swift
//  WeatherApp

import Foundation

struct Constants {
    struct Alert {
        static let internetError = "Your device is not connected to the internet. Please check your network settings and try again."
        static let cityNameBlank = "Please enter city name"
        static let cityNameContainsNumbers = "The name of the city must not contain numbers"
        static let cityNameContainsSpecialCharacters = "The name of the city must not contain special characters"
        static let cityAlreadyExists = "This city has already been added"
        static let fetchDataError = "Could not fetch information"
        static let validationAlertTitle = "Validation Error"
        static let errorAlertTitle = "Error"
        static let serverError = "Server Error"
        static let decodingError = "Error in decoding data"
        static let noDataError = "Blank data in response"
        static let generalError = "An error has occurred. Please try again."
    }
    
    struct NotificationKeys {
        static let weatherInfo = "weatherInfo"
    }
}
