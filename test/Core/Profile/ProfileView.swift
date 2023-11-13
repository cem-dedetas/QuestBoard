//
//  ProfileView.swift
//  test
//
//  Created by Cem Dedetas on 25.10.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack{
                VStack{
                    HStack{
                        Text("Settings").font(.largeTitle).bold()
                        Spacer()
                    }.padding()
                    Form{
                        
                        Section{
                            NavigationLink{
                                EditProfileView()
                            }
                            label :{
                                HStack{
                                    if let user = authViewModel.currentUser{
                                        ProfilePicComponent(user: user, width: 50)
                                    }
                                    VStack(alignment: .leading){
                                        Text(authViewModel.currentUser?.name ?? "Username")
                                        Text(authViewModel.currentUser?.email ?? "email").fontWeight(.thin)
                                    }
                                }
                            }
                        }
                        Section{
                            NavigationLink{
                                Text("FAQ")
                            } label :{
                                Text("FAQ")
                            }
                            NavigationLink{
                                Text("Terms and Services")
                            } label :{
                                Text("Terms and Services")
                            }
                            NavigationLink{
                                Text("Privacy Policy")
                            } label :{
                                Text("Privacy Policy")
                            }
                        }
                        Section{
                            Button("Sign Out", role:.destructive) {
                                authViewModel.signOut()
                            }
                        }
                }
                }
                .onAppear{
                    authViewModel.fetchUser()
                }
        }
        
        
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}
