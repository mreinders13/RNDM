//
//  CreateList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//
import UIKit
import GoogleMobileAds

var listArray: Array<String> = []

// Struct
struct standardList: Codable {
    let title: String
    let items: Array<String>
}

class CreateList: UIViewController, UITableViewDelegate, UITableViewDataSource, GADFullScreenContentDelegate {
    
    // AdMob
    var interstitial: GADInterstitialAd?
    
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
        
        // setup GoogleAdMob
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request, completionHandler: {ad, error in
            if let err = error {
                print("Failed to load interstitial ad with error: " + err.localizedDescription)
            }
            if let a = ad {
                self.interstitial = ad
                self.interstitial?.fullScreenContentDelegate = self
            }
            
        })
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
      }

      /// Tells the delegate that the ad presented full screen content.
      func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
      }

      /// Tells the delegate that the ad dismissed full screen content.
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
          // Save List
          if let encoded = try? JSONEncoder().encode(savedLists) {
              UserDefaults.standard.set(encoded, forKey: "Standard-Lists-Array")
              // clear listArray
              listArray = []
              // Successful - Dismiss VC
              self.dismiss(animated: true, completion: nil)
          }
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
            savedLists.append(List)
            print(List.title)
            print(List.items)
            // load interstital ad
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            }
        }
        
        
    }

}
