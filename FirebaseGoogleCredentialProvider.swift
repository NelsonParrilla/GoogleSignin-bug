//
//  FirebaseGoogleCredentialProvider.swift
//
//

import Foundation
import GoogleSignIn
import Firebase
import Combine

class FirebaseGoogleCredentialProvider: FirebaseCredentialProvider {
    override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        GIDSignIn.sharedInstance()?.presentingViewController = rootVC
    }

    override func present() {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension FirebaseGoogleCredentialProvider: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      if let error = error {
        Log.auth.error("google auth error :\(error.localizedDescription)")
        let authError = error as NSError
        if authError.code == -5 { // don't show error if cancelled
            subject.send(completion: .finished)
            return
        }
        subject.send(completion: .failure(AuthenticationError.error("")))
        return
      }

      guard let authentication = user.authentication else {
        subject.send(completion: .failure(AuthenticationError.error("")))
        return

      }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        Log.auth.info("google authenticated")
        subject.send((credential, nil))
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        Log.auth.info("google did logout")
    }
}

