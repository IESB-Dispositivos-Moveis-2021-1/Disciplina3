//
//  NotificationView.swift
//  HelloAuth
//
//  Created by Pedro Henrique on 25/11/21.
//

import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject
    var viewModel: NotificationViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Button("Notificação Local") {
                viewModel.scheduleLocalNotification(
                    with: "Acordar",
                    subtitle: "Tá na hora de sair cama!",
                    body: "Vai trabalhar, vagabundo!",
                    and: .defaultCritical)
            }
        }
        .navigationTitle("Notificações")
    }
}
