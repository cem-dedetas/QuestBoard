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
    @State var scaleFactor:CGFloat = 0
    @State var email:String="";
    @State var password:String="";
    @EnvironmentObject var authViewModel:AuthViewModel
    
    var body: some View {
        
        
        NavigationStack{
            ZStack{
                Color(red: 0.6, green: 0.90, blue: 0.6).edgesIgnoringSafeArea(.all)
                Circle()
                    .scale(1.85*scaleFactor)
                    .fill(Color(red: 0.65, green: 0.95, blue: 0.65))
                    .animation(.easeInOut.delay(2), value: scaleFactor)
                Circle()
                    .scale(1.55*scaleFactor)
                    .fill(Color(red: 0.7, green: 0.95, blue: 0.7))
                    .animation(.easeInOut.delay(2), value: scaleFactor)
                Circle()
                    .scale(1.35*scaleFactor)
                    .fill(.white)
                    .animation(.easeInOut.delay(2), value: scaleFactor)
                
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
                                try await authViewModel.signIn(withEmail:email,password:password)
                            }
                        }label : {
                            HStack{
                                Text("Sign In").fontWeight(.semibold)
                                Image(systemName: "arrow.right.square.fill")
                            }.foregroundColor(.white)
                                
                            
                        }.frame(width: UIScreen.main.bounds.width - 36, height: 40)
                            .background(Color(red: 0.55, green: 0.90, blue: 0.55)
                                .grayscale(isSubmitDisabled ? 1.0 :0.0))
                            .cornerRadius(5)
                            .disabled(isSubmitDisabled)
                        Spacer()
                        NavigationLink {
                            RegisterView().navigationBarBackButtonHidden()
                        }label : {
                            HStack{
                                Text("Dont have an acount?").fontWeight(.semibold).foregroundColor(.white)
                                Text("Sign Up").fontWeight(.bold)
                            }
                        }
                    }
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        
            }
            .onAppear{
                withAnimation {
                    scaleFactor = 1.0
                }
            }
        }
    }
}

extension LoginView: LoginFormProtocol {
    var isSubmitDisabled:Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
    }
    
    
}

struct AuthpageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
