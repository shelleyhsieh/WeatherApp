//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/16.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("📅")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d"
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
    
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateUI()
        
    }
    
    func clearUI () {
        dateLable.text = ""
        placeLable.text = ""
        temperatureLable.text = ""
        summaryLable.text = ""
        imageView.image = UIImage()
    }
    

    func updateUI () {
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        let weatherLocation = pageViewController.weatherLocations[locationIndex]
        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
        
        weatherDetail.getData {
            DispatchQueue.main.async {
                dateFormatter.timeZone = TimeZone(secondsFromGMT: self.weatherDetail.timezone)
                let usebleDate = Date(timeIntervalSince1970: self.weatherDetail.currentTime)
                
                self.dateLable.text = "\(self.weatherDetail.currentTime)"
                self.placeLable.text = self.weatherDetail.name
                self.temperatureLable.text = "\(self.weatherDetail.tempature)º"
                self.summaryLable.text = self.weatherDetail.summary
                self.imageView.image = UIImage(named: self.weatherDetail.dailyIcon)
                
            }
        }
        
        forcastDetail.getForcastData {
                self.tableView.reloadData()

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    //顯示add location後的資訊
    @IBAction func unwindFromLocaionListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        locationIndex = source.seletedLocationIndex
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false, completion: nil)
        
        updateUI()
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
    }
    
    func timeFormatter(to date: Date?) -> String {
        guard let inputData = date else { return "" }
        let formatter = DateFormatter()
        let timezone = weatherDetail.timezone
        formatter.timeZone = TimeZone(secondsFromGMT: timezone)
        formatter.dateFormat = "MM/dd E h:mm a"
        return formatter.string(from: inputData)
    }
}

// MARK: - 5 day / 3 hour forecast data display in table view
extension LocationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("👉\(forcastDetail.daysForcastData.count)")
        return forcastDetail.daysForcastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FiveDaysTableViewCell
        
        cell.daysForcast = forcastDetail.daysForcastData[indexPath.row]
        print("👉\(forcastDetail.daysForcastData[indexPath.row])")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
