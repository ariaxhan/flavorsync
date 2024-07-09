//
//  RegistrationView.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack {
            // Background color
            Color(red: 147/255, green: 223/255, blue: 164/255)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color(red: 74/255, green: 192/255, blue: 100/255))
                        TextField("Email", text: $viewModel.email)
                            .foregroundColor(.white)
                            .padding(.leading, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(red: 74/255, green: 192/255, blue: 100/255))
                        TextField("Username", text: $viewModel.username)
                            .foregroundColor(.white)
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
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(.white)
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
                    
                    Button(action: {
                        viewModel.signUp()
                    }) {
                        Text("Register")
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
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Already have an account? Log In")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                }
                Spacer()
            }
        }
        .alert(isPresented: $viewModel.isAuthenticated) {
            Alert(title: Text("Registration Successful"), message: Text("You have successfully registered."), dismissButton: .default(Text("OK")))
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
