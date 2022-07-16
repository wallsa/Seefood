//
//  ViewController.swift
//  Seefood
//
//  Created by Wallace Santos on 15/07/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CI Image")
            }
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true)
        
        
    }
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            fatalError("Loading CoreML module failed")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to featch results")
            }
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier.capitalized
                print(firstResult.confidence.binade)
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
            do{
                try handler.perform([request])
            }
        catch{
            print(error)
        }
        
    }

    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true)
    }
    
    
    
    
}

