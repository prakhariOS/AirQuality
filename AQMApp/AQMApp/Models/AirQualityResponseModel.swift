//
//  AirQualityResponseModel.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation

struct AirQualityResponseModel: Codable
{
	/// A city name.
    var city: String
	/// An air quality index value.
    var aqi: Float

    init(city: String, aqi: Float)
    {
        self.city = city
        self.aqi = aqi
    }
}
