//
//  AirQualityGraphViewController.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class AirQualityGraphViewController: UIViewController
{
    var cityModel: CityModel = CityModel(city: "")
    private var viewModel: AirQualityDetailViewModel?
    private var bag = DisposeBag()
    private let chartView = LineChartView()
    var dataEntries = [ChartDataEntry]()

    // Indicates how many dataEntries showing in the chartView.
    var xValue: Double = 30
}


//MARK: - Overrides
extension AirQualityGraphViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.viewModel = AirQualityDetailViewModel(dataProvider: DataProvider())

        self.title = cityModel.city

        self.view.addSubview(chartView)
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        self.chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        self.chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        self.setupInitialDataEntries()
        self.setupChartData()
        self.bindData()
    }

	override func viewWillAppear(_ animated: Bool)
	{
        super.viewWillAppear(animated)

        self.viewModel?.subscribe(forCity: cityModel.city)
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.viewModel?.unsubscribe()
    }
}


//MARK: - Helper methods
extension AirQualityGraphViewController
{
    func bindData()
    {
        self.viewModel?.item.bind { model in

            if let v = model.history.last?.value
            {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
        }.disposed(by: bag)
    }
}

//MARK: - Graph UI
extension AirQualityGraphViewController
{
    func setupInitialDataEntries()
    {
        (0..<Int(xValue)).forEach
        {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            self.dataEntries.append(dataEntry)
        }
    }

    func setupChartData()
    {
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Air Quality for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawFilledEnabled = false
        chartDataSet.drawIconsEnabled = false
        chartDataSet.setColor(.red)
        chartDataSet.mode = .linear
        chartDataSet.setCircleColor(.red)
        if let font = UIFont(name: "Helvetica Neue", size: 5)
        {
            chartDataSet.valueFont = font
        }

        let chartData = LineChartData(dataSet: chartDataSet)
        self.chartView.data = chartData
        self.chartView.xAxis.labelPosition = .bottom
    }

    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry])
    {
        if let oldEntry = dataEntries.first
        {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }

        dataEntries.append(newDataEntry)
        self.chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)

        self.chartView.notifyDataSetChanged()
        self.chartView.moveViewToX(newDataEntry.x)
    }

}
