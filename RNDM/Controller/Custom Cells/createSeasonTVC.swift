//
//  createSeasonTVC.swift
//  RNDM
//
//  Created by Michael Reinders on 5/18/22.
//

import UIKit

protocol UpdateEpisodesDelegate {
    func updateEpisodeForSeason(season: Int, episodes: Int)
}

class createSeasonTVC: UITableViewCell {
    // Class-level Variable
    var seasonNumber: Int?
    var delegate: UpdateEpisodesDelegate?
    // Outlets
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var txtEpisodes: UITextField!
    
    // Setup Cell
    func setCell(season: Int, episodes: Int) {
        // save season to class var
        seasonNumber = season
        let s = season + 1
        if s < 10 {
            lblSeason.text = "Season 0" + String(s) + ": # of Episodes?"
        } else {
            lblSeason.text = "Season " + String(s) + ": # of Episodes?"
        }
        txtEpisodes.text = String(episodes)
    }

    // Editing Changed
    @IBAction func editingChanged(_ sender: UITextField) {
        if var count = txtEpisodes.text {
            if seasonNumber != nil {
                if count.isEmpty {
                    count = String(1)
                }
                delegate?.updateEpisodeForSeason(season: seasonNumber!, episodes: Int(count)!)
            }
        }
    }
    }
