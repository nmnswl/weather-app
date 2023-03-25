//
//  InputValidator.swift
//  WeatherApp

import Foundation

struct InputValidator {
    func isEmpty(string: String) -> Bool {
        string.isEmpty
    }
    
    func containsNumbers(string: String) -> Bool {
        //Checks if string contains numbers
        let decimalCharacterSet = CharacterSet.decimalDigits
        let range = string.rangeOfCharacter(from: decimalCharacterSet)
        return range != nil
    }
    
    func containsSpecialCharacters(string: String) -> Bool {
        //Checks if string contains special characters
        let characterSet = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let range = string.rangeOfCharacter(from: characterSet.inverted)
        return range != nil
    }
}
