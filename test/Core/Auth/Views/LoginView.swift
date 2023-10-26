//
//  SwiftUIView.swift
//  test
//
//  Created by Cem Dedetas on 18.09.2023.
//

import SwiftUI

protocol LoginFormProtocol {
    var isSubmitDisabled:Bool {get}
}

struct LoginView: View {
    @State var scaleFactor:CGFloat = 1
    @State var email:String="";
    @State var password:String="";
    @EnvironmentObject var authViewModel:AuthViewModel
    
    var body: some View {
        
        
        NavigationStack{
            ZStack{
                Color(red: 0.6, green: 0.90, blue: 0.6).edgesIgnoringSafeArea(.all)
                Circle()
                    .scale(1.50*1.5*scaleFactor)
                    .fill(.thinMaterial)
                Circle()
                    .scale(1.50*1.25*scaleFactor)
                    .fill(.regularMaterial)
                Circle()
                    .scale(1.50*scaleFactor)
                    .fill(.thickMaterial)
                    .shadow(color:.gray.opacity(0.2) ,radius: 5)
                    
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    VStack(spacing:24){
                        Spacer()
                        InputView(text:$email, title: "E-mail", placeholder: "example@email.com").textInputAutocapitalization(.never).textContentType(.emailAddress).keyboardType(.emailAddress)
                        InputView(text: $password, title: "Password", placeholder: "Enter Your Password",isSecureField:true).textInputAutocapitalization(.never)
                        HStack(){
                            Spacer()
                            Button {
                                //Do something
                            }label : {
                                Text("Forgot Password?").fontWeight(.semibold)
                            }
                        }
                        Button {
                            Task{
                                try await authViewModel.signIn(email:email,password:password)
                            }
                        }label : {
                            HStack{
                                Text("Sign In").fontWeight(.semibold)
                                Image(systemName: "arrow.right.square.fill")
                            }.foregroundColor(.white)
                            
                            
                        }.frame(width: UIScreen.main.bounds.width - 36, height: 40)
                            .background( !isSubmitDisabled ?
                                         Color(red: 0.55, green: 0.90, blue: 0.55)
                                        :
                                            Color.secondary
                            )
                            .cornerRadius(5)
                            .disabled(isSubmitDisabled)
                        Spacer()
                        NavigationLink {
                            RegisterView().navigationBarBackButtonHidden()
                        }label : {
                            HStack{
                                Text("Dont have an acount?").fontWeight(.semibold)
                                Text("Sign Up").fontWeight(.bold)
                            }
                        }
                    }
                    .autocapitalization(.none)
                    .padding(.horizontal)
                }
            }
            
        }
    }
}

extension LoginView: LoginFormProtocol {
    var isSubmitDisabled:Bool {
        return !(!email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
)    }
    
    
}

struct AuthpageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
