//
//  DummyDataProvider.swift
//  AQMAppTests
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit
import RxSwift

@testable import AQMApp


typealias DataProviderResponse = Result<[AirQualityResponseModel], Error>

class DummyDataProvider: DataProvider
{
    private var dummyResponse: DataProviderResponse
    var item = PublishSubject<CityModel>()

    init(dummyResponse: DataProviderResponse)
    {
        self.dummyResponse = dummyResponse
    }

    override func subscribe()
    {
        self.notifyFakeResponse()
    }

    private func notifyFakeResponse()
    {
        switch self.dummyResponse
        {
        case .success(let res): self.delegate?.didReceive(response: .success(res))
        case .failure(let error): self.delegate?.didReceive(response: .failure(error))
        }
    }
}
