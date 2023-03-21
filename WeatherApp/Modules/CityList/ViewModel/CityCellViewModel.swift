//
//  CityCellViewModel.swift
//  WeatherApp

import Foundation

protocol Pressable {
    var didSelectCell: (() -> Void)? { get set }
}

struct CityCellViewModel: Pressable {
    var didSelectCell: (() -> Void)?
    var cityName: String?
    var temperature: Double?
    var icon: String?
}
