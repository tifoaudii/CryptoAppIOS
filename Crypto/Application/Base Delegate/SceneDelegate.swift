//
//  SceneDelegate.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 01/06/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        let service = CryptoService(dataStore: URLSessionDataStore())
        let presenter = DefaultTopListPresenter(service: service)
        let coinListener = TopListCoinListener(sessionConfiguration: .default, streamUrl: CoinData.streamURL)
        let viewController = DefaultTopListViewController(presenter: presenter, coinListener: coinListener)
        presenter.setViewController(viewController)
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

}

