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
    var savedImage : String?
    var savedId : String?

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
                        imageView.contentMode = .scaleAspectFit
                        imageView.imageFromUrl(urlString: "http://graph.facebook.com/\(self.savedId)/picture?type=large")
                        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
                        view.addSubview(imageView)
                        return view
                    }))
                    header.height = { 100 }
                    return header
                }()
            }
        +++ Section("\(savedName)")
    }
    
    func saveValues() {
        if let savedName = UserDefaults.standard.string(forKey: "name") {
            self.savedName = savedName
        }
        
        if let savedEmail = UserDefaults.standard.string(forKey: "email") {
            self.savedEmail = savedEmail
        }
        
        if let savedId = UserDefaults.standard.string(forKey: "id") {
            print(savedId)
        }
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
