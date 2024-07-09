//
//  AuthenticationViewModel.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import SwiftUI
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func signUp() {
        Task {
            do {
                let user = try await AuthenticationManager.shared.createUser(email: email, password: password)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signIn() {
        Task {
            do {
                let user = try await AuthenticationManager.shared.signInUser(email: email, password: password)
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func resetPassword() {
        Task {
            do {
                try await AuthenticationManager.shared.resetPassword(email: email)
                DispatchQueue.main.async {
                    self.errorMessage = "Password reset email sent."
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
