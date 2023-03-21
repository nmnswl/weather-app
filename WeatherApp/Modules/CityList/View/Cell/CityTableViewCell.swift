//
//  CityTableViewCell.swift
//  WeatherApp

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var roundView: UIView!
    
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cityCellViewModel: CityCellViewModel? {
        didSet {
            cityNameLabel.text = cityCellViewModel?.cityName
            temperatureLabel.text = "\(cityCellViewModel?.temperature ?? 0.0)\(Units.metric.temperatureUnit)"
            weatherImageView.image = UIImage(named: cityCellViewModel?.icon ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundView.roundCornersWithRadius(10)
        roundView.applyBorder(color: .black, width: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
