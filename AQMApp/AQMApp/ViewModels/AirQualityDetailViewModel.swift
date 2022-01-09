//
//  AirQualityDetailViewModel.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import Starscream

class AirQualityDetailViewModel
{
    private var city: String = ""
    var previousItem: CityModel? = nil
    var item = PublishSubject<CityModel>()
    var provider: DataProvider?

    init(dataProvider: DataProvider)
    {
        self.provider = dataProvider
        self.provider?.delegate = self
    }
}


//MARK: - DataProvider delegate methods
extension AirQualityDetailViewModel: DataProviderDelegate
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
extension AirQualityDetailViewModel
{
    func subscribe(forCity: String)
    {
        self.city = forCity
        self.provider?.subscribe()
    }

    func unsubscribe()
    {
        self.provider?.unsubscribe()
    }

	func parseAndNotify(resArray: [AirQualityResponseModel])
    {
        let cityData = resArray.filter { $0.city == city }
        if let data = cityData.first
        {
            if let prev = previousItem
            {
                prev.history.append(AirQualityModel(value: data.aqi, date: Date()))
            }
            else
            {
                self.previousItem = CityModel(city: self.city)
                self.previousItem?.history.append(AirQualityModel(value: data.aqi, date: Date()))
            }
        }
        else
        {
            if let prev = previousItem, let last = prev.history.last
            {
                prev.history.append(last)
            }
        }

        if let item = previousItem
        {
            self.item.onNext(item)
        }
    }

    func handleError(error: Error?)
    {
        if let err = error
        {
            self.item.onError(err)
        }
    }
}
