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

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        saveValues()
        
        getData()
    }
    
    func getData() {
        ref.child("users").observe(.childAdded, with: { (snapshot) -> Void in
            let key = snapshot.key
            let value = snapshot.value as? NSDictionary
            
            let name : String = value!.value(forKey: "name") as! String
            let point : Int = value!.value(forKey: "point") as! Int
            print(name)
            print(point)
//            self.FirebaseSharedDatabase[key] = DatabaseObject(n: name, a: age)// Adds the Database object to the dictionary
//            label.text = String(self.FirebaseSharedDatabase.count)
        })
        
//        ref.child("users").observe(FIRDataEventType.value, with: { (snapshot) in
//            let key = snapshot.key
//            let value = snapshot.value as? NSDictionary
//            print(value)
////            let name : String = value!.value(forKey: "name") as! String
////            let point : Int = value!.value(forKey: "point") as! Int
//////            let points : Int = value!.value(forKey)
//        
//            
//        })
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
