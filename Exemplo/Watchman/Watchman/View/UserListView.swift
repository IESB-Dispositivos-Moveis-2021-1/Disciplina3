//
//  UserListView.swift
//  Watchman
//
//  Created by Pedro Henrique on 02/12/21.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject
    var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.loading {
                    showLoading()
                }else {
                    List {
                        ForEach(viewModel.users) { user in
                            VStack(alignment: .leading) {
                                NavigationLink(destination: UserDetailView(user: user)) {
                                    Text(user.name).font(.title2)
                                    Text(user.email).font(.subheadline)
                                }
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Watchman")
            .onAppear(perform: viewModel.fetchUsers)
        }
        .environmentObject(viewModel)
        
    }
    
    private func showLoading() -> some View {
        return VStack(alignment: .center) {
            ProgressView()
            Text("Aguarde! Carregando...")
        }
    }
    
}
