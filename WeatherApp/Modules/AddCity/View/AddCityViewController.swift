//
//  AddCityViewController.swift
//  WeatherApp
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet private weak var cityNameTextField: UITextField!
    @IBOutlet private weak var addCityButton: UIButton!
    
    private var viewModel: AddCityViewModelType!
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - UI setup -
    private func setupUI() {
        addCityButton.layer.cornerRadius = 10
    }
    
    //MARK: - View model setup -
    func bindViewModel(_ viewModel: AddCityViewModelType) {
        self.viewModel = viewModel
    }
    
    //MARK: - Text field editing -
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.updateCityName(with: sender.text?.trim ?? "")
    }
    
    //MARK: - Button action -
    @IBAction private func addCityAction(_ sender: UIButton) {
        if !viewModel.isCityNameEntered() {
            showAlertControllerWith(title: Constants.Alert.validationAlertTitle,
                                                            message: Constants.Alert.cityNameBlank,
                                                            buttons: .ok(nil))
        } else if viewModel.cityNameContainsNumbers() {
            showAlertControllerWith(title: Constants.Alert.validationAlertTitle,
                                    message: Constants.Alert.cityNameContainsNumbers,
                                    buttons: .ok(nil))
        } else if viewModel.cityNameContainsSpecialCharacters() {
            showAlertControllerWith(title: Constants.Alert.validationAlertTitle,
                                    message: Constants.Alert.cityNameContainsSpecialCharacters,
                                    buttons: .ok(nil))
        } else if viewModel.checkIfCityAlreadyExists() {
            showAlertControllerWith(title: Constants.Alert.validationAlertTitle,
                                                            message: Constants.Alert.cityAlreadyExists,
                                                            buttons: .ok(nil))
        } else {
            viewModel.showWeatherDetails()
        }
    }
    
    @IBAction private func actionBack(_ sender: UIButton) {
        viewModel.didTapBack()
    }
}

//MARK: - Text field delegate -
extension AddCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
}
