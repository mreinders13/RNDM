//
//  menu.swift
//  Menu View Controller
//
//  Created by Michael Reinders on 9/11/21.
//

import UIKit
import GoogleMobileAds

var savedLists: Array<standardList> = []
var savedTV: Array<Series> = []

class Menu: UIViewController, UITableViewDataSource {
    
    @objc func reloadRandomTableView(notification: NSNotification) {
        loadLocalData()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    
    @IBAction func typeSwitcherAction(_ sender: Any) {
        tableView.reloadData()
    }
    // MARK: TableView Setup
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch typeSwitch.selectedSegmentIndex {
        case 1: count = savedTV.count
        default: count = savedLists.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "randomCell") as! randomCell
        switch typeSwitch.selectedSegmentIndex {
        case 1: cell.setCell(name: savedTV[indexPath.row].title,type:"TV",index:indexPath.row)
        default: cell.setCell(name: savedLists[indexPath.row].title,type:"List",index:indexPath.row)
        }
        return cell
    }
    
    // MARK: Swipe to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // delete your item here and reload table view
                switch typeSwitch.selectedSegmentIndex {
                case 0: savedLists.remove(at: indexPath.row)
                    if let encoded = try? JSONEncoder().encode(savedLists) {
                        UserDefaults.standard.set(encoded, forKey: "Standard-Lists-Array")
                    }
                case 1: savedTV.remove(at: indexPath.row)
                    if let encoded = try? JSONEncoder().encode(savedTV) {
                        UserDefaults.standard.set(encoded, forKey: "TV-Series-Array")
                    }
                default: print("Switcher seelcted index error")
                }
                tableView.reloadData()
            }
    }
    
    // MARK: Load Defaults for Lists and TV
    func loadLocalData() {
        let d = UserDefaults.standard
        if let arr = d.object(forKey: "Standard-Lists-Array") {
            do {
                savedLists = try JSONDecoder().decode(Array<standardList>.self, from: arr as! Data)
            }
            catch let err {
                print(err)
            }
        }
        if let tv = d.object(forKey: "TV-Series-Array") {
            do {
                savedTV = try JSONDecoder().decode(Array<Series>.self, from: tv as! Data)
            }
            catch let err {
                print(err)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadLocalData()
        tableView.dataSource = self

        // listener for search refresh
        NotificationCenter.default.addObserver(self, selector:#selector(reloadRandomTableView), name:NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil) 
    }
}
