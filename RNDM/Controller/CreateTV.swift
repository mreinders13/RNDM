//
//  CreateTV.swift
//  RNDM
//
//  Created by Michael Reinders on 1/18/21.
//

import Foundation
import UIKit
import GoogleMobileAds

class CreateTV: UIViewController, UITableViewDataSource, UITextFieldDelegate, GADFullScreenContentDelegate, UpdateEpisodesDelegate {
    
    func updateEpisodeForSeason(season: Int, episodes: Int) {
        tvSeriesBrain.editEpisodeCount(season: season, episodes: episodes)
    }
    
    // AdMob
    var interstitial: GADInterstitialAd?
    // UI Outlets
    @IBOutlet weak var txtSeriesName: UITextField!
    
    @IBOutlet weak var txtNumbnerOfSeasons: UITextField!
    
    var tvSeriesBrain = TvSeriesBrain()
    
    // MARK: Create TableView
    @IBOutlet weak var tableView: UITableView!
    
    // TableView Setup - # Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvSeriesBrain.createSeriesArray.count
    }
    // TableView Setup - Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tvSeriesBrain.createSeriesArray != [] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "createSeason") as? createSeasonTVC {
                // set cell
                cell.delegate = self
                cell.setCell(season: indexPath.row, episodes: tvSeriesBrain.createSeriesArray[indexPath.row])
                return cell
            }
            return UITableViewCell()
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: Textfield + Keyboard Controls
    // Keyboard Setup - Return Key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    // Keyboard Setup - Dismiss on Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSeriesName.delegate = self
        tableView.dataSource = self
        
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
          if let encoded = try? JSONEncoder().encode(savedTV) {
              UserDefaults.standard.set(encoded, forKey: "TV-Series-Array")
              // clear listArray
              tvSeriesBrain.createSeriesArray = []
              // reload tqbleview
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
              // Successful - Dismiss VC
              self.dismiss(animated: true, completion: nil)
          }
      }

    
    // MARK: Click Events
    @IBAction func createSeries(_ sender: Any) {
        // apply series name and season number to create classes
        if let seasons = txtNumbnerOfSeasons.text {
            tvSeriesBrain.createSeriesFromSeasons(seasons: Int(seasons)!)
            tableView.reloadData()
        } else {
            print("Error: Seasons not provided")
        }
    }
    
    @IBAction func saveSeries(_ sender: Any) {
        // Save series to CK
        print(txtSeriesName.text! + ": ")
        print(tvSeriesBrain.createSeriesArray)
        if let name = txtSeriesName.text {
            tvSeriesBrain.saveSeries(name: name)
        }

        // load interstital ad
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        }
        
    }
    
}
