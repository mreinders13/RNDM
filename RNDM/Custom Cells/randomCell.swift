//
//  randomCell.swift
//  randomCell
//
//  Created by Michael Reinders on 9/11/21.
//

import UIKit

class randomCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var randomType: UIImageView!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
    }
    
    func setCell(name:String) {
        let list = UIImage(named: "list.bullet")
        let tv = UIImage(named: "tv")
        DispatchQueue.main.async {
            self.lblTitle.text = name
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
