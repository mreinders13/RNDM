//
//  createSeasonTVC.swift
//  RNDM
//
//  Created by Michael Reinders on 1/22/21.
//

import UIKit

class createSeasonTVC: UITableViewCell {

    // Class-level Variable
    var seasonNumber: Int?
    

    
    // Outlets
    @IBOutlet weak var lblSeason: UILabel!
    @IBOutlet weak var txtEpisodes: UITextField!
    
    
    // Editing Changed
    @IBAction func editingChanged(_ sender: UITextField) {
        if var count = txtEpisodes.text {
            if seasonNumber != nil {
                if count.isEmpty {
                    count = String(1)
                }
                createSeriesArray[seasonNumber!] = Int(count)!
                print(createSeriesArray)
            }
        }
    }
    
    
    // Setup Cell
    func setCell(season: Int, episodes: Int) {
        // save season to class var
        seasonNumber = season
        // Add 1 to Season because array starts at 0
        let s = season + 1
        // Set label and texbox to season
        if s < 10 {
            lblSeason.text = "Season 0" + String(s) + ": # of Episodes?"
        } else {
            lblSeason.text = "Season " + String(s) + ": # of Episodes?"
        }
        txtEpisodes.text = String(episodes)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
