//
//  FlowerDetector.swift
//  Detector
//
//  Created by Pedro Henrique on 18/11/21.
//

import UIKit
import CoreML
import Vision

class Detector: ObservableObject {
    
    private var classificationRequest: VNRequest?
    
    @Published
    private(set) var detectorResult: String? {
        didSet {
            loading = false
        }
    }
    
    @Published
    private(set) var loading = false
    
    
    init() {
        setupModel()
    }
    
    
    
    private func setupModel() {
        let configuration = MLModelConfiguration()
        configuration.allowLowPrecisionAccumulationOnGPU = true
        
        if let model = try? VNCoreMLModel(for: GenderDetector(configuration: configuration).model) {
            classificationRequest = VNCoreMLRequest(model: model, completionHandler: handleClassification(request:error:))
        }
    }
    
    private func handleClassification(request: VNRequest, error: Error?) {
        guard error == nil else { debugPrint(error!); return }
        
        var text = ""
        for result in request.results ?? [] {
            if let observation = result as? VNClassificationObservation {
                text.append("Espécie: \(observation.identifier), com confiaça \(observation.confidence * 100)%\n")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self!.detectorResult = text
        }
    }
    
    func onImageSelected(_ image: UIImage) {
        loading = true
        if let cg = image.cgImage {
            let ci = CIImage(cgImage: cg)
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.classify(image: ci)
            }
            
        }
    }
    
    func classify(image: CIImage) {
        guard let request = classificationRequest else { return }
        
        do {
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])
        }catch {
            debugPrint(error)
        }
    }
    
    
}
