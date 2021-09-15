//
//  DecideList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit


class DecideList: UIViewController {
    // outlets
    @IBOutlet weak var lblListTitle: UILabel!
    @IBOutlet weak var lblListResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentList = loadList()
        lblListTitle.text = currentList.title
        // Do any additional setup after loading the view.
    }
    
    // Load stored list from Defaults
    func loadList() -> standardList {
        //Retrieving Series
        let list: standardList?
        do {
            let storedObjItem = UserDefaults.standard.object(forKey: "Standard-Lists-Array")
            let storedList = try JSONDecoder().decode(standardList.self, from: storedObjItem as! Data)
            //print("Retrieved items: \(storedItems)")
             list = storedList
        } catch let err {
            print(err)
            list = nil
        }
        return list!
    }
    
    func getRandomItem(list:standardList) {
        if list != nil {
            let result = Int.random(in: 0..<list.items.count)
            DispatchQueue.main.async {
                self.lblListResult.text = list.items[result]
            }
        } else {
            print("Error decoding standardList")
        }
    }
    
    @IBAction func btnRNDM(_ sender: Any) {
        getRandomItem(list: loadList())
    }
    
    @IBAction func btnBack(_ sender: Any) {
        // unwind to MainMenu
        self.performSegue(withIdentifier: "DecideListTOMainMenu", sender: self)
    }
    

}
