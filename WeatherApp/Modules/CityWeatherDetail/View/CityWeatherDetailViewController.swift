//
//  CityWeatherDetailViewController.swift
//  WeatherApp

import UIKit
import WeatherInformation

class CityWeatherDetailViewController: UIViewController {
    
    private lazy var viewModel: CityWeatherDetailViewModelType = {
        return CityWeatherDetailViewModel()
    }()
    
    private var cityName = ""

    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        loadWeatherDetails()
    }
    
    //MARK: - View model setup -
    private func setupViewModel() {
        viewModel.showLoadingClosure = { [weak self] completion in
            guard let self = self else { return }
        }
        
        viewModel.hideLoadingClosure = { [weak self] completion in
            guard let self = self else { return }
        }
        
        viewModel.showAlertClosure = { [weak self] (message, error) in
            guard let self = self else { return }
            if let apiError = error as? APIError {
                switch apiError {
                case .serverError: break
                case .decodingError: break
                case .requestError(let error):
                    if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                        //Showing alert when device is not connected to the internet
                    }
                default: break
                }
            }
        }
        
        viewModel.showWeatherInfo = { [weak self] (weatherInfo) in
            guard let self = self else { return }
        }
    }
    
    //MARK: - API calling
    func loadWeatherDetails() {
        viewModel.fetchWeatherInfo(for: cityName, in: .metric)
    }
    
    //MARK: - Handle city name
    func setCityName(as name: String) {
        cityName = name
    }
}
