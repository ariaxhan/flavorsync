import SwiftUI
import Combine
import Firebase

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noUserSignedIn
        }
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            throw handleAuthError(error)
        }
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            throw handleAuthError(error)
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch let error as NSError {
            throw handleAuthError(error)
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            throw handleAuthError(error)
        }
    }
    
    private func handleAuthError(_ error: NSError) -> AuthError {
        if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                return .invalidEmail
            case .emailAlreadyInUse:
                return .emailAlreadyInUse
            case .weakPassword:
                return .weakPassword
            case .wrongPassword:
                return .wrongPassword
            case .userNotFound:
                return .userNotFound
            default:
                return .unknownError(error.localizedDescription)
            }
        }
        return .unknownError(error.localizedDescription)
    }
}

enum AuthError: LocalizedError {
    case noUserSignedIn
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case wrongPassword
    case userNotFound
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .noUserSignedIn:
            return "No user is currently signed in."
        case .invalidEmail:
            return "The email address is badly formatted."
        case .emailAlreadyInUse:
            return "The email address is already in use by another account."
        case .weakPassword:
            return "The password must be 6 characters long or more."
        case .wrongPassword:
            return "The password is invalid or the user does not have a password."
        case .userNotFound:
            return "There is no user record corresponding to this identifier. The user may have been deleted."
        case .unknownError(let message):
            return message
        }
    }
}

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
                let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
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
                let _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
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
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        do {
            try AuthenticationManager.shared.signOut()
            self.isAuthenticated = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

struct NavigateModifier<Destination: View>: ViewModifier {
    var destination: Destination
    @Binding var isActive: Bool

    func body(content: Content) -> some View {
        NavigationLink(
            destination: destination,
            isActive: $isActive,
            label: {
                EmptyView()
            }
        )
        .hidden()
    }
}

extension View {
    func navigate<Destination: View>(to destination: Destination, when binding: Binding<Bool>) -> some View {
        self.modifier(NavigateModifier(destination: destination, isActive: binding))
    }
}
