//
//  EditProfileView.swift
//  test
//
//  Created by Cem Dedetas on 26.10.2023.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel : AuthViewModel
    @State var newEmail:String = ""
    @State var newUsername:String = ""
    @State var isFullscreen:Bool = false
    @State var isConfirmPresented:Bool = false
    @State var isAddPhotoPresented:Bool = false
    
    var body: some View {
        
        VStack{
            Group{
                if let imageUrl =  authViewModel.currentUser?.profilePicUrl {
                    Button{
                        isFullscreen = true
                    } label :{
                            CachedImageView(url: imageUrl, width: 150).frame(height: 150).clipShape(Circle())
                        
                    }
                    
                    
                }
                else {
                Image(systemName: "person.crop.circle.fill").resizable()
                    .aspectRatio(1, contentMode: .fit).frame(height: 150)
            }
            }.overlay(alignment: .bottomTrailing){
                Button{
                    isConfirmPresented.toggle()
                } label :{
                    Image(systemName: "pencil")
                }.foregroundStyle(.white)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(Circle())

                
            }
                
            Form{
                Section{
                    TextField(authViewModel.currentUser?.name ?? "username",text: $newUsername)
                    TextField(authViewModel.currentUser?.email ?? "email@email.com",text: $newEmail)
                }
            }
        }
        .confirmationDialog("Confirmation Dialog", isPresented: $isConfirmPresented, actions: {
            Button("Add new photo", action: {
                isAddPhotoPresented.toggle()
            })
            Button("Cancel", role: .cancel, action: {})
            Button("Remove existing photo", role: .destructive, action: {})
        })
        .sheet(isPresented: $isFullscreen){
            if let imageUrl =  authViewModel.currentUser?.profilePicUrl {
                FullscreenImageView(urls: [imageUrl], selectedIndex: .constant(1))
            }
        }
        .navigationDestination(isPresented: $isAddPhotoPresented){
            AddProfilePhotoView()
        }
        .onAppear{
            authViewModel.fetchUser()
        }
    }
}

#Preview {
    EditProfileView()
}
