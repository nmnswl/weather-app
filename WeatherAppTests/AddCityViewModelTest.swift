//
//  AddCityViewModelTest.swift
//  WeatherAppTests

import XCTest
@testable import WeatherApp

final class AddCityViewModelTest: XCTestCase {

    var viewModel: AddCityViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = AddCityViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testIfCityNameIsUpdated() throws {
        let cityName = "Goa"
        viewModel.updateCityName(with: cityName)
        XCTAssertEqual(cityName, viewModel?.getCityName())
    }
    
    func testIfCityNameIsEmpty() throws {
        let cityName = ""
        viewModel.updateCityName(with: cityName)
        XCTAssertFalse(viewModel.isCityNameEntered())
    }
    
    func testIfCityNameIsNotEmpty() throws {
        let cityName = "Goa"
        viewModel.updateCityName(with: cityName)
        XCTAssertTrue(viewModel.isCityNameEntered())
    }
    
    func testIfCityNameHasNumbers() throws {
        let cityName = "Goa123"
        viewModel.updateCityName(with: cityName)
        XCTAssertTrue(viewModel.cityNameContainsNumbers())
    }
    
    func testIfCityNameDoesNotHaveNumbers() throws {
        let cityName = "Goa"
        viewModel.updateCityName(with: cityName)
        XCTAssertFalse(viewModel.cityNameContainsNumbers())
    }
    
    func testIfCityNameHasSpecialCharacters() throws {
        let cityName = "Goa*^%"
        viewModel.updateCityName(with: cityName)
        XCTAssertTrue(viewModel.cityNameContainsSpecialCharacters())
    }
    
    func testIfCityNameDoesNotHaveSpecialCharacters() throws {
        let cityName = "Goa"
        viewModel.updateCityName(with: cityName)
        XCTAssertFalse(viewModel.cityNameContainsSpecialCharacters())
    }
}
