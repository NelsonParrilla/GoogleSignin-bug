//
//  SigninView2.swift
//  Mementop
//
//  Created by Frédéric TRISSON on 17/12/2020.
//

import SwiftUI
import GoogleSignIn

struct ConnectionView: View {
    @StateObject private var viewModel = SignInViewModel()
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()
    @Environment(\.safeArea) private var safeArea
    @Binding var showDemo: Bool

    var body: some View {
        let showError = Binding(
            get: { viewModel.error != nil },
            set: { if !$0 { viewModel.error = nil }}
        )

        return VStack(spacing: 0) {
            VStack(spacing: 24) {
                signinButton(text: L.signin.withApple.localized, imageName: I.connection_apple) {
                    viewModel.onSignInWithApple()
                }

                signinButton(text: L.signin.withGoogle.localized, imageName: I.connection_google) {
                    viewModel.onSignInWithGoogle()
                }
            }
            Spacer()

            UserConditionsText()
                .frame(height: 50)
                .padding(.bottom, 24)
        }
        .padding(.bottom, safeArea.bottom)
        .padding(.top, 36)
        .padding(.horizontal, 32)
        .alert(isPresented: showError) {
            Alert(title: Text(L.errorOccured.localized), message: Text(viewModel.error ?? ""), dismissButton: .default(Text(L.close.localized)))
        }
        .showOverlay(isPresenting: $viewModel.isConnecting) {
            ProgressView()
        }
    }

    private func signinButton(text: String, imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 18, height: 18)

                Spacer()

                Text(text)
                    .font(.bodyRegular)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.jumbo, lineWidth: 1.0))
            .shadowElevation(.elevation1)
        }

    }

    private func login(email: String, password: String) {
        loginViewModel.email = email
        loginViewModel.password = password
        loginViewModel.submit(){  }
    }
}
