//
//  AuthenticationManager.swift
//  flavorsync
//
//  Created by Aria Han on 7/9/24.
//

import Foundation
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
