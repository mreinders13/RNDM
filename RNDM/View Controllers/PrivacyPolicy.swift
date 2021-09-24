//
//  PrivacyPolicy.swift
//  RNDM
//
//  Created by Michael Reinders on 9/23/21.
//

import UIKit

class PrivacyPolicy: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAccept(_ sender: Any) {
        // continue
        let d = UserDefaults.standard
        d.set(true, forKey: "PolicyAccept")
        if let nav = self.navigationController {
            // reload tableview
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
            // segue
            nav.popViewController(animated: true)
        } else {
            // reload tableview
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadRandomTableView"), object: nil)
            // dismiss
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDeny(_ sender: Any) {
        // delete policy default and crash
        UserDefaults.standard.removeObject(forKey: "PolicyAccept")
        exit(0)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
