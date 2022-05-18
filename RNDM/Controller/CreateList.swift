//
//  CreateList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//
import UIKit
import GoogleMobileAds

class CreateList: UIViewController, UITableViewDelegate, UITableViewDataSource, GADFullScreenContentDelegate, UpdateListItemDelegate {
    func editListItem(index: Int, item: String) {
        listBrain.listArray[index] = item
    }
    

    var interstitial: GADInterstitialAd?    // AdMob
    var listBrain = ListBrain()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UITextField!
    
    
    // MARK: TableView Setup
    func setupTable() {
        //tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBrain.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standardList", for: indexPath) as! standardListTVC
        cell.delegate = self
        cell.setCell(index: indexPath.row, item: listBrain.listArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: standardListTVC.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listBrain.listArray.remove(at: indexPath.row)
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
        let intAdID = "ca-app-pub-9005398148958740/2625539708"
        GADInterstitialAd.load(withAdUnitID: intAdID, request: request, completionHandler: {ad, error in
            if let err = error {
                print("Failed to load interstitial ad with error: " + err.localizedDescription)
                // MARK: Handle no ad loaded here
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
          listBrain.saveList()
          // reload tableview
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
          // Successful - Dismiss VC
          self.dismiss(animated: true, completion: nil)
      }

    // MARK: Events
    @IBAction func btnAddItem(_ sender: Any) {
        listBrain.listArray.append("")
        tableView.reloadData()
        print(listBrain.listArray.count)
    }
    
    @IBAction func saveList(_ sender: Any) {
        if let title = lblTitle.text {
            listBrain.createList(name: title)
            // load interstital ad
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            } else {
                let alert = UIAlertController(title: "No Ads", message: "No Ad was loaded from the server, Enjoy the freebie!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {action in
                    self.listBrain.saveList()
                    // reload tableview
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
                    // Successful - Dismiss VC
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
    }

}
