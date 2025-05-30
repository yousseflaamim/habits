//
//  LoginView.swift
//  habits
//
//  Created by gio on 4/30/25.
//

import SwiftUI
import ProgressHUD



struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @ObservedObject var authViewModel: AuthViewModel
    var switchToRegister: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.7), .purple.opacity(0.6)],
                          startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("Login")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

                VStack(spacing: 15) {
                TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(12)

                SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                }

                Button(action: {
                    ProgressHUD.animate("Is loggin...")
                    authViewModel.login(email: email, password: password) { result in
                        switch result {
                        case .success:
                            ProgressHUD.succeed("Welcome!", delay: 1.5)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                                authViewModel.isAuthenticated = true
                            }

                        case .failure(let error):
                            ProgressHUD.failed("Login failed: \(error.localizedDescription)")
                        }
                    }
                    
                }) {
                Text("Login")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
                }

                Button(action: switchToRegister) {
                Text("Don't have an account? Register now")
                .foregroundColor(.white)
                .padding(.top)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
