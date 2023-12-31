import SwiftUI
import _PhotosUI_SwiftUI
import Firebase

struct ChatView: View {
    let chat: Chat
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var chatViewModel: SingleChatViewModel
    @State var messageText = ""
//    @State private var scrollToBottom = false

    var body: some View {
        VStack {
            // Display messages in message bubbles
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatViewModel.messages.indices, id: \.self) { index in
                        if index > 0 {
                            let currentMessage = chatViewModel.messages[index]
                            let previousMessage = chatViewModel.messages[index - 1]
                            
                            let isCurrentUser = currentMessage.senderId == authViewModel.currentUser?._id
                            
                            let shouldShowTimestamp = shouldShowTime(currentMessage: currentMessage, previousMessage: previousMessage)
                            MessageBubbleView(message: currentMessage, isCurrentUser: isCurrentUser, showTimestamp: shouldShowTimestamp)
                                .id(currentMessage.id)
                        } else {
                            let message = chatViewModel.messages[index]
                            let isCurrentUser = message.senderId == authViewModel.currentUser?._id
                            MessageBubbleView(message: message, isCurrentUser: isCurrentUser, showTimestamp: true)
                                .id(message.id)
                        }
                            
                    }
                    .onChange(of: chatViewModel.messages.count, initial:true) { old, new in
                        withAnimation {
                            proxy.scrollTo(chatViewModel.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Compose and send messages
            MessageInputView(messageText: $messageText, sendMessage: sendMessage)
        }
        .navigationTitle(chat.users[0]._id == authViewModel.currentUser?._id ? chat.users[1].name : chat.users[0].name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AdDetailsView(advert: chat.advert)
                } label: {
                    HStack{
                        Text("Go to Ad")
                        Image(systemName: "chevron.right")
                    }
                }

            }
        }
    }
    
    func shouldShowTime(currentMessage: Message, previousMessage: Message) -> Bool {
        
            if currentMessage.senderId == previousMessage.senderId {
                let previousMessageDate = previousMessage.timestamp.dateValue()
                let currentMessageDate = currentMessage.timestamp.dateValue()
                
                let timeDifference = currentMessageDate.timeIntervalSince(previousMessageDate)
                return timeDifference > 5 * 60 // 5 minutes in seconds
            }
            return true
        }

    func sendMessage() {
        if let user = authViewModel.currentUser {
            let senderId = user._id
            let senderName = user.name
            chatViewModel.sendMessage(text: messageText, senderId: senderId, senderName: senderName)
            messageText = ""
        }
    }
}

struct MessageBubbleView: View {
    let message: Message
    let isCurrentUser: Bool
    let showTimestamp: Bool

    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            
            HStack {
                if isCurrentUser {
                    Spacer()
                    Text(message.text)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .foregroundColor(.black).clipShape(Capsule())
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .scaleEffect(1.2)
                                .offset(x:-3, y: -3)
                                .rotationEffect(.degrees(10.0))
                                .foregroundStyle(Color.blue)
                        }

                } else {
                    Text(message.text)
                        .padding()
                        .background(Color(red:0.8 ,green: 0.8,blue:0.8))
                        .foregroundColor(.black).clipShape(Capsule())
                        .overlay(alignment: .bottomLeading) {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .scaleEffect(1.2)
                                .offset(x:3, y: -3)
                                .rotationEffect(.degrees(-10.0))
                                .foregroundStyle(Color(red:0.8 ,green: 0.8,blue:0.8))
                        }
                    Spacer()
                }
            }
            if showTimestamp {
                Text("Sent: \(formattedTime(from: message.timestamp))")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
        }
        .padding(.horizontal)
        .padding(.top, showTimestamp && !isCurrentUser ? 4 : 0)
    }

    func formattedTime(from timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Check if the timestamp date is today
        if calendar.isDateInToday(timestamp.dateValue()) {
            dateFormatter.dateFormat = "HH:mm" // Set your desired time format
        } else {
            dateFormatter.dateFormat = "d MMM HH:mm" // Set day and month format
        }
        
        let date = timestamp.dateValue()
        return dateFormatter.string(from: date)
    }

}
struct MessageInputView: View {
    @Binding var messageText: String
    @State var isImagePickerPresented = false
    @State var selectedImages:[UIImage] = []
    var sendMessage: () -> Void

    var body: some View {
        VStack{
            ScrollView(.horizontal){
                LazyHStack(spacing:25){
                    ForEach(selectedImages, id:\.self){image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .overlay(alignment: .topTrailing) {
                                Button{
                                    selectedImages.removeAll { _image in
                                        _image == image
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill").font(.title).tint(.red)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(height:150)
                            .containerRelativeFrame(.horizontal){width,axis  in
                                width - 150
                            }
                            
                    }
                    
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            
            HStack {
                TextField("Type a message", text: $messageText)
    //                .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading,5).onSubmit {
                        sendMessage()
                    }

                Button{
                    isImagePickerPresented.toggle()
                } label: {
                    Image(systemName: "paperclip").scaleEffect(1.2).padding(.horizontal)
                }
                Button(action: sendMessage) {
                    Image(systemName: "paperplane").scaleEffect(1.2).padding(.trailing)
                }
            }
            .sheet(isPresented: $isImagePickerPresented){
                ImagePicker(selectedImages: $selectedImages, maxSelectionCount: 10).ignoresSafeArea(.all)
                
            }
            .padding()
            .background(.thickMaterial)
        }
    }
}
