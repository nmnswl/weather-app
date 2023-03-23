//
//  CityCellViewModel.swift
//  WeatherApp

import Foundation

typealias CellSelection = (() -> Void)

protocol Pressable {
    var didSelectCell: CellSelection? { get set }
}

struct CityCellViewModel: Pressable {
    var didSelectCell: CellSelection?
    var cityName: String?
    var temperature: Double?
    var icon: String?
}
