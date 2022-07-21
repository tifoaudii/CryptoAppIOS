//
//  TopListCoinListener.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 18/07/22.
//

import Foundation

struct SubRequest: Encodable {
    let action = "SubAdd"
    let subs: [String]
}

protocol LiveCoinListener: AnyObject {
    var newData: ((_ price: Double, _ fromSymbol: String) -> Void)? { set get }
    
    func connect()
    func send(_ symbols: [String])
    func onListen()
    func cancel()
    func resume()
}

final class TopListCoinListener: NSObject {
    
    private let sessionConfiguration: URLSessionConfiguration
    private let streamURL: URL
    
    var newData: ((Double, String) -> Void)?

    private var socket: URLSessionWebSocketTask?
    
    private lazy var session: URLSession = {
        let urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .init())
        return urlSession
    }()
    
    init(sessionConfiguration: URLSessionConfiguration, streamUrl: URL) {
        self.sessionConfiguration = sessionConfiguration
        self.streamURL = streamUrl
        super.init()
        socket = session.webSocketTask(with: streamURL)
    }
}

extension TopListCoinListener: LiveCoinListener {
    
    func connect() {
        socket?.resume()
    }
    
    func resume() {
        socket = session.webSocketTask(with: streamURL)
        socket?.resume()
    }
    
    func cancel() {
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
    }
    
    func send(_ symbols: [String]) {
        let request = SubRequest(subs: symbols)
        guard let data = try? JSONEncoder().encode(request) else {
            return
        }
                
        socket?.send(.data(data)) { (error: Error?) in
            guard error == nil else {
                return
            }
        }
    }
    
    func onListen() {
        socket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let data):
                    guard let json = try? JSONSerialization.jsonObject(with: .init(data.utf8)) as? [String : Any] else {
                        self?.onListen()
                        return
                    }
                    
                    print(json)
                    
                    guard let typeString = json["TYPE"] as? NSString else {
                        self?.onListen()
                        return
                    }
                    
                    if typeString.integerValue == 2 {
                        guard let newPrice = json["PRICE"] as? Double, let symbol = json["FROMSYMBOL"] as? String else {
                            self?.onListen()
                            return
                        }
                        
                        self?.newData?(newPrice, symbol)
                    }
                default:
                    self?.onListen()
                }
                
            case .failure(let error):
                print(error)
            }
            
            self?.onListen()
        })
    }
}

extension TopListCoinListener: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {}
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {}
}


