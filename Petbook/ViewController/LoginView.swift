    import SwiftUI

    struct LoginView: View {
        @State private var email = ""
        @State private var password = ""
        @State private var rememberMe = false
        
        var body: some View {
            VStack {
                Image("Top")
                  .ignoresSafeArea()
                 
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember me")
                            .font(.subheadline)
                    }
                                            
                    
                    Spacer()
                    
                  
                }
                .padding(.bottom, 20)
                
                
                Button(action: {
                    // Perform forgot password action
                }) {
                    Text("Forgot password?")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                
                Button(action: {
                    // Perform login action
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                .padding(.bottom, 250)
            }
            .padding()
        }
    }

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
