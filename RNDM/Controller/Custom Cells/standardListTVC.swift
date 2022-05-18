//
//  standardListTVC.swift
//  RNDM
//
//  Created by Michael Reinders on 1/30/21.
//

import UIKit

protocol UpdateListItemDelegate {
    func editListItem(index:Int, item:String)
}

class standardListTVC: UITableViewCell {
    // outlets
    @IBOutlet weak var lblListItem: UITextField!
    
    // count placeholder
    var itemIndex: Int?
    var delegate: UpdateListItemDelegate?
    
    // set cell
    func setCell(index:Int, item:String) {
        itemIndex = index
        lblListItem.text = item
    }
    
    // handle text input
    @IBAction func txtListItem(_ sender: UITextField) {
        if itemIndex != nil && lblListItem.text != "" {
            delegate?.editListItem(index: itemIndex!, item: lblListItem.text!) 
        }
    }

}
