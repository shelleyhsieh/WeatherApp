//
//  PageViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/16.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var weatherLocations: [WeatherLocation] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadLocations()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)

    }
    
    func loadLocations() {
        guard let locationEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("⚠️ waring")
            
            //TODO: 取得用戶的第一筆資料
            weatherLocations.append(WeatherLocation(name: "最近地點", latitude: 20.20, longitide: 20.20))
            return
        }
        
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("😡 Error: couldnt decoede data read from userdefault")
        }
        if weatherLocations.isEmpty {
            //TODO: 取得用戶的第一筆資料
            weatherLocations.append(WeatherLocation(name: "最近地點", latitude: 20.20, longitide: 20.20))
        }
    }
        
    
    func createLocationDetailViewController (forPage page: Int) -> LocationDetailViewController {
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
        
    }


}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex > 0 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1 )
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? LocationDetailViewController {
            if currentViewController.locationIndex < weatherLocations.count - 1 {
                return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1 )
            }
        }
        return nil
    }
    
    
}
