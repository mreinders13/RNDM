//
//  MainMenu.swift
//  RNDM
//
//  Created by Michael Reinders on 1/17/21.
//

import UIKit

class MainMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("Main Menu Loaded")
    }
    

    
    
    // MARK: Establish Unwind
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        print("Unwind to Main Menu")
    }

}
