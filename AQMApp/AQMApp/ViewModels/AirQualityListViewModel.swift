//
//  AirQualityListViewModel.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class AirQualityListViewModel
{
    var previousItems: [CityModel] = [CityModel]()
    var items = PublishSubject<[CityModel]>()
    var provider: DataProvider?

    init(dataProvider: DataProvider)
    {
        self.provider = dataProvider
        self.provider?.delegate = self
    }
}


//MARK: - Data provider delegate
extension AirQualityListViewModel: DataProviderDelegate
{
    func didReceive(response: Result<[AirQualityResponseModel], Error>)
    {
        switch response
        {
        case .success(let response): parseAndNotify(resArray: response)
        case .failure(let error): handleError(error: error)
        }
    }
}

//MARK: - Helper methods
extension AirQualityListViewModel
{
    func subscribe()
    {
        self.provider?.subscribe()
    }

    func unsubscribe()
    {
        self.provider?.unsubscribe()
    }

	func parseAndNotify(resArray: [AirQualityResponseModel])
    {
        if self.previousItems.count == 0
        {
            for data in resArray
            {
                let model = CityModel(city: data.city)
                model.history.append(AirQualityModel(value: data.aqi, date: Date()))
                self.previousItems.append(model)
            }
        }
        else
        {
            for response in resArray
            {
                let matchedResults = self.previousItems.filter { $0.city == response.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.history.append(AirQualityModel(value: response.aqi, date: Date()))
                } else {
                    let model = CityModel(city: response.city)
                    model.history.append(AirQualityModel(value: response.aqi, date: Date()))
                    self.previousItems.append(model)
                }
            }
        }

        self.items.onNext(previousItems)
    }

    func handleError(error: Error?)
    {
        if let err = error
        {
            self.items.onError(err)
        }
    }
}
