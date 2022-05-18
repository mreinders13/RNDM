//
//  DecideList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit
import GoogleMobileAds

let AdMobInterstitialTestID = "ca-app-pub-3940256099942544/4411468910"

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
    func setRandomListItem(list:standardList) {
        let random = list.items.randomElement()
        if random == lastListResult && list.items.count > 1 {
            setRandomListItem(list: list)
        } else {
            lastListResult = random!
            DispatchQueue.main.async {
                self.lblObjectResult.text = random
            }
        }

    }
    // MARK: RNDM TV SERIES
    func setRandomEpisode(randomEpisode:RandomEpisode) {
        if randomEpisode.season == lastSeason && randomEpisode.episode == lastEpisode {
            setRandomEpisode(randomEpisode: (TVObject?.getRandomEpisode())!)
        } else {
            lastSeason = randomEpisode.season
            lastEpisode = randomEpisode.episode
            DispatchQueue.main.async {
                self.lblObjectResult.text = "Season " + String(randomEpisode.season) + ": Episode " + String(randomEpisode.episode)
            }
        }
    }
    
    func randomize() {
        if let series = TVObject {
            lblObjectTitle.text = series.title.description
            setRandomEpisode(randomEpisode: (TVObject?.getRandomEpisode())!)
        } else if let RNDMlist = ListObject {
            lblObjectTitle.text = RNDMlist.title.description
            setRandomListItem(list: RNDMlist)
        } else {
            // error
        }
    }
    
    @IBAction func btnRNDM(_ sender: Any) {
        // load interstital ad
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
            let alert = UIAlertController(title: "No Ads", message: "No Ad was loaded from the server, Enjoy the freebie!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                self.prepAd()
                self.randomize()
            }))
            self.present(alert, animated: true, completion: nil)
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
