//
//  CityModel.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation

protocol CityDelegate
{
    var city: String { get set }
    var history: [AirQualityModel] { get set }
}


class CityModel: CityDelegate
{
	/// A city name.
    var city: String
	/// A city history data.
    var history: [AirQualityModel] = [AirQualityModel]()

    init(city: String)
    {
        self.city = city
    }
}
