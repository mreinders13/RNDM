//
//  CreateTV.swift
//  RNDM
//
//  Created by Michael Reinders on 1/18/21.
//

import Foundation
import UIKit

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
class Create: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    // UI Outlets
    @IBOutlet weak var txtSeriesName: UITextField!
    
    @IBOutlet weak var txtNumbnerOfSeasons: UITextField!
    

    
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
        
        // check if previous series exists
        if createSeriesArray != [] {
            // Check for savedSeries
            let series: Series?
            var alert = "Are you sure you want to save?"
            do {
                let storedObjItem = UserDefaults.standard.object(forKey: "TV-Series")
                let storedSeries = try JSONDecoder().decode(Series.self, from: storedObjItem as! Data)
                //print("Retrieved items: \(storedItems)")
                series = storedSeries
                alert.append("\nWarning: This will overwrite '")
                alert.append(series!.title + "'")
            } catch {
                // nothing
            }
            let dialogMessage = UIAlertController(title: "Confirm", message: alert, preferredStyle: .alert)
            // Create Save/Cancel
            let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
                print("Save button tapped")
                createSeries()
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
                return
            }
            //Add Save and Cancel button to an Alert object
            dialogMessage.addAction(save)
            dialogMessage.addAction(cancel)

            // Present alert message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        func createSeries() {
            // create series
            if let seriesName = txtSeriesName.text {
                let tvSeries = Series.init(title: seriesName, seasonsCount: seasons.count, totalEpisodes: totalEpisodeCount, seasons: seasons)
                
                // Save the Series
                if let encoded = try? JSONEncoder().encode(tvSeries) {
                    UserDefaults.standard.set(encoded, forKey: "TV-Series")
                    
                    // Successful - Unwind to MainMenu
                    clearAndUnwind()
                
                } else {
                    print("Error Saving TV Series: Could NOT Encode TV-Series")
                }
            }
            
        }
    }
    
    func clearAndUnwind() {
        // Clear the global array
        createSeriesArray = []
        // unwind to MainMenu
        self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        // unwind
        clearAndUnwind()
    }
    
}
