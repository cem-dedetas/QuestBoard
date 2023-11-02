//
//  MessagesView.swift
//  test
//
//  Created by Cem Dedetas on 31.10.2023.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var authViewModel:AuthViewModel
    @StateObject var messagesViewModel = MultiChatViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                if let user = authViewModel.currentUser
                {
                    HStack{
                        NavigationLink{
                            ProfileView()
                        }
                        label :{
                            CachedImageView(url: user.profilePicUrl, width: 50)
                                .frame(height: 50)
                                .clipShape(Circle())
                            VStack(alignment: .leading){
                                Text(user.name)
                                Text(user.email).fontWeight(.light).font(.system(size: 10))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                            .tint(.primary)
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(.rect(cornerRadius: 10))
                        
                    }.containerRelativeFrame(.horizontal) { width, axis in
                        width - 16
                    }
                    Spacer()
                    if messagesViewModel.isLoading {
                        ProgressView()
                    }
                    else {
                        List{
                            ForEach(messagesViewModel.chats, id:\._id){chat in
                                NavigationLink{
                                    ChatView(chat: chat, chatViewModel: SingleChatViewModel(chatId: chat.chatUUID))
                                } label: {
                                        VStack(alignment: .leading){
                                            Text((chat.users[0]._id == authViewModel.currentUser?._id) ? chat.users[1].name : chat.users[0].name)
                                            Text("About: \(chat.advert.title)(\(enumStrings[chat.advert.adType.rawValue])").fontWeight(.light).font(.system(size: 12)).lineLimit(1)
                                        }
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
            }.onAppear{
                authViewModel.fetchUser()
                messagesViewModel.fetchData()
            }.navigationTitle("Messages")
        }
    }
}

#Preview {
    MessagesView()
}
