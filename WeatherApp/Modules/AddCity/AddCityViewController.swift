//
//  AddCityViewController.swift
//  WeatherApp
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet private weak var cityNameTextField: UITextField!
    
    lazy var viewModel: AddCityViewModelType = {
        return AddCityViewModel()
    }()
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Text field editing -
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.updateCityName(with: sender.text?.trim ?? "")
    }
    
    //MARK: - Button action -
    @IBAction func addCityAction(_ sender: UIButton) {
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
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
