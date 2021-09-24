//
//  Login.swift
//  RNDM
//
//  Created by Michael Reinders on 1/13/21.
//

import UIKit
import AuthenticationServices

class Login: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSOAppleSignIn()

        if let userIdentifier = UserDefaults.standard.object(forKey: "userIdentifier1") as? String {
              let authorizationProvider = ASAuthorizationAppleIDProvider()
              authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
                  switch (state) {
                  case .authorized:
                      print("Account Found - Signed In")
                      DispatchQueue.main.async {
                        /* Present Main Menu
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "MainMenu")
                        self.present(controller, animated: true, completion: nil)*/
                      }
                      break
                  case .revoked:
                      print("No Account Found")
                      fallthrough
                  case .notFound:
                       print("No Account Found")
                       DispatchQueue.main.async {
                            //self.showLogInViewController(scene: windowScene)
                       }
                      
                  default:
                      break
                  }
              }
        }
    }
    
    
    func setupSOAppleSignIn() {
        let btnAuthorization = ASAuthorizationAppleIDButton()
        btnAuthorization.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        btnAuthorization.center = self.view.center
        btnAuthorization.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        self.view.addSubview(btnAuthorization)
        }

    @objc func handleLogInWithAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    
}
// MARK: Extensions
extension Login: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
        
            let defaults = UserDefaults.standard
            defaults.set(userIdentifier, forKey: "userIdentifier1")
            
            // Present Main Menu
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainMenu")
            self.present(controller, animated: true, completion: nil)
            
            break
        default:
            break
        }
    }
}

extension Login: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}
