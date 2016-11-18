//
//  SplashViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/17/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import SwiftVideoBackground
import FacebookCore
import FacebookLogin

class SplashViewController: UIViewController {

    @IBOutlet weak var backgroundVideo: BackgroundVideo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backgroundVideo.createBackgroundVideo(name: "Background", type: "mp4", alpha: 0.5)
    }
    
    @IBAction func facebookLoginButtonPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.returnUserData()
            }
        }
    }
    
    func returnUserData() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion)
        
        graphRequest.start() { response, result in
            switch result {
            case .failed(let error):
                print(error)
                
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    UserDefaults.standard.set(responseDictionary["name"] as! String, forKey: "name")
                    UserDefaults.standard.set(responseDictionary["email"] as! String, forKey: "email")
                    UserDefaults.standard.set(responseDictionary["id"] as! String, forKey: "id")
                    UserDefaults.standard.set(true, forKey: "runScan")
                }
                
                self.performSegue(withIdentifier: "segueToCamera", sender: self)
            }
        }
        
        
    }
}
