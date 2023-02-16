//
//  LocationDetailViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/16.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var placeLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var summaryLable: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var weatherLocation: WeatherLocation!
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadLocations()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
//    func loadLocations() { //移到pagecontroller
//        guard let locationEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
//            print("⚠️ waring")
//            return
//        }
//
//        let decoder = JSONDecoder()
//        if let weatherLocations = try? decoder.decode(Array.self, from: locationEncoded) as [WeatherLocation] {
//            self.weatherLocations = weatherLocations
//        } else {
//            print("😡 Error: couldnt decoede data read from userdefault")
//        }
//    }
    

    func updateUI () {
        
        let pageViewController = UIApplication.shared.windows.first?.rootViewController as! PageViewController
        weatherLocation = pageViewController.weatherLocations[locationIndex]
        
        dateLable.text = ""
        placeLable.text = weatherLocation.name
        temperatureLable.text = "--°"
        summaryLable.text = ""
        
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

}
