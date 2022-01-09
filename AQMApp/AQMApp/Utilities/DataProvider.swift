//
//  DataProvider.swift
//  AQMApp
//
//  Created by prakhar gupta on 09/01/22.
//

import Foundation
import Starscream

protocol DataProviderDelegate
{
    func didReceive(response: Result<[AirQualityResponseModel], Error>)
}

///
/// Provide a data by using socket connection.
///
class DataProvider
{
	///
	/// A constants
	///
	private enum Constants
	{
		static var url: String = "ws://city-ws.herokuapp.com"
	}

	/// A socket is connected or not.
    var isConnected: Bool = false

    var delegate: DataProviderDelegate?

    var socket: WebSocket? = {
        guard let url = URL(string: Constants.url) else {
            print("can not create URL from: \(Constants.url)")
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        var socket = WebSocket(request: request)
        return socket
    }()

	///
	/// Subscribe the socket.
	///
    func subscribe()
    {
        self.socket?.delegate = self
        self.socket?.connect()
    }

	///
	/// UnSubscribe the socket.
	///
    func unsubscribe()
    {
        self.socket?.disconnect()
    }

    deinit
    {
        self.socket?.disconnect()
        self.socket = nil
    }

}


//MARK: - Helper methods
extension DataProvider
{
	///
	/// Handling the text and decode it.
	///
    private func handleText(text: String)
    {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do
        {
            let resArray = try decoder.decode([AirQualityResponseModel].self, from: jsonData)
            self.delegate?.didReceive(response: .success(resArray))

        }
        catch
        {
            print(error.localizedDescription)
        }
    }

	///
	/// Handling the error.
	///
    private func handleError(error: Error?)
    {
        if let err = error
        {
            self.delegate?.didReceive(response: .failure(err))
        }
    }
}


//MARK: - WebSocket Delegates methods
extension DataProvider: WebSocketDelegate
{
    func didReceive(event: WebSocketEvent, client: WebSocket)
    {
        switch event
        {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                handleText(text: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error: error)
		}
    }
}
