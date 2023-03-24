//
//  CityListViewController.swift
//  WeatherApp

import UIKit

class CityListViewController: UIViewController {

    @IBOutlet private weak var noCityLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var viewModel: CityListViewModelType = {
        CityListViewModel()
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }
    
    //MARK: - View setup -
    private func setupView() {
        tableView.register(CityTableViewCell.nib, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationObserver()
    }
    
    //MARK: - View model setup -
    private func setupViewModel() {
        viewModel.reloadTable = { [weak self] in
            guard let self = self else { return }
            self.noCityLabel.isHidden = true
            self.tableView.reloadData()
        }
        
        viewModel.showWeatherDetails = { (cityViewModel) in
            guard let detailViewController = UIStoryboard.main.instantiateViewController(withIdentifier: CityWeatherDetailViewController.identifier) as? CityWeatherDetailViewController,
            let navigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
            detailViewController.setCityName(as: cityViewModel.cityName ?? "", navigationFrom: .cityList)
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
    
    //MARK: - Notification handling -
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(weatherInfoReceived),
                                               name: .weatherInfoFetched,
                                               object: nil)
    }
    
    @objc private func weatherInfoReceived(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let weatherInfoResponse = userInfo[Constants.NotificationKeys.weatherInfo] as? WeatherInfoResponse {
            viewModel.updateWeatherInfo(with: weatherInfoResponse)
        }
    }
    
    //MARK: - Button action -
    @IBAction private func addCityButtonAction(_ sender: UIButton) {
        guard let addCityViewController = UIStoryboard.main.instantiateViewController(identifier: AddCityViewController.identifier) as? AddCityViewController,
        let navigationController = AppDelegate.shared.window?.rootViewController as? UINavigationController else { return }
        navigationController.pushViewController(addCityViewController, animated: true)
    }
}

//MARK: - Table view datasource -
extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCities()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.getCellViewModelAt(at: indexPath)
        cell.cityCellModel = cellViewModel
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - Table view delegate -
extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.getCellViewModelAt(at: indexPath)
        cellViewModel.didSelectCell?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
