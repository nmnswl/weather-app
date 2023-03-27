//
//  CityListViewController.swift
//  WeatherApp

import UIKit
import Combine

class CityListViewController: UIViewController {

    @IBOutlet private weak var noCityLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: CityListViewModelType!
    private var cancellable: AnyCancellable?
    
    //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        fetchCities()
    }
    
    //MARK: - View setup -
    private func setupView() {
        tableView.register(CityTableViewCell.nib, forCellReuseIdentifier: CityTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        addNotificationObserver()
    }
    
    //MARK: - View model setup -
    func bindViewModel(_ viewModel: CityListViewModelType) {
        self.viewModel = viewModel
    }
    
    private func setupViewModel() {
        viewModel.reloadTable = { [weak self] in
            guard let self = self else { return }
            self.noCityLabel.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    //MARK: - API calling -
    private func fetchCities() {
        viewModel.fetchAllCities()
    }
    
    //MARK: - Notification handling -
    private func addNotificationObserver() {
        cancellable = NotificationCenter.Publisher(center: .default, name: .weatherInfoFetched, object: nil).sink(receiveValue: { [weak self] notification in
            guard let self = self, let weatherInfoResponse = notification.object as? WeatherInfoResponse else { return }
            self.viewModel.updateWeatherInfo(with: weatherInfoResponse)
        })
    }
    
    //MARK: - Button action -
    @IBAction private func addCityButtonAction(_ sender: UIButton) {
        viewModel.addCity()
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
