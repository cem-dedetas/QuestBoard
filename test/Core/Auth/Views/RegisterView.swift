//
//  RegisterView.swift
//  test
//
//  Created by Cem Dedetas on 18.09.2023.
//

import SwiftUI

protocol RegisterFormProtocol {
    var isSubmitDisabled:Bool {get}
}

struct RegisterView: View {
    
    @State var scaleFactor:CGFloat = 1
    @State var email:String="";
    @State var password:String="";
    @State var confirmPassword:String="";
    @State var fullName:String="";
    
    @EnvironmentObject var authViewModel:AuthViewModel
    
    @Environment(\.dismiss) var dismiss;
    
    var body: some View {
        
        
        
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
            
                VStack(spacing:24){
                    Spacer()
                    InputView(text:$fullName, title: "Full Name", placeholder: "John Doe")
                    InputView(text:$email, title: "E-mail", placeholder: "example@email.com").textContentType(.emailAddress).keyboardType(.emailAddress)
                    InputView(text: $password, title: "Password", placeholder: "Enter Your Password",isSecureField:true).textInputAutocapitalization(.never)
                    ZStack{
                        InputView(text: $confirmPassword, title: "Confirm Pasword", placeholder: "Re-type your password",isSecureField:true).textInputAutocapitalization(.never)
                        HStack{
                            Spacer()
                            if(!(password==confirmPassword)){
                                Image(systemName: "x.circle.fill").foregroundColor(.red).scaledToFill()
                            }
                            else if (!password.isEmpty){
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green).scaledToFill()
                            }
                        }
                    }
                    
    
                    Button {
                        Task{
                            try await authViewModel.register(email:email, password:password, fullname:fullName)
                        }
                    }label : {
                        HStack{
                            Text("Register").fontWeight(.semibold)
                            Image(systemName: "arrow.right.square.fill")
                        }.foregroundColor(.white)
                            
                        
                    }.frame(width: UIScreen.main.bounds.width - 36, height: 40)
                        .background(Color(red: 0.55, green: 0.90, blue: 0.55)
                            .grayscale(isSubmitDisabled ? 1.0 :0.0))
                        .cornerRadius(5)
                        .disabled(isSubmitDisabled)
                    Spacer()
                    Button {
                        dismiss()
                    }label : {
                        HStack{
                            Text("Already have an acount?").fontWeight(.semibold).foregroundColor(.white)
                            Text("Sign In").fontWeight(.bold)
                        }
                    }
                }
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    
        }
    }
}

extension RegisterView: RegisterFormProtocol {
    var isSubmitDisabled:Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
        && !(password==confirmPassword)
        && !fullName.isEmpty
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
