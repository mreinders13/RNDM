//
//  CreateTV.swift
//  RNDM
//
//  Created by Michael Reinders on 1/18/21.
//

import Foundation
import UIKit
import GoogleMobileAds

// Global Var for createSeriesArray
var createSeriesArray: Array<Int> = []

// Global Structs for TV Series
struct Series: Codable {
    var title: String
    var seasonsCount: Int
    var totalEpisodes: Int
    var seasons: Array<Season>
    var plot: String?
    var image: URL?
    var premiere: Int?
    var finale: Int?
}

struct Season: Codable {
    var number: Int
    var episodeCount: Int
    var episodes: Array<Episode>
    var title: String?
    var year: String?
    var summary: String?
}

struct Episode: Codable {
    var number: Int
    var title: String?
    var summary: String?
    var image: URL?
    var runTime: String?
    var airDate: String?
}
class Create: UIViewController, UITableViewDataSource, UITextFieldDelegate, GADFullScreenContentDelegate {
    // UI Outlets
    @IBOutlet weak var txtSeriesName: UITextField!
    
    @IBOutlet weak var txtNumbnerOfSeasons: UITextField!
    
    // AdMob
    var interstitial: GADInterstitialAd?
    
    // MARK: Create TableView
    @IBOutlet weak var tableView: UITableView!
    
    // TableView Setup - # Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createSeriesArray.count
    }
    // TableView Setup - Cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if createSeriesArray != [] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "createSeason") as? createSeasonTVC {
                // set cell
                cell.setCell(season: indexPath.row, episodes: createSeriesArray[indexPath.row])
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

        // Do any additional setup after loading the view.
        // Conform to textField
        self.txtSeriesName.delegate = self
        
        // Conform to TableView
        //tableView.delegate = self
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
              createSeriesArray = []
              // reload tqbleview
              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
              // Successful - Dismiss VC
              self.dismiss(animated: true, completion: nil)
          }
      }

    
    // MARK: Click Events
    @IBAction func createSeries(_ sender: Any) {
        // apply series name and season number to create classes
        if txtNumbnerOfSeasons != nil  {
            // ensure start with fresh array
            createSeriesArray = []
            // setup table with params
            let seasons = Int(txtNumbnerOfSeasons.text!)
            for _ in 0..<seasons! {
                createSeriesArray.append(1)
            }
            print(createSeriesArray)
            tableView.reloadData()
        } else {
            print("Error: Seasons not provided")
        }
    }
    
    @IBAction func saveSeries(_ sender: Any) {
        // Save series to CK
        print(txtSeriesName.text! + ": ")
        print(createSeriesArray)
        
        
        // create seasons + episodes- loop
        var seasons: Array<Season> = []
        let seasonsCount = createSeriesArray.count
        var totalEpisodeCount = 0
        for season in 0..<seasonsCount {
            var episodes: Array<Episode> = []
            for episode in 0..<createSeriesArray[season] {
                // init the episode and add one to offset array starting at zero
                let e = Episode.init(number: episode + 1)
                episodes.append(e)
                // increment totalepisodecount
                totalEpisodeCount += 1
            }
            print("Season " + String(season + 1))
            let s = Season.init(number: season + 1, episodeCount: episodes.count, episodes: episodes)
            seasons.append(s)
        }
        
        // create and save to Defaults
        if let seriesName = txtSeriesName.text {
            let tvSeries = Series.init(title: seriesName, seasonsCount: seasons.count, totalEpisodes: totalEpisodeCount, seasons: seasons)
            savedTV.append(tvSeries)
            // load interstital ad
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            }
        }
        
    }
    
}
