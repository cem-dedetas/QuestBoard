//
//  MessagesView.swift
//  test
//
//  Created by Cem Dedetas on 31.10.2023.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    @EnvironmentObject var authViewModel:AuthViewModel
    @StateObject var messagesViewModel = MultiChatViewModel()
    var body: some View {
        
            VStack{
                HStack{
                    Text("Messages").font(.largeTitle).bold()
                    Spacer()
                }.padding()
                if let user = authViewModel.currentUser
                {
                    HStack{
                        NavigationLink{
                            ProfileView()
                        }
                        label :{
//                            CachedImageView(url: user.profilePicUrl, width: 50)
//                                .frame(height: 50)
//                                .clipShape(Circle())
                            ProfilePicComponent(user: user, width: 50)
                            VStack(alignment: .leading){
                                Text(user.name)
                                Text(user.email).fontWeight(.light).font(.system(size: 10))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                            .tint(.primary)
                        
                    }.containerRelativeFrame(.horizontal) { width, axis in
                        width - 16
                    }
                    Divider()
                    Spacer()
                    if messagesViewModel.isLoading {
                        ProgressView()
                    }
                    else {
                        ScrollView(.vertical){
                            LazyVStack(alignment:.leading){
                                ForEach(messagesViewModel.chats, id:\._id){chat in
                                    ConversationsSubView(chat:chat, chatVM:SingleChatViewModel(chatId: chat.chatUUID))
                                    
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            .onAppear{
                authViewModel.fetchUser()
                messagesViewModel.fetchData()
            }
            
        
    }
}

#Preview {
    MessagesView()
}

struct ConversationsSubView: View {
    @EnvironmentObject var authViewModel:AuthViewModel
    
    let chat:Chat
    @StateObject var chatVM : SingleChatViewModel
    
    var body: some View {
        NavigationLink{
            ChatView(chat: chat, chatViewModel: chatVM)
        } label: {
            let otherUser:User = chat.users[0]._id == authViewModel.currentUser?._id ? chat.users[1] : chat.users[0]
            HStack{
                ProfilePicComponent(user: otherUser, width: 50)
                VStack(alignment: .leading){
//                    Text(otherUser.name)
                    Text("\(chat.advert.title)(\(enumStrings[chat.advert.adType.rawValue])").font(.callout).lineLimit(1)
                    if let lastMessage = chatVM.messages.last {
                        Text("\(lastMessage.senderName):\(lastMessage.text)").font(.caption).fontWeight(.light).lineLimit(1)
                    }
                }.padding(.horizontal)
                
                Spacer()
                if let lastMessage = chatVM.messages.last {
                    Text("\(formattedTime(from:lastMessage.timestamp))").font(.callout).fontWeight(.light).lineLimit(1)
                }
                Image(systemName: "chevron.right")
            }
            
        }
        .tint(.primary)
        .padding()
        .background(.thickMaterial)
        
        .onAppear {
            chatVM.listenForMessages()
        }
        .onDisappear {
            chatVM.stopListening()
        }
    }
}

func formattedTime(from timestamp: Timestamp) -> String {
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
    let currentDate = Date()
    
    // Check if the timestamp date is today
    if calendar.isDateInToday(timestamp.dateValue()) {
        dateFormatter.dateFormat = "HH:mm" // Set your desired time format
    } else {
        dateFormatter.dateFormat = "d MMM" // Set day and month format
    }
    
    let date = timestamp.dateValue()
    return dateFormatter.string(from: date)
}
