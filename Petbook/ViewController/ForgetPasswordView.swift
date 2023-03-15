//
//  ForgetPasswordView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct ForgetPasswordView: View {
    
   @State private var newpassword = ""
  @State private var Cpassword = ""


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
         
          
          TextField             ("E-mail", text: $Cpassword)
              .padding()
              .background(Color.gray.opacity(0.2))
              .cornerRadius(10)
              .padding(.bottom, 20)
          
         
          .padding(.bottom, 20)
          
          
         
          
          Button(action: {
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
          .padding(.bottom, 250)
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
