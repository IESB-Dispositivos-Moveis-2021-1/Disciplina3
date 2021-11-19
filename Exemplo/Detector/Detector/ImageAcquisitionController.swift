//
//  CameraController.swift
//  Detector
//
//  Created by Pedro Henrique on 18/11/21.
//

import Foundation
import UIKit.UIImage

class ImageAcquisitionController: ObservableObject {
    
    private(set) var sourceType = ImagePicker.SourceType.photoLibrary
    
    @Published
    var selectedImage: UIImage?
    
    @Published
    var isPresentingPicker = false
    
    
    func takePhoto() {
        sourceType = .camera
        isPresentingPicker = true
    }
    
    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingPicker = true
        
    }
    
}
