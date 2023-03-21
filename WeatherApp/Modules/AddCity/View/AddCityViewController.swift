//
//  AddCityViewController.swift
//  WeatherApp
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet private weak var cityNameTextField: UITextField!
    @IBOutlet private weak var addCityButton: UIButton!
    
    private lazy var viewModel: AddCityViewModelType = {
        return AddCityViewModel()
    }()
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - UI setup -
    func setupUI() {
        addCityButton.layer.cornerRadius = 10
    }
    
    //MARK: - Text field editing -
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.updateCityName(with: sender.text?.trim ?? "")
    }
    
    //MARK: - Button action -
    @IBAction private func addCityAction(_ sender: UIButton) {
        if !viewModel.isCityNameEntered() {
            topMostViewController().showAlertControllerWith(title: Constants.Alert.validationAlertTitle,
                                                            message: Constants.Alert.cityNameBlank,
                                                            buttons: .ok(nil))
            return
        }
        guard let detailViewController = UIStoryboard.main.instantiateViewController(identifier: CityWeatherDetailViewController.identifier) as? CityWeatherDetailViewController else { return }
        detailViewController.setCityName(as: viewModel.getCityName())
        topMostViewController().navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @IBAction private func actionBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
