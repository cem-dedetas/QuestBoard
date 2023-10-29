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
                Form{
                    Section{
                        NavigationLink{
                            EditProfileView()
                        }
                        label :{
                            HStack{
                                if let imageUrl = authViewModel.currentUser?.profilePicUrl, !imageUrl.isEmpty {
                                    
                                    CachedImageView(url: imageUrl, width: 50).frame(height: 50).clipShape(Circle())
                                }
                                else{
                                    
                                        Image(systemName: "person.crop.circle.fill").resizable()
                                            .aspectRatio(1, contentMode: .fit).frame(height: 50)
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
            }.navigationTitle("Profile")
                .onAppear{
                    authViewModel.fetchUser()
                }
        }
        
        
    }
}

#Preview {
    ProfileView().environmentObject(AuthViewModel())
}
