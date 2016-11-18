//
//  LeaderBoardViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/18/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import Firebase

class LeaderBoardViewController: UIViewController {
    
    var savedName : String?
    var savedEmail : String?
    var savedId : String?
    var runScan : Bool!
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        saveValues()
        
        getData()
    }
    
    func getData() {
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict)
        })
    }
    
    func saveValues() {
        if let savedName = UserDefaults.standard.string(forKey: "name") {
            self.savedName = savedName
        }
        
        if let savedEmail = UserDefaults.standard.string(forKey: "email") {
            self.savedEmail = savedEmail
        }
        
        if let savedId = UserDefaults.standard.string(forKey: "id") {
            self.savedId = savedId
        }
        
        self.runScan = UserDefaults.standard.bool(forKey: "runScan")
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
