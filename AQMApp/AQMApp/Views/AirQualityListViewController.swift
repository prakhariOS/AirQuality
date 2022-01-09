//
//  AirQualityListViewController.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import UIKit
import RxSwift
import RxCocoa

///
/// A view controller which showing the list of city with there air quality
/// value
///
class AirQualityListViewController: UIViewController, UIScrollViewDelegate
{
	/// A table view to show a air quality listing city vise.
	@IBOutlet private var tableView: UITableView!

    private var viewModel: AirQualityListViewModel?
    private var disposeBag = DisposeBag()

	deinit
	{
        // UnSubscribe socket connection
        viewModel?.unsubscribe()
    }
}


//MARK: - Overrides
extension AirQualityListViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Air Quality"

        self.viewModel = AirQualityListViewModel(dataProvider: DataProvider())

        self.bindData()
    }

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)

        // Subscribe socket connection
        self.viewModel?.subscribe()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        // UnSubscribe socket connection
        self.viewModel?.unsubscribe()
    }
}


//MARK: - Helper methods
extension AirQualityListViewController
{
	///
	/// Binding the item into list and navigate on graph view
	/// while selecting an any city.
	///
    private func bindData()
    {
        self.viewModel?.items.bind(to: self.tableView.rx.items(cellIdentifier: "CityTableViewCell", cellType: CityTableViewCell.self)) { [weak self] row, model, cell in
			if let lastGoodValue = self?.viewModel?.previousItems[row].history.last?.value,
				lastGoodValue <= 50
			{
				cell.isLastgoodValue = true
			}
            cell.cityData = model

        }.disposed(by: disposeBag)

        self.tableView.rx.modelSelected(CityModel.self).bind { item in

            let cityDetail: AirQualityGraphViewController = self.storyboard?.instantiateViewController(identifier: "AirQualityGraphViewController") as! AirQualityGraphViewController
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)

        }.disposed(by: self.disposeBag)

        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
}


//MARK: - UITableViewDelegate methods
extension AirQualityListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}
