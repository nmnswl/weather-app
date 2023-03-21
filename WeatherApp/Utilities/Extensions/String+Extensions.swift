//
//  String+Extensions.swift
//  WeatherApp

import Foundation

extension String {
    var trim: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
