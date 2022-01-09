//
//  AirQualityColor.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit

struct AirQualityIndexColor
{
	///
	/// A air quality color according to the index
	///
	static func color(index: AirQualityCategory) -> UIColor
	{
		switch index
		{
		case .good: return UIColor(hexString: "#55A84F")
		case .satisfactory: return UIColor(hexString: "#A3C853")
		case .moderate: return UIColor(hexString: "#FCF834")
		case .poor: return UIColor(hexString: "#EE9A32")
		case .veryPoor: return UIColor(hexString: "#DE3B30")
		case .severe: return UIColor(hexString: "#A72B22")
		case .outOfRange: return UIColor(hexString: "#A72B22")
		}
	}
}
