//
//  ViewController.swift
//  Foodify
//
//  Created by Rishabh Jain on 12/23/20.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var classificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Some cosmetic adjustments to the UI to make the textfield look pretty
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.3580502272, blue: 0, alpha: 1)
        textField.layer.cornerRadius = 8.0;
        
//        classificationLabel.layer.borderWidth = 1.5
//        classificationLabel.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        classificationLabel.layer.cornerRadius = 8.0
//        classificationLabel.alpha = 0.5
    }

    @IBAction func selectPhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary

            present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera

            present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePicker.dismiss(animated: true, completion: nil)
        
            let image = info[.originalImage] as! UIImage
            imageView.image = image
            updateClassifications(for: image)
        }
    
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {return}
        let request = VNCoreMLRequest(model: model) { (VNRequest, err) in
            guard let results = VNRequest.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            let topClassifications = results.prefix(3)
            let descriptions = topClassifications.map { classification in
                // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
               return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
            }
            
            self.classificationLabel.numberOfLines = 4
            self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            
            self.classificationLabel.setNeedsDisplay()

            print( self.classificationLabel.text)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}

