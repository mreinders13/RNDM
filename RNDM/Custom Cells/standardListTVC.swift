//
//  standardListTVC.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit

class standardListTVC: UITableViewCell {
    // outlets
    @IBOutlet weak var lblListItem: UITextField!
    
    // count placeholder
    var itemIndex: Int?
    
    // set cell
    func setCell(index:Int) {
        itemIndex = index
        if listArray[index] != "" {
            lblListItem.text = listArray[index]
        }
    }
    
    // handle text input
    @IBAction func txtListItem(_ sender: UITextField) {
        if itemIndex != nil && lblListItem.text != "" {
            listArray[itemIndex!] = lblListItem.text!
        }
    }
    
    @IBAction func btnDeleteItem(_ sender: Any) {
        /*if let index = itemIndex {
            listArray.remove(at: index)
            print(listArray)
            // Reload Data 
            
        }*/
        print("Need to configure DELETE")
        
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
