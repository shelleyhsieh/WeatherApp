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
    
    func saveLocation(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        } else {
            print("😡 ERROR: saving encode didnt work!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        seletedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocation()
    }
    
// 複製todolist
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
    
}

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
