//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/16.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    print("📅")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter
}()

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var placeLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var summaryLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    
    //    var weatherLocation: WeatherLocation!
    var weatherDetail: WeatherDetail! //近期天氣json存放的位置
    var forcastDetail: ForcastDetail! //五天預報json存放的位置
    
    var locationManager: CLLocationManager!
    
    // 儲存pageViewController傳過來的值
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 裝置中的其他位置是使用google place選擇的位置，若需要取得位置locationIndex 查看位置
        // 當locationIndex等於0時，第一次開啟app時，啟動getLocation來取得位置
        if locationIndex == 0 {
            getLocation()
            
            print("📍")
        }
        
        updateUI()
        
    }

    func updateUI () {
         
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        //在目前位置取得locationIndex
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        
        // 經緯度儲存到weatherDetail
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        // 建立pageControl的數量 及 當前頁面為locationIndex
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        
        weatherDetail.getData {
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(secondsFromGMT: self.weatherDetail.timezone)
                let usebleDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                
                self.dateLable.text = dateFormatter.string(from: usebleDate)
                self.placeLable.text = self.weatherDetail.name
                self.temperatureLable.text = "\(self.tempFormate(ºC: self.weatherDetail.tempature) )º"
                self.summaryLable.text = self.weatherDetail.summary
                self.imageView.image = UIImage(named: self.weatherDetail.dailyIcon)
                
            }
        }
        
        forcastDetail = ForcastDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        
        forcastDetail.getForcastData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tempFormate(ºC f: Double) -> String {
// ºC = (ºF - 32 ) x 5 / 9
        let c = (f - 32) * 5 / 9
        let tempString = String(format: "%.0f", c)
        return tempString
    }
    
    // MARK: - segue value display on view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationList" {
            let destination = segue.destination as! LocationListViewController
            let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
            destination.weatherLocations = pageViewController.weatherLocations
        }
    }
    
    //顯示add location後的資訊
    @IBAction func unwindFromLocaionListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        locationIndex = source.seletedLocationIndex //將用戶選到的位置存回locationIndex
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        pageViewController.weatherLocations = source.weatherLocations
        
        // 將用戶選到的locationIndex顯示在畫面中
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
        
        updateUI()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward //下一頁
        
        if sender.currentPage < locationIndex {
            direction = .reverse //前一頁
        }
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
    }
    
}

// MARK: - 5 day / 3 hour forecast data display in table view
extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("👉\(forcastDetail.daysForcastData.count)")
        return forcastDetail.daysForcastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FiveDaysTableViewCell
        
        cell.daysForcast = forcastDetail.daysForcastData[indexPath.row]
//        print("👉\(forcastDetail.daysForcastData[indexPath.row])")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
//MARK: - get location
extension LocationDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        // 初始化locationManager，委託給CLLocationManager，確認用戶使否授權位置服務
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // 告訴delegate裝置的授權狀態，當建立位置管理器 及 授權狀態改變時
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("👮‍♀️確認授權狀態")
        handleAuthenticalStatus(status: status)
    }
    
    // 第一次啟動app，詢問是否允許使用位置服務
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() //使用app期間允許使用位置服務
        case .restricted:
            oneBtnAlert(title: "不允許使用定位服務", message: "若要開啟定位服務請前往設定")
        case .denied: // 是否改變授權
//            showAlertToPrivacySettings(title: "使用者無授權定位服務", message: "請至設定>隱私權與安全性>定位服務")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation() //允許一次最近位置
        @unknown default:
            print("😡未知狀態\(status)")
        }
    }
    
    // 若無授權定位服務則跳出提醒，跳轉至設定修改授權
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {
            print("😡設定位置錯誤")
            return
        }
        let settingAction = UIAlertAction(title: "設定", style: .default) { (_) in
            UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //TODO: 當新的位置出現時，告訴代理人可以開始更新地點了
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update location")
        
        //儲存當目前位置等於array中的最後一筆，因last為optional 若不幸回傳nil，則傳入一個零座標的位置
        let currentLocation = locations.last ?? CLLocation()
        print("當前位置是\(currentLocation.coordinate.latitude)、\(currentLocation.coordinate.longitude)")
    }
    
    //TODO: 無法搜尋位置時的錯誤處理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌\(error)")
    }
}
