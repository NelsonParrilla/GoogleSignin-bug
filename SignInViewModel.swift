//
//  SignInViewModel.swift
//
//

import Foundation
import Resolver
import Combine

final class SignInViewModel: NSObject, ObservableObject {
    
    @LazyInjected var authenticationRepository: AuthenticationRepository
    var provider: FirebaseCredentialProvider? = nil
    var subscription: AnyCancellable?
    @Published var isConnecting = false
    @Published var error: String? = nil

    override init() {
        super.init()
    }

    func onSignInWithApple() {
        let provider = FireBaseAppleCredentialProvider()
        signin(provider: provider)
    }

    func onSignInWithGoogle() {
        let provider = FirebaseGooglCredentialProvider()
        signin(provider: provider)
    }

    func signinWith(email: String, password: String) {
        let provider = FirebaseEmailPasswordCredentialProvider(email: email, password: password)
        signin(provider: provider)
    }

    private func signin(provider: FirebaseCredentialProvider) {
        self.provider = provider
        subscription?.cancel()
        isConnecting = true
        subscription = authenticationRepository.signInWith(provider: provider).sink(
            receiveCompletion: {
                self.isConnecting = false
                if case .failure(let error) = $0 {
                    self.error = error.localizedDescription
                }
            }, receiveValue: {
                print($0)
            })
        provider.present()
    }
    
}
