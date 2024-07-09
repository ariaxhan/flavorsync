import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(red: 147/255, green: 223/255, blue: 164/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 32)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(red: 74/255, green: 192/255, blue: 100/255))
                            TextField("Username, Email", text: $viewModel.email)
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(red: 74/255, green: 192/255, blue: 100/255))
                            if isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                            }
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(Color(red: 74/255, green: 192/255, blue: 100/255))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        
                        HStack {
                            NavigationLink(destination: RegistrationView()) {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.resetPassword()
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        Button(action: {
                            viewModel.signIn()
                        }) {
                            Text("Login")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 74/255, green: 192/255, blue: 100/255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top, 8)
                        }
                    }
                    Spacer()
                }
            }
            .alert(isPresented: $viewModel.isAuthenticated) {
                Alert(title: Text("Login Successful"), message: Text("You have successfully logged in."), dismissButton: .default(Text("OK")))
            }
            .navigate(to: PreferencesView(), when: $viewModel.isAuthenticated)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
