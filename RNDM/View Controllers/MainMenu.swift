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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Establish Unwind
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        print("Unwind to Main Menu")
    }

}
