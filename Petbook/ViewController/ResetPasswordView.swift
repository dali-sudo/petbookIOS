//
//  ResetPasswordView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode   ; @ObservedObject var viewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    @Binding var email: String
    @State private var password = ""
    @State private var Cpassword = ""
    @State private var passwordError = false
    @State private var cpasswordError = false
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = false
    @State var shouldNavigate = false
    let defaults = UserDefaults.standard
    var body: some View {
        VStack {
            
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            SecureField("New password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .onChange(of: password) { newValue in
                    if newValue.count < 5 {
                        passwordError = true
                    } else {
                        passwordError = false
                    }
                }
            if passwordError {
                Text("Password must be at least 5 characters.")
                    .foregroundColor(.red)
            }
            SecureField("Confirm password", text: $Cpassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .onChange(of:Cpassword) { newValue in
                    if newValue != password {
                        cpasswordError = true
                    } else {
                        cpasswordError = false
                    }
                }
            if cpasswordError {
                Text("Password not matching.")
                    .foregroundColor(.red)
            }
            
            
            
            
            
            Button(action: { if !passwordError && !cpasswordError
                {
                isLoading = true
                viewModel.Reset(email: email, password: password) { result in
                    isLoading = false
                    switch result {
                    case .success(let user):
                        shouldNavigate = true                          case .failure(let error):
                        // Handle sign                      -in error
                        showWrong = true
                        
                        print("Reset Password error:", error)
                    }
                }
            }
                else {
                    showAlert = true
                }
                
                
                
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                else {
                    Text("Reset Password")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                NavigationLink(destination: LoginView(), isActive: $shouldNavigate) {
                    EmptyView()
                }
                       }
            .padding(.top,150)
            .padding(.horizontal)
        }
    }
}
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        let name = Binding.constant("John")
      
        ResetPasswordView(email:name)
    }
}
