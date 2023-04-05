//
//  EditProfileView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

        struct EditProfileView: View {
            @State private var name: String = ""
            @State private var email: String = ""
            @State private var password: String = ""
            @State private var image: UIImage? = nil
            @State private var emailError = false
            @State private var passwordError = false
            @State private var isLoading: Bool = false
            @State private var showAlert  = false
            @State private var IsPickerShowing  = false
            @ObservedObject var viewModel: EditUserProfileViewModel = EditUserProfileViewModel()
            let defaults = UserDefaults.standard

            var body: some View {
                VStack(spacing: 20) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                    }

                    Button("Change Photo") {
                        print("clicked")
                        IsPickerShowing = true
                        // TODO: Implement logic to select a new photo
                    }
                    .foregroundColor(.blue)

                    TextField("Name", text: $name)
                       
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
                                        if newValue.count < 3 {
                                            passwordError = true
                                        } else {
                                            passwordError = false
                                        }
                                    }
                                if passwordError {
                                    Text("Password must be at least 3 characters.")
                                        .foregroundColor(.red)
                                }

                    Button(action: {
                        
                        if emailError && passwordError
                        {
                            showAlert = true
                            
                        }
                        else {
                            isLoading = true
                            viewModel.editProfile(email: email, password: password, username: name, avatar: image){ result in
                                isLoading = false
                                switch result {
                                case .success(let user):
                                    // Handle successful sign-in
                                    print("user edited:", user)
                                    defaults.set(user.email, forKey: "email")
                                    defaults.set(user.fullname, forKey: "username")
                                    defaults.set(user.id, forKey: "userId")
                                    // Sync the changes to disk
                                    defaults.synchronize()
                                   
                                case .failure(let error):
                                    // Handle sign                      -in error
                                   
                                 
                                    print("Sign-in error:", error)
                                }
                            }                        }
                        // Perform login action
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                       }
                        else{
                            
                            Text("Save")
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
                .padding(.top,150)
                .padding(.horizontal)
                .disabled(isLoading)
                .opacity(isLoading ? 0.5 : 1.0)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invalid credentials"), message: Text("Please enter valid email and password"), dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $showAlert, onDismiss: nil)
                {
                    ImagePicker(selectedImage: $image, isPicker: $IsPickerShowing)
                }
                
              
            }
        }



        struct EditProfileView_Previews: PreviewProvider {
            static var previews: some View {
                EditProfileView()
            }
        }                                   
                            
