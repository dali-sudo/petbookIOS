    import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: SignInViewModel = SignInViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var rememberMe = false
    @State private var selection: String? = nil
    @State private var emailError = false
    @State private var passwordError = false
    @State private var showAlert  = false
    @State private var showWrong  = false
    
    let defaults = UserDefaults.standard
    var body: some View {
        NavigationView
        {
        VStack {
            NavigationLink(destination: NavBarView().navigationBarBackButtonHidden(true), tag: "P", selection: $selection) { EmptyView() }
            Image("Top")
                .ignoresSafeArea()
                                            
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
            
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
                
            HStack {
                Toggle(isOn: $rememberMe) {
                    Text("Remember me")
                        .font(.subheadline)
                }
                                        
                Spacer()
                
              
            }
            VStack {
                // ...existing views here...
                NavigationLink(destination: ForgetPasswordView()) {
                    Text("Forgot password?")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }

            }
         
        
            Button(action: {
                print(String(emailError))
                print(String(passwordError))
                
                if emailError && passwordError
                {
                    showAlert = true
                   
                }
                else {
                    print("sending request")
                    isLoading = true
                    viewModel.signIn(email: email, password: password) { result in
                        isLoading = false
                        switch result {
                        case .success(let user):
                            // Handle successful sign-in
                            
                            
                            defaults.set(user.fullname, forKey: "username")
                            defaults.set(user.id, forKey: "userId")
                            defaults.set(user.password, forKey: "password")
                            defaults.set(user.token, forKey: "userToken")
                            
                            defaults.set(user.avatar,forKey : "avatar")
                            // Sync the changes to disk
                            defaults.synchronize()
                            selection = "P"
                        case .failure(let error):
                            // Handle sign                      -in error
                            showAlert = true
                         
                            print("Sign-in error:", error)
                        }
                    }
                   
                }
                
                    
                
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                               }
                else {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                                }
               
                    
            }
            .padding(.bottom, 250)
            .disabled(isLoading)
            .opacity(isLoading ? 0.5 : 1.0)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid credentials"), message: Text("Please enter valid email and password"), dismissButton: .default(Text("OK")))
            }
           
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
        
    }
}
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
