//
//  DecideList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit
import GoogleMobileAds

class DecideList: UIViewController, GADFullScreenContentDelegate {
    // AdMob
    var interstitial: GADInterstitialAd?
    // outlets
    @IBOutlet weak var lblObjectTitle: UILabel!
    @IBOutlet weak var lblObjectResult: UILabel!
    
    var lastListResult = ""
    var lastSeason = 0
    var lastEpisode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        randomize()
        prepAd()
    }
    
    func prepAd() {
        // prepare GoogleAdMob
        let request = GADRequest()
        let intAdID = "ca-app-pub-9005398148958740/3951621321"
        GADInterstitialAd.load(withAdUnitID: intAdID, request: request, completionHandler: {ad, error in
            if let err = error {
                print("Failed to load interstitial ad with error: " + err.localizedDescription)
            }
            if let a = ad {
                self.interstitial = a
                self.interstitial?.fullScreenContentDelegate = self
            }
        })
    }
    
    // MARK: RNDM LIST ITEM
    func getRandomItem(list:standardList) {
        let result = Int.random(in: 0..<list.items.count)
        if list.items[result] == lastListResult {
            getRandomItem(list: list)
        } else {
            lastListResult = list.items[result]
            DispatchQueue.main.async {
                self.lblObjectResult.text = list.items[result]
            }
        }

    }
    // MARK: RNDM TV SERIES
    func getRandomEpisode(tvSeries:Series) {
        // get random season
        let season = Int.random(in: 1..<tvSeries.seasonsCount)
        // get random episode
        let episode = Int.random(in: 1..<tvSeries.seasons[season].episodeCount)
        // ensure no duplicate
        if season == lastSeason && episode == lastEpisode {
            getRandomEpisode(tvSeries: tvSeries)
        } else {
            // set variables
            lastSeason = season
            lastEpisode = episode
            DispatchQueue.main.async {
                self.lblObjectResult.text = "Season " + String(season) + ": Episode " + String(episode)
            }
        }
    }
    
    func randomize() {
        if let series = TVObject {
            lblObjectTitle.text = series.title.description
            getRandomEpisode(tvSeries: series)
        } else if let RNDMlist = ListObject {
            lblObjectTitle.text = RNDMlist.title.description
            getRandomItem(list: RNDMlist)
        } else {
            // shit happens
        }
    }
    
    @IBAction func btnRNDM(_ sender: Any) {
        // load interstital ad
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        }
        // randomize() <-put that in adDidShow
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
          prepAd()
          randomize()
      }
    

}
