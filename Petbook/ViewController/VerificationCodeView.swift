//
//  VerificationCodeView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct VerificationCodeView: View {
    
   @State private var code = ""
  


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

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}
