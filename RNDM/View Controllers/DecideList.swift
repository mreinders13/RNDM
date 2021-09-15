//
//  DecideList.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit


class DecideList: UIViewController {
    // outlets
    @IBOutlet weak var lblObjectTitle: UILabel!
    @IBOutlet weak var lblObjectResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let series = TVObject {
            lblObjectTitle.text = series.title.description
            getRandomEpisode(tvSeries: series)
        } else if let RNDMlist = ListObject {
            lblObjectTitle.text = RNDMlist.title.description
            getRandomItem(list: RNDMlist)
        } else {
            // shit happens
        }
        //let currentList = loadList()
        //lblListTitle.text = currentList.title
        // Do any additional setup after loading the view.
    }
    
    // MARK: RNDM LIST ITEM
    func getRandomItem(list:standardList) {
        if list != nil {
            let result = Int.random(in: 0..<list.items.count)
            DispatchQueue.main.async {
                self.lblObjectResult.text = list.items[result]
            }
        } else {
            print("Error decoding standardList")
        }
    }
    // MARK: RNDM TV SERIES
    func getRandomEpisode(tvSeries:Series) {
        // Try Loading Series
        if tvSeries != nil {
            // get random season
            let season = Int.random(in: 1..<tvSeries.seasonsCount)
            // get random episode
            let episode = Int.random(in: 1..<tvSeries.seasons[season].episodeCount)
            // set Labels
            DispatchQueue.main.async {
                self.lblObjectResult.text = "Season " + String(season) + ": Episode " + String(episode)
            }
        } else {
            print("Error decoding TV Series")
        }
        
    }
    
    @IBAction func btnRNDM(_ sender: Any) {
        //getRandomItem(list: loadList())
    }
    
    @IBAction func btnBack(_ sender: Any) {
        // unwind to MainMenu
        self.performSegue(withIdentifier: "DecideListTOMainMenu", sender: self)
    }
    

}
