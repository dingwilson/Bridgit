//
//  CameraViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/18/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import Firebase

class CameraViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    
    var ref: FIRDatabaseReference!
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var currentMinutes: Int!
    
    var checkTimer: Timer!
    
    var runTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMinutes = 0
        
        ref = FIRDatabase.database().reference()
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error: Error?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
                
                self.checkTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.takePhoto), userInfo: nil, repeats: true)
                
                self.runTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.iterateTime), userInfo: nil, repeats: true)
            }
        }
    }
    
    func getData() {
        if let savedId = UserDefaults.standard.string(forKey: "id") {
            ref.child("users").child("\(savedId)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print(value)
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func takePhoto() {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    if UserDefaults.standard.bool(forKey: "runScan") {
                        //self.analyzeImage(image: image)
                    }
                }
            })
        }
    }
    
    func iterateTime() {
        currentMinutes = currentMinutes + 1
        
        if let savedId = UserDefaults.standard.string(forKey: "id") {
            self.ref.child("users").child("\(savedId)").setValue(currentMinutes)
        }
    }
    
    func analyzeImage(image: UIImage) {
        uploadToImgur(image: image){success, url in
            if success {
                let url2 = "https://api.openalpr.com/v1/recognize?secret_key=sk_16a5bb91ed6618bd1d833d86&tasks=plate&country=us&image_url=\(url)"
                Alamofire.request(url2, method: .post).responseJSON { response in
                    debugPrint(response)
                    print(response);
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession!.stopRunning()
        self.checkTimer.invalidate()
        self.runTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
    }

    func uploadToImgur(image: UIImage, completionHandler:@escaping (Bool, URL) -> ()){
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        let base64Image = imageData.base64EncodedString(options: [])

        let headers = [
            "Content-Type": "multipart/form-data",
            "Authorization": "Client-ID d3ca4314706c161"
        ]

        let urlRequest = try! URLRequest(url: "https://api.imgur.com/3/image", method: .post, headers: headers)

        Alamofire.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(base64Image.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "image")
        }, with: urlRequest, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(data: response.data!)
                    print(json)
                    if let link = json["data"]["link"].string {
                        let url = URL(string: link)!
                        completionHandler(true, url)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(false, URL(string: "www.wilsonding.com")!)
            }
        })
    }

}
