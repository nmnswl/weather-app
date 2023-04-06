//
//  CityWeatherDetailViewModelTest.swift
//  WeatherAppTests

import XCTest
@testable import WeatherApp

final class CityWeatherDetailViewModelTest: XCTestCase {

    var weatherInfoService: MockWeatherInfoNetworkService?
    var cityWeatherDetailViewModel: CityWeatherDetailViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherInfoService = MockWeatherInfoNetworkService()
        cityWeatherDetailViewModel = CityWeatherDetailViewModel(networkService: weatherInfoService!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherInfoService = nil
        cityWeatherDetailViewModel = nil
    }

    func testFetchWeatherInfo_Success() throws {
        weatherInfoService?.status = .success
        let cityName = "Goa"
        cityWeatherDetailViewModel?.setCityName(as: cityName)
        
        let expectation = expectation(description: "API hit with success")
        
        let weather = WeatherModel(id: 1, main: "Cloudy", description: "Cloudy sky", icon: "01d")
        let main = MainModel(temp: 20.01, pressure: 1006, humidity: 32, temp_min: 19.01, temp_max: 22.01)
        let wind = WindModel(speed: 6.15)
        let weatherInfoModel = WeatherInfo(weather: [weather], main: main, wind: wind, visibility: 10000, name: cityName)
        
        cityWeatherDetailViewModel?.showWeatherInfo = { weatherInfo in
            //Ensuring correct model is fetched
            XCTAssertEqual(weatherInfo.name, weatherInfoModel.name)
            XCTAssertEqual(weatherInfo.weather?.first?.main, weatherInfoModel.weather?.first?.main)
            XCTAssertEqual(weatherInfo.main?.temp, weatherInfoModel.main?.temp)
            XCTAssertEqual(weatherInfo.wind?.speed, weatherInfoModel.wind?.speed)
            expectation.fulfill()
        }
        
        cityWeatherDetailViewModel?.fetchWeatherInfo()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeatherInfo_Error() throws {
        weatherInfoService?.status = .error
        let cityName = "Goa"
        cityWeatherDetailViewModel?.setCityName(as: cityName)
        
        let expectation = expectation(description: "API hit with error")
        
        cityWeatherDetailViewModel?.showAlertClosure = { (message, error) in
            //Ensuring that error is returned
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        cityWeatherDetailViewModel?.fetchWeatherInfo()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testIfCityNameIsSet() throws {
        let expectedCityName = "Goa"
        cityWeatherDetailViewModel?.setCityName(as: expectedCityName)
        XCTAssertEqual(expectedCityName, cityWeatherDetailViewModel?.getCityName())
    }
}
