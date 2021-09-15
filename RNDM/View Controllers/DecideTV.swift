//
//  DecideTV.swift
//  RNDM
//
//  Created by Michael Reinders on 1/24/21.
//

import UIKit

class Decide: UIViewController {
    // Outlets
    @IBOutlet weak var lblSeriesName: UILabel!
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Class Variables
        let series = loadTVSeries()
        
        DispatchQueue.main.async {
            self.lblSeriesName.text = series.title
            self.lblSeason.text = "Total Seasons: " + String(series.seasonsCount)
            self.lblEpisode.text = "Total Episodes: " + String(series.totalEpisodes)
        }
    }
    
    // load the series
    func loadTVSeries() -> Series {
        //Retrieving Series
        let series: Series?
        do {
            let storedObjItem = UserDefaults.standard.object(forKey: "TV-Series")
            let storedSeries = try JSONDecoder().decode(Series.self, from: storedObjItem as! Data)
            //print("Retrieved items: \(storedItems)")
             series = storedSeries
        } catch let err {
            print(err)
            series = nil
        }
        return series!
    }
    
    func getRandomEpisode(tvSeries:Series) {
        // Try Loading Series
        if tvSeries != nil {
            // get random season
            let season = Int.random(in: 1..<tvSeries.seasonsCount)
            // get random episode
            let episode = Int.random(in: 1..<tvSeries.seasons[season].episodeCount)
            // set Labels
            DispatchQueue.main.async {
                self.lblSeason.text = "Season " + String(season)
                self.lblEpisode.text = "Episode " + String(episode)
            }
        } else {
            print("Error decoding TV Series")
        }
        
    }
    
    
    @IBAction func RNDM(_ sender: Any) {
        getRandomEpisode(tvSeries: loadTVSeries())
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        // unwind to MainMenu
        self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
    }
    
}
