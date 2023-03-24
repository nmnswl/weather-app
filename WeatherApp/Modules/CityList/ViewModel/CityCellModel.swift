//
//  CityCellModel.swift
//  WeatherApp

import Foundation

typealias CellSelection = (() -> Void)

protocol Pressable {
    var didSelectCell: CellSelection? { get set }
}

struct CityCellModel: Pressable {
    var didSelectCell: CellSelection?
    var cityName: String?
    var temperature: Double?
    var icon: String?
}
