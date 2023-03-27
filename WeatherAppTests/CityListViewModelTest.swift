//
//  CityListViewModelTest.swift
//  WeatherAppTests

import XCTest
@testable import WeatherApp

final class CityListViewModelTest: XCTestCase {

    var viewModel: CityListViewModel!
    var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CityListViewModel()
        coreDataManager = CoreDataManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        coreDataManager = nil
    }

    func testCityCellModelsCount() throws {
        let cityName = "Goa"
        
        let weather = Weather(context: coreDataManager.managedObjectContext)
        weather.id = 1
        weather.main = "Cloudy"
        weather.weatherDescription = "Cloudy sky"
        weather.icon = "01d"
        
        let main = Main(context: coreDataManager.managedObjectContext)
        main.temp = 20.01
        main.pressure = 1006
        main.humidity = 32
        main.temp_min = 19.01
        main.temp_max = 22.01
        
        let wind = Wind(context: coreDataManager.managedObjectContext)
        wind.speed = 6.15
        
        let weatherInfoResponse = WeatherInfoResponse(context: coreDataManager.managedObjectContext)
        weatherInfoResponse.weather = [weather]
        weatherInfoResponse.main = main
        weatherInfoResponse.wind = wind
        weatherInfoResponse.visibility = 10000
        weatherInfoResponse.name = cityName
        
        viewModel.updateWeatherInfo(with: weatherInfoResponse)
        
        //Ensuring correct number of cities
        XCTAssertEqual(viewModel.numberOfCities(), 1)
    }
    
    func testFetchingCityCellModel() throws {
        let cityName = "Goa"
        
        let weather = Weather(context: coreDataManager.managedObjectContext)
        weather.id = 1
        weather.main = "Cloudy"
        weather.weatherDescription = "Cloudy sky"
        weather.icon = "01d"
        
        let main = Main(context: coreDataManager.managedObjectContext)
        main.temp = 20.01
        main.pressure = 1006
        main.humidity = 32
        main.temp_min = 19.01
        main.temp_max = 22.01
        
        let wind = Wind(context: coreDataManager.managedObjectContext)
        wind.speed = 6.15
        
        let weatherInfoResponse = WeatherInfoResponse(context: coreDataManager.managedObjectContext)
        weatherInfoResponse.weather = [weather]
        weatherInfoResponse.main = main
        weatherInfoResponse.wind = wind
        weatherInfoResponse.visibility = 10000
        weatherInfoResponse.name = cityName
        
        viewModel.updateWeatherInfo(with: weatherInfoResponse)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let fetchedCityCellModel = viewModel.getCellViewModelAt(at: indexPath)
        let expectedCityCellModel = CityCellModel(cityName: cityName,
                                                  temperature: 20.01,
                                                  icon: "01d")
        
        //Ensuring correct model
        XCTAssertEqual(expectedCityCellModel.cityName, fetchedCityCellModel.cityName)
        XCTAssertEqual(expectedCityCellModel.temperature, fetchedCityCellModel.temperature)
    }
}
