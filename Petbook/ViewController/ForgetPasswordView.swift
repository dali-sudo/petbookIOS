//
//  ForgetPasswordView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct ForgetPasswordView: View {
    @ObservedObject var viewModel: ForgetPasswordViewModel = ForgetPasswordViewModel()
   @State private var email = ""
    @State private var emailError = false
    @State private var showAlert  = false
    @State private var showWrong  = false
    @State private var isLoading: Bool = false
    let defaults = UserDefaults.standard
    @State var shouldNavigate = false
  var body: some View {
      VStack {
        
          Text("Forget Password")
              .font(.largeTitle)
              .fontWeight(.bold)
              .padding(.bottom, 30)
          
          Text("Enter your E-mail for verification process                      ")
              .font(.subheadline)
              .multilineTextAlignment(.center)
              
              .padding(.bottom, 30)
         
          
          TextField             ("E-mail", text: $email,onEditingChanged: { isEditing in
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
          
         
          .padding(.bottom, 20)
          
          
         
          
          Button(action: {                if !emailError
              {
                  isLoading = true
                  viewModel.Forget(email: email) { result in
                      isLoading = false
                      switch result {
                      case .success(let ForgetPasswordResponse):
                          // Handle successful sign-in
                          shouldNavigate = true
                            
                                
                      
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

              // Perform login action
          }) {
              Text("Continue")
                  .foregroundColor(.white)
                  .font(.headline)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(Color.yellow)
                  .cornerRadius(10)
          }
          NavigationLink(destination: VerificationCodeView(email: $email), isActive: $shouldNavigate) {
                             EmptyView()
                         }          .padding(.bottom, 250)
      }
      .padding(.top,150)
      .padding(.horizontal)
  }
  }

struct ForgetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPasswordView()
    }
}
