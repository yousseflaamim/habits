//
//  RegisterView.swift
//  habits
//
//  Created by gio on 4/30/25.
//

import SwiftUI
import ProgressHUD

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @ObservedObject var authViewModel: AuthViewModel
    var switchToLogin: () -> Void
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.7), .pink.opacity(0.6)],
                          startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("Create an account")
                  .font(.system(size: 28, weight: .bold))
                  .foregroundColor(.white)

                VStack(spacing: 15) {
                TextField("Full Name", text: $displayName)
                   .padding()
                   .background(Color.white)
                    .cornerRadius(12)

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
                    ProgressHUD.animate("Signing up...")
                    authViewModel.register(email: email, password: password, displayName: displayName) { success, message in
                        if success {
                        ProgressHUD.succeed(message, delay: 1.5)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                        switchToLogin()
                        }
                         } else {
                        ProgressHUD.failed(message)
                        }
                }
                }) {
                    Text("Sign up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                Button(action: switchToLogin) {
                    Text("Have an account? Log in")
                     .foregroundColor(.white)
                     .padding(.top)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            
        }
    }
}
