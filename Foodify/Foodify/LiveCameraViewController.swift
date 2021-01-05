//
//  LiveCameraViewController.swift
//  Foodify
//
//  Created by Rishabh Jain on 1/4/21.
//

import UIKit
import AVKit
import Vision

class LiveCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start up the camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        // Display the camera feed
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
  
        print("Camera")
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
//        let request = VNCoreMLRequest(model: <#T##VNCoreMLModel#>)
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: <#T##[VNImageOption : Any]#>)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
//        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else {return}
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {return}
        
        let request = VNCoreMLRequest(model: model) { (VNRequest, err) in
//            print(VNRequest.results)
            
            guard let results = VNRequest.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            print(firstObservation.identifier, firstObservation.confidence)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}