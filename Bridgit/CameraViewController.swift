//
//  CameraViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/18/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let savedName = UserDefaults.standard.string(forKey: "name") {
            print(savedName)
        }
        
        if let savedEmail = UserDefaults.standard.string(forKey: "email") {
            print(savedEmail)
        }
        
        if let savedImage = UserDefaults.standard.string(forKey: "imageUrl") {
            print(savedImage)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
