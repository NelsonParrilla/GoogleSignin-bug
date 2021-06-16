//
//  FirebaseCredentialProvider.swift
//
//

import Foundation
import Combine
import FirebaseAuth

class FirebaseCredentialProvider: NSObject {
    let subject = PassthroughSubject<(AuthCredential, String?), AuthenticationError>()
    let publisher: AnyPublisher<(AuthCredential, String?), AuthenticationError>

    override init() {
        publisher = subject.first().eraseToAnyPublisher()
        super.init()
    }

    func present() { fatalError("You must override FirebaseCredentialProvider.present()")}
}
