//
//  AirQualityModel.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation

class AirQualityModel
{
	/// A air quality value.
    var value: Float = 0.0
	/// A date.
    var date: Date = Date()

    init(value: Float, date: Date)
    {
        self.value = value
        self.date = date
    }
}
