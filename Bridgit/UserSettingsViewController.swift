//
//  UserSettingsViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/18/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import Eureka

class UserSettingsViewController: FormViewController {
    
    var savedName : String?
    var savedEmail : String?
    var savedId : String?
    var runScan : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveValues()
        
        buildForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildForm() {
        form +++
            Section(){ section in
                section.header = {
                    var header = HeaderFooterView<UIView>(.callback({
                        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250))
                        let imageView = UIImageView(image: UIImage(named: "transparenticon"))
                        imageView.contentMode = .scaleAspectFill
                        imageView.imageFromUrl(urlString: "http://graph.facebook.com/\(self.savedId!)/picture?type=large")
                        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
                        view.addSubview(imageView)
                        return view
                    }))
                    header.height = { 250 }
                    return header
                }()
            }
        +++ Section("Personal Details")
            <<< TextRow(){ row in
                row.title = "Name"
                row.value = "\(savedName!)"
            }
            <<< EmailRow(){
                $0.title = "Email"
                $0.value = "\(savedEmail!)"
            }
        
        +++ Section("User Settings")
            <<< SwitchRow() {
                $0.title = "Run License Plate Recognition"
                $0.value = runScan
                }.onChange { row in
                    if row.value! {
                        UserDefaults.standard.set(true, forKey: "runScan")
                    }
                    else {
                        UserDefaults.standard.set(false, forKey: "runScan")
                    }
            }
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

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
