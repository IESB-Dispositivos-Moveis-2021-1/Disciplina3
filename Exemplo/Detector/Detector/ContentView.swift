//
//  ContentView.swift
//  Detector
//
//  Created by Pedro Henrique on 18/11/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    var pickerViewModel = ImageAcquisitionController()
    
    @ObservedObject
    var detectorViewModel = Detector()

    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                Text("Coloque a foto de uma flor para detectar a espécie")
                
                
                if detectorViewModel.loading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Text("Aguarde... identificando...")
                        Spacer()
                    }
                }else {
                    if let selectedImage = pickerViewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    if let result = detectorViewModel.detectorResult {
                        Text(result)
                    }
                    
                }
                
                HStack {
                    
                    Button("Usar a câmera") {
                        pickerViewModel.takePhoto()
                    }
                    Button("Escolher foto") {
                        pickerViewModel.choosePhoto()
                    }
                    
                }
            }
            .padding()
            .navigationTitle("Detector")
            .fullScreenCover(isPresented: $pickerViewModel.isPresentingPicker) {
                ImagePicker(sourceType: pickerViewModel.sourceType) { image in
                    if let image = image {
                        detectorViewModel.onImageSelected(image)
                        pickerViewModel.selectedImage = image
                    }
                    pickerViewModel.isPresentingPicker = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
