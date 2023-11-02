import Firebase

class SingleChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    var db = Firestore.firestore()
    var chatId: String // Unique ID for the chat
    var listener: ListenerRegistration?

    init(chatId: String) {
        self.chatId = chatId
        listenForMessages()
    }

    func listenForMessages() {
        print("trying to receive msg from \(chatId)")
        let messagesRef = db.collection("messaging").document("livemessages").collection(chatId)
            .order(by: "timestamp")
        
        // Snapshot listener to listen for new messages
        listener = messagesRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }

            self.messages = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                return Message(id: id, data: data)
            }
        }
    }

    func sendMessage(text: String, senderId: String, senderName: String) {
        print("trying to send msg to \(chatId)")
        let messageData: [String: Any] = [
            "text": text,
            "senderId": senderId,
            "senderName": senderName,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        let messagesRef = db.collection("messaging").document("livemessages").collection(chatId)
        
        messagesRef.addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }

    func stopListening() {
        listener?.remove()
    }
}

struct Message: Identifiable {
    let id: String
    let text: String
    let senderId: String
    let senderName: String
    let timestamp: Timestamp

    init(id: String, data: [String: Any]) {
        self.id = id
        self.text = data["text"] as? String ?? ""
        self.senderId = data["senderId"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
