//
//  ContentView.swift
//  MyId
//
//  Created by Pedro Henrique on 09/12/21.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {

    @State
    private var isUnlocked = false
    
    var body: some View {
        VStack(alignment: .center) {
            if isUnlocked {
                Text("Acesso permitido")
            }else {
                Text("Acesso negado")
            }
        }.onAppear(perform: authenticate)
    }
    
    private func authenticate() {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Precisamos verificar para desbloquear seus dados"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                isUnlocked = success
            }
            
            
        }else {
            debugPrint("O dispositivo não tem autenticação biométrica configurada.")
        }
    }
    
}

