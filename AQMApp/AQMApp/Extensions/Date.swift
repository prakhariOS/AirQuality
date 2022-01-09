//
//  Date.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit

extension Date
{
	///
	/// Calculate a last updated time.
	///
    func timeAgo() -> String
    {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(
			from: self, to: Date()) ?? "",
			locale: .current
		)
    }
}
