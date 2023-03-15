//
//  ResetPasswordView.swift
//  Petbook
//
//  Created by user233432 on 3/15/23.
//

import SwiftUI

struct ResetPasswordView: View {
  
 @State private var newpassword = ""
@State private var Cpassword = ""


var body: some View {
    VStack {
      
        Text("Reset Password")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 30)
                        
        SecureField("New password", text: $newpassword)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.bottom, 20)
        
        SecureField("Confirm password", text: $Cpassword)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.bottom, 20)
        
       
        .padding(.bottom, 20)
        
        
       
        
        Button(action: {
            // Perform login action
        }) {
            Text("Reset Password")
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
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
