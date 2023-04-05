//
//  SignUpView.swift
//  Petbook
//
//  Created by user233432 on 3/11/23.
//

import SwiftUI
struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel = SignUpViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @State private var emailError = false
    @State private var passwordError = false
    @State private var cpasswordError = false
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = false
    let defaults = UserDefaults.standard
    var body: some View {
        VStack {
            
            Image("Top")
                .ignoresSafeArea()
            
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            TextField("Full name", text: $fullName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email, onEditingChanged: { isEditing in
                if !isEditing {
                    if !email.isValidEmail {
                        emailError = true
                    } else {
                        emailError = false
                    }
                }
            })
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
            if emailError {
                Text("Please enter a valid email address.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
            }
            SecureField("Password", text: $password)
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
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .onChange(of:confirmPassword) { newValue in
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
            
            Button(action: {
                
                if !emailError && !passwordError && !cpasswordError
                {
                    isLoading = true
                    viewModel.signUp(fullname:fullName,email: email, password: password) { result in
                        isLoading = false
                        switch result {
                        case .success(let user):
                            // Handle successful sign-in
                            print("Account:", user)
                            defaults.set(user.email, forKey: "email")
                            defaults.set(user.fullname, forKey: "username")
                            defaults.set(user.id, forKey: "userId")
                            // Sync the changes to disk
                            defaults.synchronize()
                        
                        case .failure(let error):
                            // Handle sign                      -in error
                            showWrong = true
                         
                            print("Sign-up error:", error)
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
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(10)
            }
          
        }
            .padding(.bottom, 250)
            
      
    }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
