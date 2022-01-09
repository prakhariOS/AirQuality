//
//  a.swift
//  AQMAppTests
//
//  Created by prakhar gupta on 09/01/22.
//

import XCTest
import RxSwift
import Nimble

@testable import AQMApp

	// MARK: - Dummy data (success)
	let dummyResponse: [AirQualityResponseModel] = [AirQualityResponseModel(
		city: "Jaipur", aqi: 100.0
	)]
	let dummyDataProvider: DataProvider = DummyDataProvider(
		dummyResponse: .success(dummyResponse)
	)

	let dummyDataProviderError: DataProvider
    = DummyDataProvider(dummyResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class AirQualityListViewModelTests: XCTestCase
{
    let listViewModel: AirQualityListViewModel = AirQualityListViewModel(dataProvider: dummyDataProvider)

    let listViewModelError: AirQualityListViewModel = AirQualityListViewModel(dataProvider: dummyDataProviderError)

    func testRespnoseData()
    {
        self.listViewModel.subscribe()
        expect(self.listViewModel.previousItems.first?.city) == dummyResponse.first?.city
        expect(self.listViewModel.previousItems.first?.history.last?.value) == dummyResponse.first?.aqi

        self.listViewModel.unsubscribe()
    }

    func testPrevItemsDataAvailability()
    {
        let item = CityModel(city: "jaipur")
        item.history = [AirQualityModel(value: 150, date: Date())]
        self.listViewModel.previousItems = [item]

        self.listViewModel.subscribe()

        expect(self.listViewModel.previousItems.first?.city) == "jaipur"
        expect(self.listViewModel.previousItems.first?.history.last?.value) == 150

        self.listViewModel.unsubscribe()
    }

    func testErrorResponse()
    {
        self.listViewModelError.subscribe()

        let item = self.listViewModelError.previousItems
        expect(item.count) == 0

    }
}
