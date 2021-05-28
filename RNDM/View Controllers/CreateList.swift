//
//  CreateList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit

var listArray: Array<String> = []

// Struct
struct standardList: Codable {
    let title: String
    let items: Array<String>
}

class CreateList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UITextField!
    
    
    // MARK: TableView Setup
    func setupTable() {
        //tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standardList", for: indexPath) as! standardListTVC
        cell.setCell(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: standardListTVC.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: Keyboard Setup - Dismiss on Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTable()
    }
    

    // MARK: Events
    @IBAction func btnAddItem(_ sender: Any) {
        listArray.append("")
        tableView.reloadData()
        print(listArray.count)
    }
    
    @IBAction func saveList(_ sender: Any) {
        if let title = lblTitle.text {
            let List = standardList.init(title: title, items: listArray)
            print(List.title)
            print(List.items)
            // Save List
            if let encoded = try? JSONEncoder().encode(List) {
                UserDefaults.standard.set(encoded, forKey: "Standard-List")
                // Successful - Unwind to MainMenu
                clearAndUnwind()
            }
        }
    }
    
    func clearAndUnwind() {
        // Clear the Global Array
        listArray = []
        // Unwind to Main Menu
        self.performSegue(withIdentifier: "createListTOMainMenu", sender: self)
    }

}
