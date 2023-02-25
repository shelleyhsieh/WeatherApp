//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by shelley on 2023/2/15.
//

import UIKit
import GooglePlaces

// 使用forcastDetail

class LocationListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarBtn: UIBarButtonItem!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    
    var weatherLocations: [WeatherLocation] = []
    var seletedLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //UserDefault是一個用來將資料儲存為 key-value 格式的類別，這個類別會將資料儲存成檔案並放在 Library/Preferences 目錄下，副檔名為 plist，使用於簡易儲存
    func saveLocation(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.set(encoded, forKey: "weatherLocations") //forKey就是這筆資料的名稱，資料型態就限定為String
        } else {
            print("😡 ERROR: saving encode didnt work!")
        }
    }
    
    // 將UserDefaults儲存的資料，傳至tableview上進行讀取
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        seletedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocation()
    }
    

    @IBAction func editBarBtnPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarBtn.isEnabled = true
            
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarBtn.isEnabled = false
        }
    }
    
    //複製 place autocomplete的code
    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self

            // Display the autocomplete view controller.
            present(autocompleteController, animated: true, completion: nil)
    }
    
   
}
//MARK: - display location list on table view
extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "經度：\(weatherLocations[indexPath.row].latitude), 緯度：\(weatherLocations[indexPath.row].longitude)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade) //swipe left
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]  //move from source
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row) //move to destination
        
    }
    //MARK: - freeze first cell
    // 預防第一個被刪掉
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // return true 則可以編輯這一行
        return indexPath.row != 0 ? true : false
    }
    // 預防移動到第一個
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        //與canEditRowAt回傳相同的結果，表示不能移動indexPath.row
        return indexPath.row != 0 ? true : false
    }
    
    //將某些內容移到建議的IndexPath.row，若等於0 則返回到原本的地方，若不等於0則移動到目標的IndexPath
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }

    
}

// MARK: - location from google place autocomplete
extension LocationListViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      
      let newLocation = WeatherLocation(name: place.name ?? "unknow place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
      weatherLocations.append(newLocation)
      tableView.reloadData()
      dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
    
}
