//
//  CityTableViewCell.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit

class CityTableViewCell: UITableViewCell
{
	private enum Constants
	{
		static let zeroSeconds = "0 seconds"
		static let justnow = "just now"
		static let ago = " ago"
	}

	/// A city label.
    @IBOutlet private var labelCity: UILabel?
	/// A current AirQuality index value.
    @IBOutlet private var labelAQI: UILabel?
	/// A last updated time label.
    @IBOutlet private var labelLastUpdated: UILabel?

	var isLastgoodValue: Bool = false
	/// A city data.
    var cityData: CityModel?
    {
        didSet
        {
            guard let cityData = cityData else { return }
            self.labelCity?.text = cityData.city

            if let aqi = cityData.history.last?.value
            {
                self.labelAQI?.text = String(format: "%.2f", aqi)
            }

            if let value = cityData.history.last?.value
            {
                let index = AirQualityStandard.airQualityIndex(aqs: value)
                self.labelAQI?.textColor = AirQualityIndexColor.color(index: index)
                if self.isLastgoodValue && index == .poor
                {
					self.contentView.backgroundColor = .orange
				}
				self.isLastgoodValue = false
            }

            if let date = cityData.history.last?.date
            {
                if date.timeAgo() == Constants.zeroSeconds
                {
                    self.labelLastUpdated?.text = Constants.justnow
                }
                else
                {
                    self.labelLastUpdated?.text = date.timeAgo() + Constants.ago
                }
            }
        }
    }
}


//MARK: - overrides
extension CityTableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        labelAQI?.layer.cornerRadius = 5
        labelAQI?.layer.masksToBounds = true
    }
}
