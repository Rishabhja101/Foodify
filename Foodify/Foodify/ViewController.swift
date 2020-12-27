//
//  ViewController.swift
//  Foodify
//
//  Created by Rishabh Jain on 12/23/20.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.3580502272, blue: 0, alpha: 1)
        textField.layer.cornerRadius = 8.0;
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
            imageView.image = info[.originalImage] as? UIImage
        }
}

