//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/15.
//

import UIKit
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    // app啟動時,執行的第一個function。告訴delegate，啟動過程即將完成，應用程式幾乎可以執行。可以在這裡跟server拉資料更新使用者狀態或更新檔等。
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // apikeys使用了靜態屬性，故不需要建立實例，也就是不需要建立變數，可直接引用類型
        GMSPlacesClient.provideAPIKey(APIkeys.googlePlaceKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

