//
//  ContentView.swift
//  WatchmanWatch WatchKit Extension
//
//  Created by Pedro Henrique on 02/12/21.
//

import SwiftUI
//import Watchman

struct ContentView: View {
    
    @ObservedObject
    var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.selectedUser?.name ?? "Selecione no iPhone")
            Button("De volta") {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
