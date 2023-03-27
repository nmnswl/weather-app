//
//  CityWeatherDetailViewModelTest.swift
//  WeatherAppTests

import XCTest
@testable import WeatherApp

final class CityWeatherDetailViewModelTest: XCTestCase {

    var weatherInfoService: MockWeatherInfoNetworkService?
    var cityWeatherDetailViewModel: CityWeatherDetailViewModel?
    var coreDataManager: CoreDataManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = CoreDataManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherInfoService = nil
        cityWeatherDetailViewModel = nil
        coreDataManager = nil
    }

    func testFetchWeatherInfo_Success() throws {
        weatherInfoService = MockWeatherInfoNetworkService(status: .success)
        cityWeatherDetailViewModel = CityWeatherDetailViewModel(networkService: weatherInfoService!)
        let cityName = "Goa"
        cityWeatherDetailViewModel?.setCityName(as: cityName)
        
        let expectation = expectation(description: "API hit with success")
        
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
        
        cityWeatherDetailViewModel?.showWeatherInfo = { weatherInfo in
            //Ensuring correct model is fetched
            XCTAssertEqual(weatherInfo.name, weatherInfoResponse.name)
            XCTAssertEqual(weatherInfo.weather?.first?.main, weatherInfoResponse.weather?.first?.main)
            XCTAssertEqual(weatherInfo.main?.temp, weatherInfoResponse.main?.temp)
            XCTAssertEqual(weatherInfo.wind?.speed, weatherInfoResponse.wind?.speed)
            expectation.fulfill()
        }
        
        cityWeatherDetailViewModel?.fetchWeatherInfo()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchWeatherInfo_Error() throws {
        weatherInfoService = MockWeatherInfoNetworkService(status: .error)
        cityWeatherDetailViewModel = CityWeatherDetailViewModel(networkService: weatherInfoService!)
        let cityName = "Goa"
        cityWeatherDetailViewModel?.setCityName(as: cityName)
        
        let expectation = expectation(description: "API hit with error")
        
        cityWeatherDetailViewModel?.showAlertClosure = { (error) in
            //Ensuring that error is returned
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        cityWeatherDetailViewModel?.fetchWeatherInfo()
        
        wait(for: [expectation], timeout: 2.0)
    }
}
