//
//  VerificationCodeView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct VerificationCodeView: View {
    @ObservedObject var viewModel: VerificationCodeViewModel = VerificationCodeViewModel()
   @State private var code = ""
    @Binding var email: String
   

     @State private var showAlert  = false
     @State private var showWrong  = false
     @State private var isLoading: Bool = false
     let defaults = UserDefaults.standard
     @State var shouldNavigate = false
    var body: some View {
      VStack {
        
          Text("Enter Code                      ")
              .font(.largeTitle)
              .fontWeight(.bold)
          .multilineTextAlignment(.center)
              .padding(.bottom, 30)
          
          Text("Enter the code that you received in mail                                     ")
              .font(.subheadline)
              .multilineTextAlignment(.center)
              
              .padding(.bottom, 30)
         
                        
        TextField("Code", text: $code)
              .padding()
              .background(Color.gray.opacity(0.2))
              .cornerRadius(10)
              .padding(.bottom, 20)
          
         
          .padding(.bottom, 20)
          
          
         
          
          Button(action: {
              // Perform login action if !emailError
              
                  isLoading = true
                  viewModel.Verif(email: email,code: code) { result in
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
             
          ) {
              Text("Continue")
                  .foregroundColor(.white)
                  .font(.headline)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(Color.yellow)
                  .cornerRadius(10)
          }
          NavigationLink(destination: ResetPasswordView(email: $email), isActive: $shouldNavigate) {
                             EmptyView()
                         }              .padding(.bottom, 250)
      }
      .padding(.top,150)
      .padding(.horizontal)
  }
  }

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let name = Binding.constant("John")
        VerificationCodeView(email:name)
    }
}
