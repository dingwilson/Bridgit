//
//  PairingViewController.swift
//  Bridgit
//
//  Created by Wilson Ding on 11/17/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import UIKit
import AVFoundation

class PairingViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        connectButton.isHidden = true
        
        scanQRCode()
    }

    func scanQRCode() {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            let deviceOrientation = UIDevice.current.orientation
            
            if deviceOrientation == .landscapeLeft{
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            }
            
            else {
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            }
            
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label and connection button to the top view
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: connectButton)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 5
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                connectButton.isHidden = false
            }
        }
    }
    
    override func didRotate(from interfaceOrientation: UIInterfaceOrientation) {
        
        switch UIDevice.current.orientation{
        case .landscapeLeft:
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            
        case .landscapeRight:
            videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            
        default:
            print("FAIL")
        }
    }
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(messageLabel.text!, forKey: "connection")
        performSegue(withIdentifier: "beginCreationSegue", sender: self)
    }
}
