//
//  SettingsTabView.swift
//  habits
//
//  Created by gio on 5/4/25.
//
import SwiftUI
import ProgressHUD

import SwiftUI
import ProgressHUD

struct SettingsTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var userViewModel: UserViewModel
    @State private var showingImagePicker = false
    @State private var showingNameEditor = false
    @State private var newDisplayName = ""
    
    init() {
        let user = FirebaseAuthService().currentUser()
        _userViewModel = StateObject(wrappedValue: UserViewModel(user: user))
    }
    
    var body: some View {
        NavigationView {
            Form {
                // profile sec
                Section(header: Text("Profile")
                    .font(.headline)
                    .foregroundColor(AppTheme.primaryColor)
                ) {
                    HStack(spacing: 16) {
                        
                        profileImageView
                        
                        userInfoView
                        
                        editButtonView
                    }
                    .padding(.vertical, 8)
                    
                    editNameButtonView
                }
                .listRowBackground(AppTheme.secondaryColor.opacity(0.3))
                
                // sec go out
                Section {
                    logoutButtonView
                }
                .listRowBackground(Color.clear)
            }
            .accentColor(AppTheme.primaryColor)
            .sheet(isPresented: $showingImagePicker) {
                
                //show ImagePicker
                 
                ImagePicker(image: { image in
                    userViewModel.updateProfileImage(image)
                    showingImagePicker = false
                })
            }
            .alert("Edit Display Name", isPresented: $showingNameEditor) {
                TextField("Display Name", text: $newDisplayName)
                Button("Save") {
                    userViewModel.updateDisplayName(newDisplayName)
                    showingNameEditor = false
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    // MARK: - stc vuew
    private var profileImageView: some View {
        Group {
            if let urlString = userViewModel.user?.profileImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView(progress: 1.5)
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.primaryColor, lineWidth: 2))
                .shadow(radius: AppTheme.shadowRadius)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(AppTheme.primaryColor.opacity(0.3))
            }
        }
    }
    
    private var userInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(userViewModel.user?.displayName ?? "No Name")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Text(userViewModel.user?.email ?? "No Email")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    private var editButtonView: some View {
        Button(action: { showingImagePicker = true }) {
            Image(systemName: "pencil.circle.fill")
                .font(.title2)
                .foregroundColor(AppTheme.accentColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var editNameButtonView: some View {
        Button(action: {
            newDisplayName = userViewModel.user?.displayName ?? ""
            showingNameEditor = true
        }) {
            HStack {
                Image(systemName: "textformat")
                    .foregroundColor(AppTheme.primaryColor)
                Text("Edit Display Name")
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var logoutButtonView: some View {
        Button(action: {
            ProgressHUD.animate("Signing out...", .circleStrokeSpin)
            authViewModel.logout()
            ProgressHUD.dismiss()
        }) {
            HStack {
                Spacer()
                Text("Sign Out")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 10)
            .background(AppTheme.accentColor)
            .cornerRadius(AppTheme.cornerRadius)
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var image: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image(uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}
