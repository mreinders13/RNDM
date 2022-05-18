//
//  randomCell.swift
//  randomCell
//
//  Created by Michael Reinders on 9/11/21.
//

import UIKit
import GoogleMobileAds

var TVObject: Series?
var ListObject: standardList?

class randomCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var randomType: UIImageView!
    
    var randomObjectType: String?
    var objectIndex: Int?
    
    func setCell(name:String, type:String, index:Int) {
        randomObjectType = type
        objectIndex = index
        if randomObjectType == "List" {
            randomType.image = UIImage(named: "list.bullet")
        }
        if randomObjectType == "TV" {
            randomType.image = UIImage(named: "tv")
            
        }
        self.lblTitle.text = name
        
    }
    
    @IBAction func btnRNDM(_ sender: Any) {
        if let ix = objectIndex {
            if randomObjectType == "TV" {
                TVObject = savedTV[ix]
                ListObject = nil
            } else {
                ListObject = savedLists[ix]
                TVObject = nil
            }
        }
        
    }
    
}
