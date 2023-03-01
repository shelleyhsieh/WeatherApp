//
//  PageViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/16.
//

import UIKit

class PageViewController: UIPageViewController {
    
    // 建立變數以儲存地理位置的array
    var weatherLocations: [WeatherLocation] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadLocations()
        
        //設定 pageViewControoler 的首頁，先傳入頁碼第一頁，及後續處理左滑及右滑的功能
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)

        setview
    }
    
    func loadLocations() {
        //forKey就是這筆資料的名稱，資料型態就限定為String ，轉型為Data
        guard let locationEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("⚠️ waring")
            
            //TODO: 取得用戶的第一筆位置
            //weatherLocations.append(WeatherLocation(name: "最近地點", latitude: 00.00, longitude: 00.00))
            return
        }
        
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("😡 Error: 無法從UserDefaults取得解碼資料")
        }
        if weatherLocations.isEmpty {
            //TODO: 加入最近的地點，模擬器內建是蘋果總部位置
            weatherLocations.append(WeatherLocation(name: "最近地點", latitude: 00.00, longitude: 00.00))
        }
    }
        
    //  傳遞 page的index到LocationDetailViewController，以顯示該位置的名稱
    func createLocationDetailViewController (forPage page: Int) -> LocationDetailViewController {
        
        // 須建立storyboard ID 以用來初始化
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
        
    }


}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    //向左滑(上一頁)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1 )
            }
        }
        return nil
    }
    
    //向右滑(下一頁)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 { //是否為最後一頁
                return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1 )
            }
        }
        return nil
    }
    
    
}
