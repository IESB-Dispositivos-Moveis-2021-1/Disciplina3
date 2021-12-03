//
//  UserDetailView.swift
//  Watchman
//
//  Created by Pedro Henrique on 02/12/21.
//

import SwiftUI

struct UserDetailView: View {
    
    @EnvironmentObject
    var viewModel: UserViewModel
    
    let user: User
    
    var body: some View {
        VStack {
            Image(systemName: "applewatch")
                .font(Font.system(size: 60))
            Button("Enviar para Watch") {
                viewModel.sendToWatch(user)
            }
        }
        .navigationTitle(user.name)
    }
    
    
    
}
