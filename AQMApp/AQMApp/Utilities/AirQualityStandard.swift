//
//  AirQualityStandard.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit

///
/// A kind of air quality.
///
enum AirQualityCategory
{
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case outOfRange
}

///
/// Define Air quality srandards.
///
class AirQualityStandard
{
	///
	/// A air quality standard according to the range
	///
    static func airQualityIndex(aqs: Float) -> AirQualityCategory
    {
		switch aqs
		{
		case 0...50: return .good
		case 51...100: return .satisfactory
		case 101...200: return .moderate
		case 201...300: return .poor
		case 301...400: return .veryPoor
		case 401...500: return .severe
		default: return .outOfRange
		}
    }
}
