//
//  ViewController.swift
//  CoreMLImageApp
//
//  Created by Tatenda Kabike on 2019/12/13.
//  Copyright © 2019 Tatenda Kabike. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    let modelFile = MobileNetV2FP16()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imagePath = Bundle.main.path(forResource: "cat", ofType: "jpeg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        //Requesting image to examine
        let handler = VNImageRequestHandler(url: imageURL)
        
        //Examine the image and compare to trained data inside the Core ML model
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
        
        
        
    }
    
    
    func findResults(request: VNRequest, error: Error?){
        
        guard let results = request.results as? [VNClassificationObservation] else {
        
            fatalError("Unable to get results")
            
        }
            
            var bestGuess = ""
            var bestConfidence: VNConfidence = 0
            
        for classification in results {
            
            if (classification.confidence > bestConfidence){
                
                bestConfidence = classification.confidence
                bestGuess = classification.identifier
                
                
            }
        }
        
        descriptionLabel.text = "Image is: \(bestGuess) with confidence level of \(bestConfidence) out of 1"
        
            
        
        
    }


}

