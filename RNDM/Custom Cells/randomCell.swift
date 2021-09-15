//
//  randomCell.swift
//  randomCell
//
//  Created by Michael Reinders on 9/11/21.
//

import UIKit

var TVObject: Series?
var ListObject: standardList?

class randomCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var randomType: UIImageView!
    
    var randomObjectType: String?
    var objectIndex: Int?
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
    }
    
    func setCell(name:String, type:String, index:Int) {
        randomObjectType = type
        objectIndex = index
        let list = UIImage(named: "list.bullet")
        let tv = UIImage(named: "tv")
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
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if randomObjectType == "TV" {
            // open edit/rndm view with TV object
            //performSegue(withIdentifier: "addObjectSegue", sender: <#T##Any?#>)
        } else {
            // open edit/rndm view with List Object
        }
    }

}
