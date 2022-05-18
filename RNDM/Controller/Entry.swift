//
//  Entry.swift
//  RNDM
//
//  Created by Michael Reinders on 5/18/22.
//

import UIKit
import AppTrackingTransparency


class Entry: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if requestPermission() == true {
            goToMenu()
        }
    }
    
    func requestPermission() -> Bool {
        let s = DispatchSemaphore.init(value: 0)
        var result = false
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized")
                    result = true
                    s.signal()
                case .denied:
                    print("Denied")
                    result = true
                    s.signal()
                case .notDetermined:
                    print("Not Determined")
                    s.signal()
                case .restricted:
                    print("Restricted")
                    result = true
                    s.signal()
                @unknown default:
                    print("Unknown")
                    s.signal()
                }
            }
        } else {
            result = true // old phone, continue
            s.signal()
        }
        s.wait()
        return result
    }
    
    func goToMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NAV") as! UINavigationController
        DispatchQueue.main.async{self.present(nextViewController, animated:true, completion:nil)}
    }

    @IBAction func getStarted(_ sender: Any) {
        requestPermission()
        goToMenu()
    }
    

}
